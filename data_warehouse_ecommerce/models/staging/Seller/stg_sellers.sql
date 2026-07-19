with sellers as (
	SELECT 
		row_number() over(
			partition by seller_id
			order by ingestion_timestamp desc
			) as rn,
		seller_id, 
		seller_zip_code_prefix as zip_code_prefix, 
		silver.remover_caracteres_especiais(seller_city) as city, 
		seller_state as state, 
		ingestion_timestamp
	FROM 
		bronze.olist_sellers
)

select * from sellers
where rn = 1