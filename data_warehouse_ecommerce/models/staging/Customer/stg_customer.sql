WITH customer AS(
	SELECT 
		customer_id, 
		customer_unique_id, 
		cast(customer_zip_code_prefix as int) as zip_code_prefix, 
		trim(silver.remover_caracteres_especiais(customer_city)) as city, 
		trim(upper(customer_state)) as state, 
		ingestion_timestamp,
		row_number() over(
			partition by customer_id,ingestion_timestamp 
			order by customer_id,ingestion_timestamp desc
			) as rn
		
	FROM bronze.olist_customers
	)
	select 
		customer_id, 
		customer_unique_id, 
		zip_code_prefix, 
		city, 
		state, 
		ingestion_timestamp as last_ingestion_timestamp
	from 
		customer
	where
		rn = 1

	