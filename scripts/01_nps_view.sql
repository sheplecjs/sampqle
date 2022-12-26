-- Create a view that categories our nps responses. This query relies on an average in cases where a single user
-- submits multiple surveys in one month. This view will be useful for building general NPS reporting as well
-- as individual product performance analysis.

CREATE VIEW nps_user_monthly AS
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
    nps.user;