from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.apache.druid.operators.druid import DruidOperator
from datetime import datetime, timedelta
from dags.callables import dummy_processor

# Default settings applied to all tasks
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

with DAG('druid-ingest',
         start_date=datetime(2021, 5, 5),
         max_active_runs=3,
         schedule_interval=None,
         default_args=default_args,
         ) as dag:

    # A dummy processor which pushes the uris and intervals to backend db using xcom
    # this can be any processor which sinks the processed data to s3 or gs and pushes the links using xcom.
    dummy_processor = PythonOperator(task_id='dummy_processor',
                                     python_callable=dummy_processor)

    # a sample druid operator which pulls the uris and intervals from dependent operators. ex: dummy_processor operator
    # replaces the links and intervals in the wikipedia-index.json dynamically
    ingest_data = DruidOperator(task_id='druid_ingest',
                                json_index_file='wikipedia-index.json',
                                druid_ingest_conn_id='druid_ingest_conn_id')

    dummy_processor >> ingest_data
