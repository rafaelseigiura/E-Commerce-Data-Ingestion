WITH ORDER_ITEM AS (
	SELECT 
		row_number() over(
			partition by	
				order_id, 
				order_item_id
			order by ingestion_timestamp desc
		) as rn,
		order_id, 
		order_item_id, 
		product_id, 
		seller_id, 
		to_timestamp(shipping_limit_date, 'YYYY-MM-DD HH24:MI:SS') as shipping_limit_date, 
		price, 
		freight_value, 
		ingestion_timestamp
	FROM bronze.olist_order_items
)
SELECT 
	order_id, 
	order_item_id, 
	product_id, 
	seller_id, 
	shipping_limit_date, 
	price, 
	freight_value, 
	ingestion_timestamp
FROM ORDER_ITEM
where rn = 1