SELECT 
	product_id,
	a.product_category_name,
	b.product_category_name_english,
	product_name_length,
	product_description_lenght as product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm,
	(product_length_cm *	product_height_cm *	product_width_cm)/1000.0 as product_volume_litros
	
FROM 
	SILVER.stg_products a
left join silver.stg_products_translation b on a.product_category_name = b.product_category_name 
