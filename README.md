# mipt-dms-hw

Репозиторий с решениями ДЗ по курсу системы хранения и обработки данных. 

## Запуск

Перед запуском jupyter блокнота с решением нужно:

1. Установить python зависимости из `requirements.txt`.

2. Развернуть базу данных на выбор с помощью docker контейнера:
    - postgres

    ```
    docker-compose postgres up
    ```

    - MongoDB

    ```
    docker-compose mongo up
    ```
