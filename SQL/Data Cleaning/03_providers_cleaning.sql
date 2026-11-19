/* 1.Identify data quality issues 
   2.Cleaning table: (1.Remove duplicates
                      2.standardize the data
	                  3.Null values or blank values
                      4.Remove any colums) */


-- Creating staging table

CREATE TABLE providers_staging
LIKE providers;

INSERT INTO providers_staging
SELECT *
FROM providers;

SELECT *
FROM providers_staging;

-- 1. Removing duplicates

SELECT provider_id,
       COUNT(*) AS occurrence 
FROM providers_staging
GROUP BY provider_id
HAVING COUNT(*) > 1;

#No duplicate found

-- 2.Standardize the data

DESCRIBE providers_staging;

-- Investigate repeated provider names (not necessarily duplicate providers).
SELECT provider_name,
       COUNT(*) AS occurrence 
FROM providers_staging
GROUP BY provider_name
HAVING COUNT(*) > 1;

SELECT DISTINCT provider_type
FROM providers_staging
ORDER BY provider_type;

SELECT DISTINCT state
FROM providers_staging
ORDER BY state;

#distinct value inspected, no standardization required.

-- 3.Null values or blank values

SELECT provider_id
FROM providers_staging
WHERE provider_id IS NULL;

SELECT provider_name
FROM providers_staging 
WHERE provider_name IS NULL OR 
      TRIM(provider_name) = '';

SELECT provider_type
FROM providers_staging 
WHERE provider_type IS null OR 
      TRIM(provider_type) = '';

SELECT state
FROM providers_staging
WHERE state IS NULL OR 
      TRIM(state) = '';
      
#No null or blank value found

-- 4.Removing columns

#No need to remove any column 

-- Final validation to check that cleaning does not affect on row count

SELECT 
       (SELECT COUNT(*) FROM providers) AS original_data,
       (SELECT COUNT(*) FROM providers_staging) AS cleaned_data;
      

/*
CLEANING SUMMARY – PROVIDERS TABLE

1. Duplicate provider IDs: No duplicates found.
2. Provider type: Distinct values inspected; no standardization required.
3. State: Distinct values inspected; no standardization required.
4. Missing values: No NULL or blank values found.
5. Unnecessary columns: None identified; all columns are relevant to the analysis.
6. Row count: Validated against the original providers table.

*/