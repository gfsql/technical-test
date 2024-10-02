WITH raw_transactions AS (
    SELECT *
    FROM staging_transactions
)
SELECT
    id AS transaction_id,
    device_id,
    product_name,
    product_sku,
    amount,
    status,
    happened_at
FROM raw_transactions
WHERE status LIKE 'accepted'
