with order_items as (
    select * from {{ ref('int_order_items') }}
),

customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),

order_facts as (
    select
        customer_orders.order_id,
        customer_orders.order_date,
        customer_orders.customer_id,
        customer_orders.customer_name,
        customer_orders.market_segment,
        sum(order_items.quantity) as total_items,
        count(distinct order_items.part_id) as unique_items,
        sum(order_items.final_price) as total_amount,
        min(order_items.ship_date) as first_ship_date,
        max(order_items.ship_date) as last_ship_date,
        datediff('day', customer_orders.order_date, max(order_items.ship_date)) as days_to_ship
    from customer_orders
    left join order_items on customer_orders.order_id = order_items.order_id
    group by 1, 2, 3, 4, 5
)

select * from order_facts