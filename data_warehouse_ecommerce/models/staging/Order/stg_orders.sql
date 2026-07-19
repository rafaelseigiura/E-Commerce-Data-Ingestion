with orders as (
	SELECT 
		row_number() over(
			partition by order_id,customer_id 
			order by ingestion_timestamp desc
			) as rn,	
		order_id, 
		customer_id, 
		order_status, 
		to_timestamp(order_purchase_timestamp, 'YYYY-MM-DD HH24:MI:SS') as purchase_timestamp, 
		to_timestamp(order_approved_at, 'YYYY-MM-DD HH24:MI:SS') as order_approved_at, 
		to_timestamp(order_delivered_carrier_date, 'YYYY-MM-DD HH24:MI:SS') as delivered_carrier_date, 
		to_timestamp(order_delivered_customer_date, 'YYYY-MM-DD HH24:MI:SS') as delivered_customer_date, 
		to_timestamp(order_estimated_delivery_date, 'YYYY-MM-DD HH24:MI:SS') as estimated_delivery_date, 
		ingestion_timestamp
	FROM
		bronze.olist_orders
)

select 
	*
from
	orders
where 
	rn = 1