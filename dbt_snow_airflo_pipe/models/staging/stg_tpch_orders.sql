-- models/staging/stg_tpch_orders.sql

-- Configuration explicite pour s'assurer que c'est une vue
{{ config(materialized='view') }}

SELECT
    o_orderkey as order_key,
    o_custkey as customer_key,  -- renommé pour plus de clarté
    o_orderstatus as status_key,
    o_totalprice as total_price,  -- ajout du underscore pour cohérence
    o_orderdate as order_date    -- ajout du underscore pour cohérence
FROM 
    {{ source('tpch', 'orders') }}

    