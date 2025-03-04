with customer_spending as (
    select * from {{ ref('customer_spending') }}
)

, segments as (
    select
        *,
        case 
            when lifetime_value > 300000 then 'High Value'
            when lifetime_value > 100000 then 'Medium Value'
            else 'Low Value'
        end as value_segment,
        case
            when datediff('day', most_recent_order_date, current_date()) <= 90 then 'Active'
            when datediff('day', most_recent_order_date, current_date()) <= 365 then 'At Risk'
            else 'Churned'
        end as activity_segment
    from customer_spending
)

select
    value_segment,
    activity_segment,
    count(*) as customer_count,
    sum(lifetime_value) as total_value,
    avg(lifetime_value) as average_value
from segments
group by 1, 2
order by 1, 2