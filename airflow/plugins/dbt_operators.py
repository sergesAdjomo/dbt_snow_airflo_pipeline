# airflow/plugins/dbt_operators.py

from airflow.operators.bash import BashOperator
from airflow.utils.decorators import apply_defaults

class DbtRunOperator(BashOperator):
    """
    Operator to run dbt commands
    """
    
    @apply_defaults
    def __init__(
        self,
        dbt_project_dir,
        models=None,
        exclude=None,
        select=None,
        full_refresh=False,
        *args, **kwargs
    ):
        self.dbt_project_dir = dbt_project_dir
        self.models = models
        self.exclude = exclude
        self.select = select
        self.full_refresh = full_refresh
        
        # Build the dbt command
        dbt_cmd = f"cd {dbt_project_dir} && dbt run"
        
        if models:
            dbt_cmd += f" --models {models}"
        
        if exclude:
            dbt_cmd += f" --exclude {exclude}"
            
        if select:
            dbt_cmd += f" --select {select}"
            
        if full_refresh:
            dbt_cmd += " --full-refresh"
        
        kwargs['bash_command'] = dbt_cmd
        super().__init__(*args, **kwargs)