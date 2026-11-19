/* 1.Identify data quality issues 
   2.Cleaning table: (1.Remove duplicates
                      2.standardize the data
	                  3.Null values or blank values
                      4.Remove any colums) */


-- Creating staging table

CREATE TABLE member_events_staging
LIKE member_events;

INSERT INTO member_events_staging
SELECT *
FROM member_events;

SELECT *
FROM member_events_staging;

-- 1. Removing duplicates
SELECT event_id,
       COUNT(*) AS occurrence
FROM member_events_staging
GROUP BY event_id
HAVING COUNT(*) > 1;

#No duplicate found

-- 2. standardization the data

DESCRIBE member_events_staging;

SELECT event_date
FROM member_events_staging
WHERE event_date IS NOT NULL AND
      STR_TO_DATE(event_date, '%Y-%m-%d') IS NULL;
      
ALTER TABLE member_events_staging
MODIFY COLUMN event_date DATE;

SELECT DISTINCT event_type 
FROM member_events_staging;

#distinct value inspected, no standardization required (just change data type text to date).

-- 3. Null value or blank values 

SELECT event_id
FROM member_events_staging
WHERE event_id IS NULL;

SELECT member_id 
FROM member_events_staging
WHERE member_id IS NULL;

SELECT event_type 
FROM member_events_staging
WHERE event_type IS NULL OR
      TRIM(event_type) = '';
      
SELECT event_date
FROM member_events_staging
WHERE event_date IS NULL;

#No null or blank values found

-- 4.removing columns

#No need to remove any column

-- Final validation: Compare original and staging row counts.

SELECT 
      (SELECT COUNT(*) FROM member_events) AS original_data,
      (SELECT COUNT(*) FROM member_events_staging) AS cleaned_data;
      
      
/*
CLEANING SUMMARY – MEMBER EVENTS TABLE

1. Duplicate event IDs: No duplicates found.
2. Event date: Converted TEXT to DATE after format validation.
3. Event type: Distinct values inspected; no standardization required.
4. Missing values: No NULL and blank values found.
5. Unnecessary columns: None identified; all columns are relevant to the analysis.
6. Row count: Validated against the original member_events table.

*/