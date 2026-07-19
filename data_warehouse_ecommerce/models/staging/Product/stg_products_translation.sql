WITH product_translation as(
	SELECT 
		row_number() over(
			partition by product_category_name
			order by ingestion_timestamp desc
			) as rn,
		product_category_name, 
		product_category_name_english, 
		source_file, 
		source_path, 
		ingestion_timestamp, 
		ingestion_date
	FROM 
		bronze.olist_product_category_name_translation
)
select *  from product_translation