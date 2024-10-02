WITH device_transactions AS (
    SELECT
        device_type,
        COUNT(transaction_id) AS total_transactions
    FROM {{ ref('fct_transactions') }} t
    JOIN {{ ref('stg_device') }} d
      ON t.device_id = d.device_id
    GROUP BY device_type
),
total AS (
    SELECT SUM(total_transactions) AS total FROM device_transactions
)
SELECT
    device_type,
    total_transactions,
    ROUND((total_transactions / total.total::numeric) * 100, 2) AS percentage
FROM device_transactions, total
