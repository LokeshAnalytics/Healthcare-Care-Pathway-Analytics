/* 1.Identify data quality issues 
   2.Cleaning table: (1.Remove duplicates
                      2.standardize the data
	                  3.Null values or blank values
                      4.Remove any colums) */


-- Creating staging table

CREATE TABLE members_staging
LIKE members;

INSERT INTO members_staging
SELECT *
FROM members;

SELECT *
FROM members_staging;

-- 1. Removing duplicates

SELECT member_id,
       COUNT(*) AS occurance
FROM members_staging
GROUP BY member_id
HAVING COUNT(*) > 1;

#NO duplicate found

-- 2. Standardize the data

DESCRIBE members_staging;

SELECT enrollment_date
FROM members_staging
WHERE enrollment_date IS NOT NULL AND 
       STR_TO_DATE(enrollment_date, '%Y-%m-%d') IS NULL;
       
ALTER TABLE members_staging
MODIFY COLUMN enrollment_date DATE;

SELECT DISTINCT age_group
FROM members_staging
ORDER BY age_group;

SELECT DISTINCT country
FROM members_staging
ORDER BY country;

-- 3.NULL values OR blank values

SELECT member_id 
FROM members_staging
WHERE member_id IS NULL;

SELECT employer_id 
FROM members_staging
WHERE employer_id IS NULL;
      
SELECT age_group 
FROM members_staging
WHERE age_group IS NULL OR 
      age_group = '';
      
SELECT country 
FROM members_staging
WHERE country IS NULL OR 
      TRIM(country) = '';
      
SELECT enrollment_date 
FROM members_staging
WHERE enrollment_date IS NULL;

#Not any column find null Or empty values

-- 4. Rmovining unnecessary columns

#There is no need to remove column

-- Final validation to check that cleaning does not affect on row count

SELECT 
       (SELECT COUNT(*) FROM members) AS original_data,
       (SELECT COUNT(*) FROM members_staging) AS cleaned_data;
       
       
/*
CLEANING SUMMARY – MEMBERS TABLE

1. Duplicate member IDs: No duplicates found.
2. Enrollment date: Converted TEXT to DATE.
3. Age group: Retained as TEXT because it represents age ranges.
4. Country: Distinct values inspected for inconsistencies.
5. Missing values: No NULL or blank values found.
6. Unnecessary columns: None identified.
7. Row count: Validated against the original table.
*/