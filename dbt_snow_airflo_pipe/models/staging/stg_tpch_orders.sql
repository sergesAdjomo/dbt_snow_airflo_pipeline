{{ config(materialized='view', snowflake_warehouse='dbt_snow_wh') }}

SELECT
  o_orderkey,
  o_custkey,
  o_orderstatus,
  o_totalprice,
  o_orderdate,
  o_orderpriority,
  o_clerk,
  o_shippriority,
  o_comment
FROM
  {{ source('tpch', 'orders') }}