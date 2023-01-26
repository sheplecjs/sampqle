-- average exchange rates by day of week for 2000-2007
SELECT
    EXTRACT(ISODOW FROM tm) AS "Day of Week",
    ROUND(AVG(observed), 3) AS "Average Rate (2000-2007)"
FROM
    aud_usd
WHERE
    tm < '2007-12-31' AND tm > '2000-01-01'
GROUP BY
    EXTRACT(ISODOW FROM tm)
ORDER BY
    EXTRACT(ISODOW FROM tm);

-- sample output:

--  Day of Week | Average Rate (2000-2007) 
-- -------------+--------------------------
--            1 |                    0.806
--            2 |                    0.809
--            3 |                    0.810
--            4 |                    0.809
--            5 |                    0.808
--            6 |                    0.807
--            7 |                    0.811
-- (7 rows)