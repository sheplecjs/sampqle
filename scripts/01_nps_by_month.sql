-- First, we aggregate by month and user. In this query, we consider the average over the month if a user has
-- completed an NPS survey more than once. Second, We sum promoters, passaives, and detractors ready for
-- general reporting.

SELECT
    n.month AS "Month",
    SUM(n.promoter) AS "Promoters",
    SUM(n.passaive) AS "Passaives",
    SUM(n.detractor) AS "Detractors"
FROM
    (
        SELECT
            nps.user,
            TO_CHAR(nps.timestamp, 'YYYY-MM') AS "month",
            CASE
                WHEN AVG(nps.score) >= 9 THEN 1
                ELSE 0
            END AS "promoter",
            CASE
                WHEN AVG(nps.score) < 9
                AND AVG(nps.score) >= 7 THEN 1
                ELSE 0
            END AS "passaive",
            CASE
                WHEN AVG(nps.score) < 7 THEN 1
                ELSE 0
            END AS "detractor"
        FROM
            nps
        GROUP BY
            TO_CHAR(nps.timestamp, 'YYYY-MM'),
            nps.user
        ORDER BY
            nps.user
    ) AS n
GROUP BY
    n.month
ORDER BY
    n.month;