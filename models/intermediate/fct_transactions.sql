{{ config(
    materialized='table',
    post_hook=[
        "CREATE INDEX IF NOT EXISTS idx_status ON {{ this }}(status)",
        "CREATE INDEX IF NOT EXISTS idx_transaction_amount ON {{ this }}(amount)",
        "CREATE INDEX IF NOT EXISTS idx_product_name ON {{ this }}(product_name)",
        "CREATE INDEX IF NOT EXISTS idx_typology_country ON {{ this }}(typology, country)",
        "CREATE INDEX IF NOT EXISTS idx_device_type ON {{ this }}(device_type)"
    ])
}}

WITH transactions AS (
    SELECT
        t.transaction_id,
        t.device_id,
        t.product_name,
        t.amount,
        t.status,
        d.store_id,
        d.device_type,
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
