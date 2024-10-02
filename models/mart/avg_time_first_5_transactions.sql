WITH first_5_transactions AS (
    SELECT
        store_id,
        happened_at,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY happened_at) AS transaction_number
    FROM {{ ref('fct_transactions') }}
)
SELECT
    store_id,
    AVG(EXTRACT(EPOCH FROM happened_at)) AS avg_time_seconds
FROM first_5_transactions
WHERE transaction_number <= 5
GROUP BY store_id
