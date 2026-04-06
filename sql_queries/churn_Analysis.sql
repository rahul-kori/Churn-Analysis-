-- CREATE DATABASE --
CREATE DATABASE churn_analysis;

USE churn_analysis;

-- CHECK THE DATA --
SELECT TOP 10 *
FROM Customer_Churn;

-- CHECK TOTAL RECORDS --
SELECT COUNT(*)
FROM Customer_Churn;

-- CHECK COLUMN DATA TYPES --
	EXEC sp_help customer_churn;

-- CHECK MISSING VALUES --
SELECT *
FROM Customer_Churn
WHERE customerID IS NULL;

SELECT COUNT(*) AS total_nulls,
TotalCharges
FROM Customer_Churn
GROUP BY TotalCharges
HAVING TotalCharges IS NULL;

-- CHECK DUPLICATES CUSTOMERS --
SELECT COUNT(*) AS customers,
customerID
FROM Customer_Churn
GROUP BY customerID
HAVING COUNT(*) > 1;

-- CHURN DISTRIBUTION --
SELECT 
churn, 
COUNT(*) AS customers,
CONCAT(ROUND(COUNT(*) *100 / SUM(COUNT(*)) OVER (),2), '%') AS churn_percentage
FROM Customer_Churn
GROUP BY churn;

-- CHECK CONTRACT TYPE --
SELECT
Contract,
COUNT(*) AS customers,
CONCAT(ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(),2),'%') AS contract_percentage
FROM Customer_Churn
GROUP BY Contract;

-- CHECK INTERNET SERVICE DISTRIBUTION --
SELECT
InternetService,
COUNT(*) AS Customers,
CONCAT(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), '%') AS Service_percentage
FROM Customer_Churn
GROUP BY InternetService

-- CHECK CHURN PERENTAGE BY INTERNET SERVICE, CONTRACT TYPE --
SELECT
InternetService,
contract,
--SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churn_yes,
-- SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) AS churn_no,
CONCAT(ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100/COUNT(*),2), '%') AS churn_Yes_per,
CONCAT(ROUND(SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) * 100/COUNT(*),2),'%') AS churn_no_per
FROM Customer_Churn
GROUP BY InternetService,contract;

-- DATA CLEANING & FEATURE ENGINEERING --
SELECT
COUNT(*) AS Total,
Totalcharges
FROM Customer_Churn
GROUP BY TotalCharges
HAVING TotalCharges IS NULL;

-- FILL MISSING TOTAL CHAEGES --
UPDATE Customer_Churn
SET TotalCharges = tenure*MonthlyCharges
WHERE TotalCharges IS NULL;

-- CREATE TENURE GRUOP (CUSTOMER LOYALTY SEGMENTATION)
SELECT
tenure_group,
COUNT(customerID) As Total_customers,
CONCAT(ROUND(COUNT(customerID) * 100 / SUM(COUNT(*)) OVER() ,2), '%') AS Percentagee
FROM
(
SELECT
customerID,
tenure,
CASE
WHEN tenure<=12 THEN '0-1 YEAR'
WHEN tenure<=24 THEN '1-2 YEARS'
WHEN tenure<=48 THEN '2-4 YEARS'
ELSE '4 + YEARS'
END AS tenure_group
FROM Customer_Churn
) t
GROUP BY tenure_group;

-- CREATE MONTHLY CHARGES CATEGORY --
SELECT
charge_category,
COUNT(customerID) AS Total,
CONCAT(ROUND(COUNT(customerID) * 100 / SUM(COUNT(*)) OVER(),2), '%') AS Percentagee
FROM
(
SELECT
customerID,
MonthlyCharges,
CASE
WHEN MonthlyCharges <= 35 THEN 'LOW'
WHEN MonthlyCharges BETWEEN 35 AND 70 THEN 'MEDIUM'
ELSE 'HIGH'
END AS charge_category
FROM customer_churn
) t
GROUP BY charge_category;

-- CREATE CUSTOMER VALUE SEGMENT --
SELECT
customer_value_segment,
COUNT(customerID) AS Total,
CONCAT(ROUND(COUNT(customerID) * 100 / SUM(COUNT(*)) OVER(),2), '%') AS Percentagee
FROM
(
SELECT
customerID,
TotalCharges,
CASE
WHEN TotalCharges < 1000 THEN 'LOW VALUE'
WHEN TotalCharges BETWEEN 1000 AND 5000 THEN 'MEDIUM VALUE'
ELSE 'HIGH VALUE'
END AS customer_value_segment
FROM Customer_Churn
) t
GROUP BY customer_value_segment;

-- CREATE CLEAN ANALYSIS TABLE --
SELECT *,
CASE
WHEN tenure<=12 THEN '0-1 YEAR'
WHEN tenure<=24 THEN '1-2 YEARS'
WHEN tenure<=48 THEN '2-4 YEARS'
ELSE '4 + YEARS'
END AS tenure_group,

CASE
WHEN MonthlyCharges <= 35 THEN 'LOW'
WHEN MonthlyCharges BETWEEN 35 AND 70 THEN 'MEDIUM'
ELSE 'HIGH'
END AS charge_category

INTO cleaned_customer_churn
FROM customer_churn;

-- VERIFY CLEAN DATASET --
SELECT TOP 10 *
FROM cleaned_customer_churn;
