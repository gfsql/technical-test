WITH raw_device AS (
    SELECT *
    FROM sumup.staging_device
)
SELECT
    id AS device_id,
    type AS device_type,
    store_id
FROM raw_device
