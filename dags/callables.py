
def dummy_processor(**context):
    context['ti'].xcom_push(key='links', value=['https://druid.apache.org/data/wikipedia.json.gz'])
    context['ti'].xcom_push(key='intervals', value=['2015-09-12/2015-09-13'])
