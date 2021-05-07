from airflow import DAG
from airflow.providers.apache.druid.operators.druid import DruidOperator
from datetime import datetime, timedelta

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
    ingest_data = DruidOperator(task_id='druid_ingest',
                                json_index_file='wikipedia-index.json',
                                druid_ingest_conn_id='druid_ingest_conn_id')
