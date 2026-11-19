/* 1.Identify data quality issues 
   2.Cleaning table: (1.Remove duplicates
                      2.standardize the data
	                  3.Null values or blank values
                      4.Remove any colums) */


-- Creating staging table

CREATE TABLE employers_staging
LIKE employers;

INSERT INTO employers_staging
SELECT *
FROM employers;

SELECT *
FROM employers_staging;

-- 1. Removing duplicates

SELECT employer_id,
	   COUNT(*) AS occurance
FROM employers_staging
GROUP BY employer_id
HAVING COUNT(*) > 1;

#No duplicate record found

-- 2. Standardize the data

DESCRIBE employers_staging;

SELECT DISTINCT benefit_plan
FROM employers_staging
ORDER BY benefit_plan;

SELECT MAX(coverage_limit) AS max_value,
       MIN(coverage_limit) AS min_value,
       AVG(coverage_limit) AS avg_value
FROM employers_staging;

SELECT coverage_limit
FROM employers_staging
WHERE coverage_limit < 0;

SELECT employer_name,
       COUNT(*) AS occurance
FROM employers_staging
GROUP BY employer_name
HAVING COUNT(*) > 1;



#Distinct values inspected, no standardization required.

-- 3. Null values or blank values

SELECT employer_id
FROM employers_staging
WHERE employer_id IS NULL;

SELECT employer_name
FROM employers_staging
WHERE employer_name IS NULL OR 
      TRIM(employer_name) = '';

SELECT benefit_plan
FROM employers_staging 
WHERE benefit_plan IS NULL OR 
      TRIM(benefit_plan) ='';
      
SELECT coverage_limit
FROM employers_staging
WHERE coverage_limit IS NULL;

#No null or blank values found 

-- 4. Removing columns

#No need to remove any column all required in visualization

-- Final validation to check that cleaning does not affect on row count

SELECT
      (SELECT COUNT(*) FROM employers) AS original_data,
      (SELECT COUNT(*) FROM employers_staging) AS cleaned_data;
      

/*
CLEANING SUMMARY – EMPLOYERS TABLE

1. Duplicate employer IDs: No duplicates found.
2. Benefit plan: Distinct values inspected; no standardization required.
3. Employer names: Duplicate names investigated.
4. Missing values: No NULL or blank values found.
5. Coverage limit: Checked using minimum, maximum, average, and negative-value validation.
6. Unnecessary columns: None identified; all columns are relevant to the analysis.
7. Row count: Validated against the original employers table.
*/