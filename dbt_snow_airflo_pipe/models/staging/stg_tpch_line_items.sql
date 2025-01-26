SELECT

    {{
        dbt_utils.generate_surrogate_key([
            'l_orderkey',
            'l_linenumber'
        ])
    }} as order_item_key,

    l_orderkey as orderkey,
    l_partkey as partkey,
    l_linenumber as linenumber,
    l_quantity as quantity,
    l_extendedprice as extendedprice,
    l_discount as discount_percentage,
    l_tax as tax_rate,

FROM
    {{ source('tpch', 'lineitems') }}