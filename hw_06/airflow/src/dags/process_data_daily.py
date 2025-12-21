import os
import pandas as pd

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.utils.email import send_email
from airflow.utils.trigger_rule import TriggerRule

from utils import (
    data_file_path,
    get_postgres_engine,
    run_sql_script,
    DEFAULT_START_DATE,
)

DAG_ID = "process_data_daily"

ALERT_EMAIL_TO = "me@example.com"

FIRST_QUERY_NAME = "top_3_min_3_profit"
SECOND_QUERY_NAME = "top_5_wealth_segment"


class DataCollector:
    def __init__(self, name, separator=","):
        self._name = name
        self._separator = separator
    
    def __call__(self):
        """
        Считывает данные из csv таблицы и загружает в бд.
        """
        csv_path = data_file_path(f"data_csv/{self._name}.csv")
        df = pd.read_csv(csv_path, sep=self._separator)
        engine = get_postgres_engine()
        df.to_sql(self._name, engine, if_exists="replace", index=False)


class QueryRunner:
    def __init__(self, sql_query_name):
        self._sql_query_name = sql_query_name
    
    def __call__(self, **context):
        """
        Выполняет заданный sql запрос из директории с sql сриптами и сохраняет
        результат в output директорию.  
        """
        run_id = context["run_id"]
        result_df = run_sql_script(data_file_path(f"sql/{self._sql_query_name}.sql"))

        # Обнуление результат команд чтобы посмотреть как email приходит.
        # result_df = result_df.drop(result_df.index)

        save_result_path = QueryRunner.result_query_path(run_id, self._sql_query_name)
        os.makedirs(os.path.dirname(save_result_path), exist_ok=True)
        result_df.to_csv(save_result_path, index=False, encoding="utf-8")

    @staticmethod
    def result_query_path(run_id, sql_query_name):
        return data_file_path(f"output/{DAG_ID}/{run_id}/{sql_query_name}.csv")


def check_queries_result(**context):
    run_id = context["run_id"]
    files_paths = [
        QueryRunner.result_query_path(run_id, FIRST_QUERY_NAME),
        QueryRunner.result_query_path(run_id, SECOND_QUERY_NAME),
    ]

    notify_empty_result = False
    for path in files_paths:
        df = pd.read_csv(path)

        if df.shape[0] == 0:
            notify_empty_result = True
            break

    if notify_empty_result:
        subject = "Airflow Alert: empty query result"
        html_content = f"""
        <p>Check queries result failed, one of result contains zero rows</p>
        <p>DAG: {DAG_ID}</p>
        <p>Run ID: {context['run_id']}</p>
        """

        send_email(to=[ALERT_EMAIL_TO], subject=subject, html_content=html_content)


def end_dag(**context):
    dag_run = context["dag_run"]
    failed_tasks = [
        t.task_id for t in dag_run.get_task_instances() if t.state == "failed"
    ]
    print(f"Failed tasks:", failed_tasks)
    status = "failed" if len(failed_tasks) else "success"
    print(f"DAG finished with status:", status)


with DAG(
    dag_id=DAG_ID,
    start_date=DEFAULT_START_DATE,
    schedule="@daily",
    catchup=False,
) as dag:
    collect_data_tasks = [
        PythonOperator(
            task_id="collect_customer", 
            python_callable=DataCollector("customer", separator=";")
        ),
        PythonOperator(
            task_id="collect_order_items", 
            python_callable=DataCollector("order_items")
        ),
        PythonOperator(
            task_id="collect_orders", 
            python_callable=DataCollector("orders")
        ),
        PythonOperator(
            task_id="collect_product", 
            python_callable=DataCollector("product")
        ),
    ]

    end_data_collecting_task = EmptyOperator(task_id="end_data_collecting")

    for task in collect_data_tasks:
        task >> end_data_collecting_task

    query_tasks = [
        PythonOperator(
            task_id="run_first_query",
            python_callable=QueryRunner(FIRST_QUERY_NAME),
        ),
        PythonOperator(
            task_id="run_second_query",
            python_callable=QueryRunner(SECOND_QUERY_NAME),
        ),
    ]
    end_queries_task = EmptyOperator(task_id="end_queries")

    for task in query_tasks:
        end_data_collecting_task >> task
        task >> end_queries_task

    check_queries_result_task = PythonOperator(
        task_id="check_queries_result", python_callable=check_queries_result
    )

    end_queries_task >> check_queries_result_task

    end_dag_task = PythonOperator(
        task_id="end_dag_task",
        python_callable=end_dag,
        trigger_rule=TriggerRule.ALL_DONE,
    )

    check_queries_result_task >> end_dag_task
