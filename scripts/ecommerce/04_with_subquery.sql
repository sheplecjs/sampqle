-- Join transaction information to detractors to provide a list of products, associated total sales and 
-- associated number of detractors with purchases
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