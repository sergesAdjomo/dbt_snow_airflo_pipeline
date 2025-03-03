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
- Python 3.8+
- pip (Python package installer)
- (Coming soon) Apache Airflow

## Detailed Setup Instructions

### 1. Install Required Packages
```bash
# Install dbt core and snowflake adapter
pip install dbt-core
pip install dbt-snowflake
```

### 2. Snowflake Account Setup
Before proceeding with dbt configuration, ensure you have:
1. A Snowflake account with appropriate access
2. Created necessary database objects:
   - Database
   - Schemas (dev, prod)
   - Warehouse
   - Roles with appropriate privileges

### 3. Initialize DBT Project
```bash
# Initialize a new dbt project
dbt init

# Follow the interactive prompts:
1. Enter your project name
2. Select 'snowflake' as your database
3. Configure Snowflake credentials:
   - Account (your_account.region.cloud_platform)
   - User
   - Password
   - Role
   - Warehouse
   - Database
   - Schema
   - Number of threads
```

### 4. Configure dbt_project.yml
Your `dbt_project.yml` should be configured with:
```yaml
name: 'your_project_name'
version: '1.0.0'
config-version: 2

profile: 'your_profile_name'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

target-path: "target"
clean-targets:
    - "target"
    - "dbt_packages"

models:
  your_project_name:
    staging:
      +materialized: view
    intermediate:
      +materialized: table
    marts:
      +materialized: table
```

### 5. Configure profiles.yml
Create/update `~/.dbt/profiles.yml`:
```yaml
your_profile_name:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account
      user: your_user
      password: your_password
      role: your_role
      warehouse: your_warehouse
      database: your_database
      schema: your_schema
      threads: 4
```

## Model Organization
The project follows a layered architecture:
- **Staging**: Raw data models with minimal transformations
- **Intermediate**: Models that combine and transform staging models
- **Marts**: Business-level aggregations and final models

## Testing
- Schema tests are defined in `.yml` files
- Custom data tests in `tests/` directory
- Run tests using `dbt test`

## Usage
1. Clone the repository
2. Follow the setup instructions above
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
