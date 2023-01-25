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