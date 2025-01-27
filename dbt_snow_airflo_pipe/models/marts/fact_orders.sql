-- models/marts/fact_orders.sql
WITH calculated_line_items AS (
    SELECT
        order_item_key,
        orderkey,
        partkey,
        linenumber,
        quantity,
        extendedprice,
        discount_percentage,
        tax_rate,
        -- Calculs business avec cast explicite pour éviter les erreurs de conversion
        CAST(extendedprice * (1 - NULLIF(discount_percentage, 0)) AS FLOAT) as discounted_price,
        CAST(extendedprice * (1 - NULLIF(discount_percentage, 0)) * (1 + NULLIF(tax_rate, 0)) AS FLOAT) as final_price
    FROM {{ ref('stg_tpch_line_items') }}
)

SELECT 
    -- Clés
    order_item_key,
    orderkey as order_key,
    partkey as part_key,
    
    -- Mesures originales
    quantity,
    extendedprice as extended_price,
    discount_percentage,
    tax_rate,
    
    -- Mesures calculées
    discounted_price,
    final_price,
    
    -- Timestamps et métadonnées
    CURRENT_TIMESTAMP() as dbt_updated_at

FROM calculated_line_items