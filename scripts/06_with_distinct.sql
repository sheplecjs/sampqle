-- SELECT
-- DISTINCT user_id,
-- transactions.product,
-- transactions.number,
-- sessions.minutes,
-- transactions.cancelled
-- FROM
-- sessions
-- RIGHT JOIN
-- transactions ON transactions.session_id = sessions.session_id
-- -- WHERE transactions.cancelled = 
-- LIMIT 150;

SELECT
COUNT(*)
FROM
transactions
WHERE cancelled=true;