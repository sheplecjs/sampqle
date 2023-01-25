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