-- We sum promoters, passaives, and detractors for general reporting.
SELECT
    n.month AS "Month",
    SUM(n.promoter) AS "Promoters",
    SUM(n.passaive) AS "Passives",
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

-- sample output:
-- 
--   Month  | Promoters | Passives | Detractors |  Score  
-- ---------+-----------+----------+------------+---------
--  2021-09 |         0 |        0 |          1 | -100.00
--  2021-10 |         1 |        6 |         16 |  -65.00
--  2021-11 |        11 |       26 |        138 |  -73.00
--  2021-12 |        29 |       79 |        281 |  -65.00
--  2022-01 |        43 |      105 |        225 |  -49.00
--  2022-02 |        42 |       44 |         36 |    5.00
--  2022-03 |         6 |        5 |          2 |   31.00
-- (7 rows)