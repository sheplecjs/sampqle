-- summary stats on aud_usd table
SELECT
    TO_CHAR(aud_usd.tm, 'YYYY-MM') AS "month",
    ROUND(AVG(observed), 2) AS "Average Rate",
    ROUND(STDDEV(observed), 2) AS "STDEV Rate",
    ROUND(MIN(observed), 2) AS "MIN Rate",
    ROUND(MAX(observed), 2) AS "MAX Rate"
FROM
    aud_usd
GROUP BY
    "month"
ORDER BY
    "month";