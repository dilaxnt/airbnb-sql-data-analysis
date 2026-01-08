SELECT * 
FROM ab_nyc_2019;

-- Step 1: Clean the data (remove duplicates, standardise values, handle nulls)

-- Create a staging table so the raw data remains unchanged

CREATE TABLE airbnb_staging
LIKE ab_nyc_2019;

SELECT *
FROM airbnb_staging;

INSERT airbnb_staging
SELECT * 
FROM ab_nyc_2019;

-- Assign row numbers to identify duplicate records

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id, host_id, host_name, name, neighbourhood_group, neighbourhood, latitude, longitude, room_type, price, minimum_nights, number_of_reviews, last_review, reviews_per_month, calculated_host_listings_count, availability_365 ) AS row_num
FROM airbnb_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- All rows with the same values are confirmed duplicates
-- Create a new table and remove duplicates where row_num > 1

CREATE TABLE `airbnb_staging2` (
  `id` int DEFAULT NULL,
  `name` text,
  `host_id` int DEFAULT NULL,
  `host_name` text,
  `neighbourhood_group` text,
  `neighbourhood` text,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `room_type` text,
  `price` int DEFAULT NULL,
  `minimum_nights` int DEFAULT NULL,
  `number_of_reviews` int DEFAULT NULL,
  `last_review` text,
  `reviews_per_month` text,
  `calculated_host_listings_count` int DEFAULT NULL,
  `availability_365` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Filter the data using the row_num column to keep only unique rows

SELECT * 
FROM airbnb_staging2;

INSERT INTO airbnb_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id, host_id, host_name, name, neighbourhood_group, neighbourhood, latitude, longitude, room_type, price, minimum_nights, number_of_reviews, last_review, reviews_per_month, calculated_host_listings_count, availability_365 ) AS row_num
FROM airbnb_staging;

DELETE
FROM airbnb_staging2
WHERE row_num > 1;

SELECT *
FROM airbnb_staging2;

-- Duplicates are now removed

-- Step 2: Standardise the data

SELECT name, (TRIM(NAME))
FROM airbnb_staging2;

UPDATE airbnb_staging2
SET name = TRIM(NAME);

# Round numerical values to 5 decimal places for consistency

SELECT 
ROUND(latitude, 5),
ROUND(longitude, 5)
FROM airbnb_staging2;

UPDATE airbnb_staging2
SET 
latitude = ROUND(latitude, 5),
longitude = ROUND(longitude, 5);

-- Step 3: Handle blank and null values

-- Use TRIM functions to ensure spaces do not interfere with null detection
-- Check all columns for blank or null values
-- (Initial review shows last_review and reviews_per_month are affected, but all columns are validated)

SELECT *
FROM airbnb_staging2
WHERE
    id IS NULL
 OR TRIM(name) = '' OR name IS NULL
 OR host_id IS NULL
 OR TRIM(host_name) = '' OR host_name IS NULL
 OR TRIM(neighbourhood_group) = '' OR neighbourhood_group IS NULL
 OR TRIM(neighbourhood) = '' OR neighbourhood IS NULL
 OR latitude IS NULL
 OR longitude IS NULL
 OR TRIM(room_type) = '' OR room_type IS NULL
 OR price IS NULL
 OR minimum_nights IS NULL
 OR number_of_reviews IS NULL
 OR last_review IS NULL OR TRIM(last_review) = ''
 OR reviews_per_month IS NULL
 OR calculated_host_listings_count IS NULL
 OR availability_365 IS NULL
 OR row_num IS NULL;

-- Convert blank values to NULL for easier handling

UPDATE airbnb_staging2
SET last_review = NULL
WHERE last_review = '';

UPDATE airbnb_staging2
SET reviews_per_month = NULL
WHERE reviews_per_month = '';

-- Remove rows where critical fields contain NULL values

DELETE 
FROM airbnb_staging2
WHERE last_review IS NULL
AND reviews_per_month IS NULL;

SELECT *
FROM airbnb_staging2;

ALTER TABLE airbnb_staging2
DROP COLUMN row_num;

-- The dataset is now fully cleaned and ready for exploratory analysis