-- A report showing customer profiles who purchased products specified. Total sales are included for context.
WITH worst_product AS (SELECT product FROM detractor_products LIMIT 1),
     second_worst_product AS (SELECT product FROM detractor_products LIMIT 1 OFFSET 1)
SELECT
    tx.cancelled,
    tx.timestamp,
    tx.number,
    tx.product,
    SUM(tx.number) OVER(PARTITION BY tx.product) AS "Total Sales",
    users.country,
    profiles.marketing_dimension_1 AS "Survey Question 1",
    profiles.marketing_dimension_2 AS "Survey Question 2"
FROM
    transactions AS tx
    LEFT JOIN sessions ON tx.session_id = sessions.session_id
    LEFT JOIN users ON sessions.user_id = users.user_id
    LEFT JOIN profiles ON users.user_id = profiles.user
WHERE
    product = (SELECT product FROM worst_product)
    OR product = (SELECT product FROM second_worst_product);