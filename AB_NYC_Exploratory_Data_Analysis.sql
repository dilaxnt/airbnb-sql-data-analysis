SELECT *
FROM airbnb_staging2;

-- 1) Distribution of listings by room type

SELECT 
room_type,
COUNT(*) as listing_count,
ROUND(
COUNT(*) * 100 / SUM(COUNT(*)) OVER (),
2
) AS percentage_of_listings
FROM airbnb_staging2
GROUP BY room_type
ORDER BY listing_count DESC;

-- 2) Price distribution by room type (bucketed analysis) 
-- (Have included a hidden row count as part of the code for presentation purposes)

SELECT
    room_type,
    price_band,
    COUNT(*) AS listings_count
FROM (
    SELECT
        room_type,
        CASE
            WHEN price < 50 THEN '< £50'
            WHEN price BETWEEN 50 AND 99 THEN '£50–£99'
            WHEN price BETWEEN 100 AND 199 THEN '£100–£199'
            WHEN price BETWEEN 200 AND 299 THEN '£200–£299'
            WHEN price BETWEEN 300 AND 499 THEN '£300–£499'
            ELSE '£500+'
        END AS price_band,
        CASE
            WHEN price < 50 THEN 1
            WHEN price BETWEEN 50 AND 99 THEN 2
            WHEN price BETWEEN 100 AND 199 THEN 3
            WHEN price BETWEEN 200 AND 299 THEN 4
            WHEN price BETWEEN 300 AND 499 THEN 5
            ELSE 6
        END AS price_band_order
    FROM airbnb_staging2
) t
GROUP BY room_type, price_band, price_band_order
ORDER BY room_type, price_band_order;

-- 3) Price range analysis by room type
-- A window function is then applied to compare these extremes across the entire dataset.

SELECT
    room_type,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM airbnb_staging2
GROUP BY room_type;

SELECT *
FROM (
    SELECT *,
           MIN(price) OVER () AS min_price,
           MAX(price) OVER () AS max_price
    FROM airbnb_staging2
) t
WHERE price = min_price OR price = max_price;

-- 4) Cheapest neighbourhood by row type 
-- Used CTEs and window functions to determine the lowest-priced neighbourhood within each room type

WITH price_ranking AS (
    SELECT
        neighbourhood_group,
        neighbourhood, 
        room_type,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY room_type
            ORDER BY price ASC
        ) AS rn
    FROM airbnb_staging2
)
SELECT
    room_type,
    neighbourhood_group,
    neighbourhood,
    price AS cheapest_price
FROM price_ranking
WHERE rn = 1;

-- 5) Min and Max prices for 'entire home/apt' specifically.
-- Price extremes for ‘Entire home/apt’ listings

SELECT *
FROM (
    SELECT *,
           MIN(price) OVER() AS min_price,
           MAX(price) OVER () AS max_price
    FROM airbnb_staging2
        WHERE room_type LIKE "E%"
) t
WHERE price = min_price OR price = max_price;

-- Exploratory data analysis (EDA) was conducted to uncover meaningful patterns and relationships
-- The top 5 strongest insights derived from this analysis are documented in the README.md file





