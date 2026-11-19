/* 1.Identify data quality issues 
   2.Cleaning table: (1.Remove duplicates
                      2.standardize the data
	                  3.Null values or blank values
                      4.Remove any colums) */


-- Creating staging table

CREATE TABLE authorizations_staging
LIKE authorizations;

INSERT INTO authorizations_staging
SELECT * 
FROM authorizations;

SELECT *
FROM authorizations_staging;

-- 1. Removing duplicates 

SELECT authorization_id,
      COUNT(*) AS occurrence
FROM authorizations_staging
GROUP BY authorization_id
HAVING COUNT(*) > 1;

#No duplicates found.

-- 2.Standardization the data

DESCRIBE authorizations_staging;

SELECT request_date
FROM authorizations_staging
WHERE request_date IS NOT NULL AND 
	  STR_TO_DATE(request_date, '%Y-%m-%d') IS NULL;
      
ALTER TABLE authorizations_staging
MODIFY COLUMN request_date DATE;

SELECT decision_date
FROM authorizations_staging
WHERE decision_date IS NOT NULL AND
      STR_TO_DATE(decision_date, '%Y-%m-%d') IS NULL;  #Column contain some blank values need to check non blank values have vaild date format
      
SELECT decision_date
FROM authorizations_staging
WHERE TRIM(decision_date) <> '' AND
       decision_date IS NOT NULL AND  
       STR_TO_DATE(decision_date, '%Y-%m-%d') IS NULL;     #non blank values in expected format.

#Converting blank values into NULL values

UPDATE authorizations_staging
SET decision_date = NULL 
WHERE TRIM(decision_date) = '';
      
ALTER TABLE authorizations_staging
MODIFY COLUMN decision_date DATE;

SELECT DISTINCT authorization_status
FROM authorizations_staging;

-- 3.Null values or blank values

SELECT authorization_id
FROM authorizations_staging
WHERE authorization_id IS NULL;

SELECT member_id
FROM authorizations_staging
WHERE member_id IS NULL;

SELECT provider_id
FROM authorizations_staging
WHERE provider_id IS NULL;

SELECT request_date
FROM authorizations_staging
WHERE request_date IS NULL;

SELECT decision_date
FROM authorizations_staging
WHERE decision_date IS NULL;     #decision_date column contain some null values 

SELECT DISTINCT decision_date,
       authorization_status
FROM authorizations_staging
WHERE decision_date IS NULL;     

#In decision_date column all null values are Pending status, no need delete or update it. 

SELECT authorization_status 
FROM authorizations_staging
WHERE authorization_status IS NULL OR 
      TRIM(authorization_status) = '';
      
#Only in decision_date column found some null values and kept null values is it is. 

-- 4.Removing_columns

#No need to remove any column all need in visualization. 

-- Final validation: compare original and staging row count. 

SELECT 
      (SELECT COUNT(*) FROM authorizations) AS original_data,
      (SELECT COUNT(*) FROM authorizations_staging) AS cleaned_data;
      
      
/*
CLEANING SUMMARY – AUTHORIZATIONS TABLE

1. Duplicate authorization IDs: No duplicates found.
2. Request date: Converted TEXT to DATE after format validation.
3. Decision date: Blank values converted to NULL and data type changed to DATE.
4. Authorization status: Distinct values inspected; no standardization required.
5. Missing values: NULL values in decision_date correspond to Pending authorizations.
6. Unnecessary columns: None identified; all columns are relevant to the analysis.
7. Row count: Validated against the original authorizations table.

*/
