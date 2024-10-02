WITH store_totals AS (
    SELECT
        store_id,
        SUM(amount) AS total_amount
    FROM {{ ref('fct_transactions') }}
    GROUP BY store_id
)
SELECT store_id, total_amount
FROM store_totals
ORDER BY total_amount DESC
LIMIT 10
