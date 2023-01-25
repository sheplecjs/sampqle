-- show the id, average session minutes, and total purchases for customers who have spent more than $100
SELECT
    sessions.user_id,
    ROUND(AVG(sessions.minutes), 2) AS "Avg Session Minutes",
    SUM(products.product_price * transactions.number) :: INTEGER AS "Purchases Total (Nearest Dollar)"
FROM
    transactions
    LEFT JOIN sessions ON transactions.session_id = sessions.session_id
    LEFT JOIN products ON transactions.product = products.product_id
WHERE
    transactions.cancelled = False
GROUP BY
    sessions.user_id
HAVING
    SUM(products.product_price * transactions.number) > 100
ORDER BY
    "Purchases Total (Nearest Dollar)" DESC;

-- sample output:
-- 
-- user_id | Avg Session Minutes | Purchases Total (Nearest Dollar) 
-- ---------+---------------------+----------------------------------
--      119 |                9.00 |                              214
--      596 |                8.33 |                              185
--      145 |                7.67 |                              185
--      142 |                8.00 |                              167
--      284 |                6.00 |                              149
--       91 |                6.25 |                              145
--      840 |                7.50 |                              138
--      909 |                7.00 |                              137
--      804 |                7.00 |                              133
--      390 |                7.00 |                              130
--      595 |                9.50 |                              118
-- (11 rows)