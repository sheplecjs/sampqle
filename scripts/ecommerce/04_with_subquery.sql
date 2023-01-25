-- Join transaction information to detractors to provide a list of products, associated total sales and 
-- associated number of detractors with purchases
CREATE
OR REPLACE VIEW detractor_products AS
SELECT
    tx.product,
    tx.month,
    SUM(tx.number) AS "sales",
    SUM(nps_user_monthly.detractor) AS "detractors"
FROM
    (
        SELECT
            t.product,
            t.number,
            t.timestamp,
            TO_CHAR(t.timestamp, 'YYYY-MM') AS "month",
            sessions.user_id
        FROM
            transactions AS t
            LEFT JOIN sessions ON t.session_id = sessions.session_id
        WHERE
            t.cancelled = FALSE
    ) as tx
    LEFT JOIN nps_user_monthly ON tx.user_id = nps_user_monthly.user
    AND tx.month = nps_user_monthly.month
WHERE
    nps_user_monthly.detractor = 1
GROUP BY
    tx.product,
    tx.month
ORDER BY
    detractors DESC,
    sales;

SELECT
    *
FROM
    detractor_products;

-- sample output:
-- 
-- product |  month  | sales | detractors 
-- ---------+---------+-------+------------
--       16 | 2021-12 |     6 |          2
--      892 | 2021-12 |     1 |          1
--      805 | 2021-12 |     1 |          1
--      711 | 2021-12 |     2 |          1
--      162 | 2021-12 |     2 |          1
--      522 | 2021-12 |     3 |          1
--      878 | 2021-12 |     3 |          1
--      849 | 2021-12 |     3 |          1
--       39 | 2021-12 |     3 |          1
--      127 | 2021-12 |     3 |          1
--      288 | 2021-12 |     3 |          1
--      447 | 2021-12 |     3 |          1
--      505 | 2021-12 |     4 |          1
--       10 | 2021-12 |     4 |          1
-- (14 rows)