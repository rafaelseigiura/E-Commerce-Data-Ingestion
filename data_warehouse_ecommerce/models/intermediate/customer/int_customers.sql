WITH ranked AS (

    SELECT
        customer_unique_id,
        zip_code_prefix,
        city,
        state,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY customer_id
        ) AS rn

    FROM silver.stg_customer

)

SELECT
    customer_unique_id,
    zip_code_prefix,
    city,
    state

FROM ranked

WHERE rn = 1