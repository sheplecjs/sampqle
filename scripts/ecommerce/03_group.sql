-- We sum promoters, passaives, and detractors for general reporting.
SELECT
    n.month AS "Month",
    SUM(n.promoter) AS "Promoters",
    SUM(n.passaive) AS "Passaives",
    SUM(n.detractor) AS "Detractors"
FROM
    nps_user_monthly AS n
GROUP BY
    n.month
ORDER BY
    n.month;