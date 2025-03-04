SELECT
    order_id,
    amount
FROM {{ ref('int_customer_orders') }}
WHERE amount <= 0