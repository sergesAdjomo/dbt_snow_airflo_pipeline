# airflow/dags/dbt_dag.py

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from airflow.sensors.external_task import ExternalTaskSensor
from airflow.operators.dummy import DummyOperator

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
    'dbt_retail_analytics',
    default_args=default_args,
    description='Orchestrate retail analytics dbt models',
    schedule_interval='0 5 * * *',  # Run at 5 AM every day
    start_date=days_ago(1),
    tags=['dbt', 'retail'],
)

# Starting point
start = DummyOperator(
    task_id='start',
    dag=dag,
)

# Check for source data
data_check = BashOperator(
    task_id='data_check',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt source snapshot-freshness --select source:snowflake',
    dag=dag,
)

# Run dbt seeds (if any)
seed_data = BashOperator(
    task_id='seed_data',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt seed',
    dag=dag,
)

# Run staging models
run_staging_models = BashOperator(
    task_id='run_staging_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --models staging',
    dag=dag,
)

# Test staging models
test_staging_models = BashOperator(
    task_id='test_staging_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --models staging',
    dag=dag,
)

# Run intermediate models
run_intermediate_models = BashOperator(
    task_id='run_intermediate_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --models intermediate',
    dag=dag,
)

# Test intermediate models
test_intermediate_models = BashOperator(
    task_id='test_intermediate_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --models intermediate',
    dag=dag,
)

# Run mart models
run_mart_models = BashOperator(
    task_id='run_mart_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt run --models marts',
    dag=dag,
)

# Test mart models
test_mart_models = BashOperator(
    task_id='test_mart_models',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt test --models marts',
    dag=dag,
)

# Generate documentation
generate_docs = BashOperator(
    task_id='generate_docs',
    bash_command=f'cd {DBT_PROJECT_DIR} && dbt docs generate',
    dag=dag,
)

# Finishing point
end = DummyOperator(
    task_id='end',
    dag=dag,
)

# Define task dependencies
start >> data_check >> seed_data >> run_staging_models >> test_staging_models
test_staging_models >> run_intermediate_models >> test_intermediate_models
test_intermediate_models >> run_mart_models >> test_mart_models
test_mart_models >> generate_docs >> end