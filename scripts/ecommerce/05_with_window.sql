-- A report showing customer profiles who purchased products specified. Total sales are included for context.
WITH worst_product AS (SELECT product FROM detractor_products LIMIT 1),
     second_worst_product AS (SELECT product FROM detractor_products LIMIT 1 OFFSET 1)
SELECT
    tx.cancelled AS "Cancelled",
    tx.timestamp AS "Purchase Time",
    tx.number AS "Items Purchased",
    tx.product AS "Product ID",
    SUM(tx.number) OVER(PARTITION BY tx.product) AS "Total Sales",
    users.country "Country",
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

-- sample output:
-- 
-- Cancelled |    Purchase Time    | Items Purchased | Product ID | Total Sales | Country | Survey Question 1 | Survey Question 2 
-- -----------+---------------------+-----------------+------------+-------------+---------+-------------------+-------------------
--  f         | 2021-12-17 17:46:36 |               2 |        571 |           5 | NZ      |                 2 |                 2
--  f         | 2021-12-19 10:28:52 |               2 |        571 |           5 | MX      |                 2 |                 1
--  t         | 2021-12-22 03:58:13 |               1 |        571 |           5 | MX      |                 3 |                 4
--  f         | 2021-12-25 14:52:30 |               2 |        762 |           4 | NZ      |                 2 |                 1
--  f         | 2021-12-22 09:25:29 |               2 |        762 |           4 | MX      |                   |                  
-- (5 rows)