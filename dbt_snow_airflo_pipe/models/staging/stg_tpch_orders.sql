SELECT
  o_orderkey as order_key,
  o_custkey as custkey_key,
  o_orderstatus as status_key,
  o_totalprice as totalprice,
  o_orderdate as orderdate,


FROM
  {{ source('tpch', 'orders') }}
