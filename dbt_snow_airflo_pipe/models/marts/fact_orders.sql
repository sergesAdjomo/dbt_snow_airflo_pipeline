-- models/marts/fact_orders.sql

-- Configuration explicite pour s'assurer que c'est une table
{{ config(
    materialized='table',
    schema='marts_fact_schema'
) }}

WITH line_items AS (
    SELECT
        order_item_key,
        order_key,
        part_key,
        line_number,
        quantity,
        extended_price,
        discount_percentage,
        tax_rate
    FROM {{ ref('stg_tpch_line_items') }}
),

orders AS (
    SELECT
        order_key,
        customer_key,
        status_key,
        total_price,
        order_date
    FROM {{ ref('stg_tpch_orders') }}
),

final AS (
    SELECT 
        li.order_item_key,
        li.order_key,
        o.customer_key,
        li.part_key,
        o.order_date,
        -- Mesures originales
        li.quantity,
        li.extended_price,
        li.discount_percentage,
        li.tax_rate,
        -- Mesures calculées
        li.extended_price * (1 - COALESCE(li.discount_percentage, 0)) as discounted_price,
        li.extended_price * (1 - COALESCE(li.discount_percentage, 0)) * (1 + COALESCE(li.tax_rate, 0)) as final_price
    FROM line_items li
    JOIN orders o ON li.order_key = o.order_key
)

SELECT 
    *,
    CURRENT_TIMESTAMP() as dbt_updated_at
FROM final