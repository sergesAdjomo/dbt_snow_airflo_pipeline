# DBT Snowflake Data Pipeline Project

## Project Overview
This project implements a data transformation pipeline using dbt (data build tool) with Snowflake as the data warehouse. The pipeline is designed to be orchestrated with Apache Airflow (upcoming integration).

## Project Structure
```
dbt_snowflake/
├── analyses/
├── macros/
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/
├── snapshots/
├── tests/
└── dbt_project.yml
```

## Prerequisites
- Snowflake account and credentials
- dbt Core installed
- Python 3.8+
- (Coming soon) Apache Airflow

## Configuration
1. Ensure your `profiles.yml` is properly configured with your Snowflake credentials
2. The project uses the following default configurations in `dbt_project.yml`:
   - Custom schema naming
   - Materialization strategies
   - Model-specific configurations

## Models
The project follows a layered architecture:
- **Staging**: Raw data models with minimal transformations
- **Intermediate**: Models that combine and transform staging models
- **Marts**: Business-level aggregations and final models

## Testing
- Schema tests are defined in `.yml` files
- Custom data tests in `tests/` directory
- Run tests using `dbt test`

## Current Status
✅ Implemented:
- dbt project structure
- Core transformations
- Data models
- Tests and documentation

🚧 In Progress:
- Apache Airflow integration for orchestration
- Task scheduling and dependencies
- Pipeline monitoring and alerting

## Upcoming Features (Airflow Integration)
- DAG creation for dbt tasks
- Automated scheduling
- Dependencies management
- Error handling and notifications
- Monitoring dashboard

## Usage
1. Clone the repository
2. Set up your `profiles.yml`
3. Run `dbt deps` to install dependencies
4. Run `dbt build` to execute all models

## Development Guidelines
- Follow dbt coding conventions
- Document all models in `.yml` files
- Write tests for new models
- Use git for version control

## Contributing
1. Create a feature branch
2. Make your changes
3. Run tests
4. Submit a pull request

## Contact
For questions or issues, please contact the project maintainers.

Note: This is a work in progress. The Airflow integration phase will begin soon to orchestrate the entire pipeline.
