USE churn_analysis;
 
 -- BUSINESS ANALYSIS --

 -- OVERALL CHURN RATE --
SELECT 
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn;

-- CHURN BY CONTRACT TYPE --
SELECT 
Contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;

-- CHURN BY PAYMENT METHODS --
SELECT 
PaymentMethod,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC;

-- CHURN BY TENURE GROUP --
SELECT 
tenure_group,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;

-- CHURN BY INTERNET SERVICE --
SELECT 
InternetService,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percentage DESC;

-- HIGH RISK CUSTOMER SEGMENT --
SELECT 
Contract,
charge_category,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2), '%') AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY Contract,charge_category
ORDER BY churn_rate_percentage DESC;