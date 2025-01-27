-- models/staging/stg_tpch_line_items.sql

-- Configuration explicite pour s'assurer que c'est une vue
{{ config(materialized='view') }}

SELECT
    {{
        dbt_utils.generate_surrogate_key([
            'l_orderkey',
            'l_linenumber'
        ])
    }} as order_item_key,

    l_orderkey as order_key,  -- renommé pour cohérence avec stg_orders
    l_partkey as part_key,
    l_linenumber as line_number,
    l_quantity as quantity,
    l_extendedprice as extended_price,
    l_discount as discount_percentage,
    l_tax as tax_rate

FROM
    {{ source('tpch', 'lineitem') }}

