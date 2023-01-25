-- binning of prices and an in-table histogram
WITH prices AS (
    SELECT
        ROUND(MIN(observed), 2) as min_price,
        ROUND(MAX(observed), 2) as max_price
    from
        aud_usd
),
hist AS (
    SELECT
        WIDTH_BUCKET(observed, min_price, max_price, 9) AS bucket,
        numrange(
            ROUND(MIN(observed), 2),
            ROUND(MAX(observed), 2),
            '[]'
        ) AS price_range,
        count(*) AS freq
    FROM
        aud_usd,
        prices
    GROUP BY
        bucket
    ORDER BY
        bucket
)
SELECT
    price_range AS "Price Range",
    freq AS "Frequency",
    REPEAT(
        '+',
        (
            freq :: float / MAX(freq) OVER() * 30
        ) :: int
    ) AS "Histogram"
FROM
    hist;

-- sample output
-- 
-- Price Range | Frequency |           Histogram            
-- -------------+-----------+--------------------------------
--  [0.71,0.77] |       801 | +++
--  [0.77,0.83] |      8438 | ++++++++++++++++++++++++++++++
--  [0.83,0.89] |      3429 | ++++++++++++
--  [0.89,0.95] |       232 | +
--  [0.96,1.01] |        55 | 
--  [1.02,1.08] |        21 | 
--  [1.08,1.13] |        21 | 
--  [1.14,1.20] |        11 | 
--  [1.20,1.26] |         6 | 
--  [1.26,1.26] |         1 | 
-- (10 rows)