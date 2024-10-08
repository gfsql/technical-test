WITH ranked_transactions AS (
    SELECT
        store_id,
        happened_at,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY happened_at) AS transaction_rank
    FROM {{ ref('fct_transactions') }}
),

fifth_transaction AS (
    SELECT
        store_id,
        happened_at AS transaction_date
    FROM ranked_transactions
    WHERE transaction_rank = 5
),

store_adoption AS (
    SELECT
        s.store_id,
        s.created_at AS store_created_at,
        fdt.transaction_date,
        fdt.transaction_date - s.created_at AS adoption_time_days
    FROM {{ ref('stg_store') }} s
    JOIN fifth_transaction fdt ON s.store_id = fdt.store_id
)

SELECT
    AVG(adoption_time_days) AS average_adoption_time_days,
    COUNT(*) AS store_count
FROM store_adoption
