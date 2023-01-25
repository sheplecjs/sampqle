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

-- sample output:
-- 
--  cancelled |      timestamp      | number | product | Total Sales | country | Survey Question 1 | Survey Question 2 
-- -----------+---------------------+--------+---------+-------------+---------+-------------------+-------------------
--  f         | 2021-12-12 14:43:32 |      3 |      16 |           6 | CH      |                 2 |                 1
--  f         | 2021-12-28 06:31:36 |      3 |      16 |           6 | CH      |                 3 |                 2
--  f         | 2021-12-23 06:28:09 |      1 |     805 |           1 | CH      |                 2 |                 2
-- (3 rows)