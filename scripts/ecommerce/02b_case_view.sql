-- Create a view that categories our nps responses. This query relies on an average in cases where a single user
-- submits multiple surveys in one month. This view will be useful for building general NPS reporting as well
-- as individual product performance analysis.
CREATE
OR REPLACE VIEW nps_user_monthly AS
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
    month,
    nps.user
ORDER BY
    nps.user,
    month;

SELECT
    *
FROM
    nps_user_monthly
LIMIT
    10;

-- sample output:
-- 
-- user |  month  | promoter | passaive | detractor 
-- ------+---------+----------+----------+-----------
--     2 | 2021-11 |        0 |        0 |         1
--     2 | 2022-01 |        0 |        0 |         1
--     5 | 2021-12 |        1 |        0 |         0
--     8 | 2022-01 |        1 |        0 |         0
--    10 | 2022-01 |        0 |        0 |         1
--    10 | 2022-02 |        0 |        1 |         0
--    11 | 2021-12 |        0 |        1 |         0
--    11 | 2022-01 |        0 |        1 |         0
--    12 | 2021-12 |        0 |        0 |         1
--    12 | 2022-01 |        0 |        0 |         1
-- (10 rows)