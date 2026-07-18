WITH order_payments as (
	SELECT 
		row_number() over(
			partition by	
				order_id, 
				payment_sequential,
				payment_type
			order by ingestion_timestamp desc
		) as rn,		
		order_id, 
		payment_sequential, 
		payment_type, 
		payment_installments, 
		payment_value,
		ingestion_timestamp
	FROM bronze.olist_order_payments
)
select 
	order_id, 
	payment_sequential, 
	payment_type, 
	payment_installments, 
	payment_value,
	ingestion_timestamp
from 
	order_payments
where rn = 1
order by 1,2,3