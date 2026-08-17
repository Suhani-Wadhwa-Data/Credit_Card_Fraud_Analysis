/*
PROJECT : Credit Card Fraud Analysis
TOOL : Microsoft SQL Server 

FOCUS:
- Views
- JOINs
- CTEs
- Window Functions
- Aggregations
- CASE expressions
- HAVING
- Stored Procedures
*/

-- TASK 1. Fraud Transactions View  
CREATE VIEW Fraud_Transactions_View as
SELECT Transaction_ID, Transaction_Amt_USD, Merchant_Category, 
       Card_Type, Authentication_Method, Transaction_Mode, Customer_Age, 
       Customer_Age_Group, Merchant_Risk_Score, Merchant_Risk_Level, Fraud_Status
FROM Credit_Card_Fraud
WHERE Fraud_Status = 1;
GO

-- Check View
SELECT * 
FROM Fraud_Transactions_View
GO

-- TASK 2. Merchant Category Analysis 
-- Step 1: Create a lookup table for Merchant Category 
CREATE TABLE Merchant_Category_Mapping 
     (Merchant_Category VARCHAR(100) PRIMARY KEY,
     Category_Type VARCHAR(50) NOT NULL);
INSERT INTO Merchant_Category_Mapping (Merchant_Category,Category_Type)
VALUES ('Groceries', 'Essential'),
       ('Online Retail', 'Shopping'),
       ('Healthcare', 'Essential'),
       ('Utilities', 'Essential'),
       ('Gaming', 'Entertainment'),
       ('Gift Cards', 'Shopping'),
       ('Streaming', 'Entertainment'),
       ('Fuel', 'Transportation'),
       ('Electronics', 'Shopping'),
       ('Travel', 'Travel'),
       ('Restaurants', 'Food'),
       ('Crypto Exchange', 'Financial');
SELECT * FROM Merchant_Category_Mapping

-- Step 2: Combine transaction data with Merchant Category Mapping
SELECT 
   c.Transaction_ID,c.Merchant_Category,
   m.Category_Type,c.Transaction_Amt_USD,c.fraud_status
FROM Credit_Card_Fraud c
INNER JOIN
Merchant_Category_Mapping m
on c.Merchant_Category = m.Merchant_Category

-- Step 3: Calculate Fraud Rate by Category Type using a CTE
;WITH FraudAnalysis as
(  SELECT m.category_type, COUNT(*) as Total_Transactions,
   SUM (CASE WHEN c.fraud_status = 1 THEN 1
   ELSE 0
   END ) AS Fraud_Transactions
FROM Merchant_Category_Mapping m
INNER JOIN
Credit_Card_Fraud c
on c.Merchant_Category = m.Merchant_Category
GROUP BY m.Category_Type
)
    SELECT Category_Type,Total_Transactions,Fraud_Transactions,
    CAST(
    Fraud_Transactions * 100.0 / Total_Transactions
    as DECIMAL(5,2)
    ) as Fraud_Rate_Percentage
    FROM FraudAnalysis
    ORDER BY Fraud_Rate_Percentage DESC

-- TASK 3. Top Fraudulent Transaction by Merchant Category
;WITH RankedTransactions as
(   SELECT Transaction_ID,Transaction_Amt_USD,Merchant_Category,
    ROW_NUMBER() OVER (PARTITION BY merchant_category
    ORDER BY transaction_amt_usd DESC) as Transaction_Rank
FROM Credit_Card_Fraud
WHERE Fraud_Status = 1
)
   SELECT
    Transaction_ID,
    Transaction_Amt_USD,
    Merchant_Category

FROM RankedTransactions
WHERE Transaction_Rank = 1
ORDER BY Transaction_Amt_USD DESC;

-- TASK 4. Merchant Categories with High Average Transaction Amount
SELECT
    Merchant_Category,
    COUNT(*) AS Total_Transactions,
    ROUND(AVG(Transaction_Amt_USD), 2) as Average_Transaction_Amount
FROM Credit_Card_Fraud
GROUP BY Merchant_Category
HAVING AVG(Transaction_Amt_USD) > 100
ORDER BY Average_Transaction_Amount DESC;

-- TASK 5. Fraud Rate by Authentication Method
SELECT
    Authentication_Method,
    COUNT(*) as Total_Transactions,
    SUM(CASE WHEN Fraud_Status = 1 THEN 1
             ELSE 0
             END) as Fraud_Transactions,
    CAST(SUM(CASE When Fraud_Status = 1 Then 1
                  Else 0
                  END) * 100.0 / COUNT(*)
                  as Decimal (5,2)
         ) as Fraud_Rate_Percentage
FROM Credit_Card_Fraud
GROUP BY Authentication_Method
ORDER BY Fraud_Rate_Percentage DESC;

-- TASK 6. Fraud Risk Classification by Merchant Risk Score.
SELECT
    Transaction_ID, Transaction_Amt_USD, Merchant_Category,
    Merchant_Risk_Score, Fraud_Status,
 CASE
   WHEN Merchant_Risk_Score >= 80 THEN 'High Risk'
   WHEN Merchant_Risk_Score >= 50 THEN 'Medium Risk'
   ELSE 'Low Risk'
   END as Calculated_Risk_Level

FROM Credit_Card_Fraud
WHERE Fraud_Status = 1;
GO

-- TASK 7. Parameterized Fraud Transactions Procedure by Merchant Risk Level.
CREATE PROCEDURE TransactionsByRiskLevel 
    @RiskLevel VARCHAR(20) 
AS
BEGIN

   SELECT Transaction_ID, Transaction_Amt_USD, Merchant_Category,
     Card_Type, Authentication_Method, Merchant_Risk_Score, Merchant_Risk_Level, Fraud_Status
   FROM Credit_Card_Fraud
   WHERE Merchant_Risk_Level = @RiskLevel 
     and Fraud_Status = 1;

END;
GO

-- Execute Procedure
EXEC TransactionsByRiskLevel 'High';
GO