WITH product_sales AS (
    SELECT
        product_name,
        COUNT(transaction_id) AS total_sold
    FROM {{ ref('fct_transactions') }}
    WHERE status LIKE 'accepted'
    GROUP BY product_name
)
SELECT product_name, total_sold
FROM product_sales
ORDER BY total_sold DESC
LIMIT 10
