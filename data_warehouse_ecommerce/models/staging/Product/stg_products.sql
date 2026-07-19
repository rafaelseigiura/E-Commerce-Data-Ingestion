WITH product as (
	SELECT 
		row_number() over(
			partition by product_id
			order by ingestion_timestamp desc
			) as rn,	
		product_id, 
		trim(product_category_name) as product_category_name, 
		coalesce(product_name_lenght,0) as product_name_length, 
		coalesce(product_description_lenght, 0) as product_description_lenght, 
		coalesce(product_photos_qty, 0) as product_photos_qty, 
		product_weight_g, 
		product_length_cm, 
		product_height_cm, 
		product_width_cm, 
		ingestion_timestamp
	FROM 
		bronze.olist_products
)
SELECT 	
	product_id, 
	product_category_name, 
	product_name_length, 
	product_description_lenght, 
	product_photos_qty, 
	product_weight_g, 
	product_length_cm, 
	product_height_cm, 
	product_width_cm, 
	ingestion_timestamp 
FROM 
	product
where 
	rn = 1