# airflow/dags/dbt_retail_analytics_improved.py

from datetime import timedelta
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.dummy import DummyOperator
from plugins.dbt_operators import DbtRunOperator

# Default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Path to your dbt project
DBT_PROJECT_DIR = '/path/to/your/dbt_project'

# Create the DAG
dag = DAG(
    'dbt_retail_analytics_improved',
    default_args=default_args,
    description='Orchestrate retail analytics dbt models with custom operator',
    schedule_interval='0 5 * * *',
    start_date=days_ago(1),
    tags=['dbt', 'retail'],
)

# Task groups
start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)

# Stage models
run_staging = DbtRunOperator(
    task_id='run_staging',
    dbt_project_dir=DBT_PROJECT_DIR,
    models='staging',
    dag=dag,
)

# Intermediate models
run_intermediate = DbtRunOperator(
    task_id='run_intermediate',
    dbt_project_dir=DBT_PROJECT_DIR,
    models='intermediate',
    dag=dag,
)

# Mart models
run_marts = DbtRunOperator(
    task_id='run_marts',
    dbt_project_dir=DBT_PROJECT_DIR,
    models='marts',
    dag=dag,
)

# Set dependencies
start >> run_staging >> run_intermediate >> run_marts >> end