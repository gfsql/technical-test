WITH avg_amounts AS (
    SELECT
        typology,
        country,
        AVG(amount) AS avg_amount
    FROM {{ ref('fct_transactions') }}
    GROUP BY typology, country
)
SELECT typology, country, avg_amount
FROM avg_amounts
