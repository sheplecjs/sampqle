-- A report showing customer profiles who purchased products 636 or 94. Total sales are included for context.
SELECT
    tx.cancelled,
    tx.timestamp,
    tx.number,
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
    product = 636 OR product = 94;