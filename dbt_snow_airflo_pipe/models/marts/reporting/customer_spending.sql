with fact_orders as (
    select * from {{ ref('fact_orders') }}
),

customer_spending as (
    select
        customer_id,
        customer_name,
        market_segment,
        count(distinct order_id) as number_of_orders,
        sum(total_amount) as lifetime_value,
        avg(total_amount) as average_order_value,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        datediff('day', min(order_date), max(order_date)) as customer_lifetime_days
    from fact_orders
    group by 1, 2, 3
)

select * from customer_spending