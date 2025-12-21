import os
import pandas as pd

from datetime import datetime
from airflow.providers.postgres.hooks.postgres import PostgresHook
from sqlalchemy import text



DEFAULT_START_DATE = datetime(2025, 12, 20)


def get_postgres_engine():
    hook = PostgresHook(postgres_conn_id="postgres")
    return hook.get_sqlalchemy_engine()


def data_file_path(file_name):
    return os.path.join("/opt/airflow/data", file_name)


def run_sql_script(file_path, params=None):
    engine = get_postgres_engine()
    with open(file_path) as file:
        sql_script = file.read()
    return pd.read_sql(sql_script, engine)
