with geolocation as ( --- total de linhas 1.000.163
	SELECT 
		ROW_NUMBER() OVER(
			PARTITION BY
				geolocation_zip_code_prefix,
				geolocation_lat,
				geolocation_lng,
				geolocation_city,
				geolocation_state		
			ORDER BY
				ingestion_timestamp DESC
			) AS rn,
		geolocation_zip_code_prefix as zip_code_prefix, 
		geolocation_lat as lat,
		geolocation_lng as long,  
		silver.remover_caracteres_especiais(geolocation_city) as city, 
		geolocation_state as state, 
		ingestion_timestamp
	FROM 
		bronze.olist_geolocation
	)
select
	zip_code_prefix, 
	lat,
	long,  
	city, 
	state, 
	ingestion_timestamp
from 
	geolocation
where rn = 1