-- We sum promoters, passaives, and detractors for general reporting.
SELECT
    n.month AS "Month",
    SUM(n.promoter) AS "Promoters",
    SUM(n.passaive) AS "Passaives",
    SUM(n.detractor) AS "Detractors",
    ROUND(
        CAST(SUM(n.promoter) AS DECIMAL) / CAST(
            (
                SUM(n.detractor) + SUM(n.passaive) + SUM(n.promoter)
            ) AS DECIMAL
        ) - CAST(SUM(n.detractor) AS DECIMAL) / CAST(
            (
                SUM(n.detractor) + SUM(n.passaive) + SUM(n.promoter)
            ) AS DECIMAL
        ),
        2
    ) * 100 AS "Score"
FROM
    nps_user_monthly AS n
GROUP BY
    n.month
ORDER BY
    n.month;