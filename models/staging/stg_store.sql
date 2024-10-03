WITH raw_store AS (
    SELECT *
    FROM sumup.staging_store
)
SELECT
    id AS store_id,
    name AS store_name,
    country,
    city,
    created_at,
    typology,
    customer_id
FROM raw_store
