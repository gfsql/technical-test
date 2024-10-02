WITH transactions AS (
    SELECT
        t.transaction_id,
        t.device_id,
        t.product_name,
        t.amount,
        d.store_id,
        s.typology,
        s.country,
        t.happened_at
    FROM {{ ref('stg_transactions') }} t
    JOIN {{ ref('stg_device') }} d
      ON t.device_id = d.device_id
    JOIN {{ ref('stg_store') }} s
      ON d.store_id = s.store_id
)
SELECT * FROM transactions
