# Credit Card Fraud Analysis — SQL Project

## Overview

A SQL-based analysis of **20,000 credit card transactions** to identify fraud patterns, evaluate transaction and merchant risk, and derive meaningful business insights using Microsoft SQL Server.

## Business Questions Answered

- Which merchant category type has the highest fraud rate?
- Which authentication method has the highest fraud rate?
- Which merchant categories have high average transaction amounts?
- What is the highest-value fraudulent transaction within each merchant category?
- How can fraudulent transactions be classified based on merchant risk score?
- How can fraudulent transactions be retrieved dynamically by risk level?

## Key Insights

- **1.70%** overall fraud rate across all transactions
- **4.99%** — highest fraud rate in the **Financial** category
- **4.44%** — highest fraud rate with **No Authentication**
- **$442.41** — highest average transaction amount in **Travel**
- **$3,356.46** — highest single fraudulent transaction in **Gaming**

## SQL Concepts Used

**Views** · **JOINs** · **CTEs** · **Window Functions** · **Aggregations** · **CASE Expressions** · **GROUP BY & HAVING** · **Parameterized Stored Procedures**

## Tools

**Microsoft SQL Server**  
**SQL Server Management Studio (SSMS)**

## Project Tasks

### 1. Fraud Transactions View
Created a reusable view containing fraudulent transactions for further analysis.

### 2. Merchant Category Analysis
Mapped merchant categories to broader category types and calculated fraud rates using JOINs, aggregation, and a CTE.

### 3. Top Fraudulent Transaction by Merchant Category
Used `ROW_NUMBER()` and `PARTITION BY` to identify the highest-value fraudulent transaction within each merchant category.

### 4. Merchant Categories with High Average Transaction Amount
Identified merchant categories with an average transaction amount greater than **$100**.

### 5. Fraud Rate by Authentication Method
Compared fraud rates across different authentication methods.

### 6. Fraud Risk Classification
Classified fraudulent transactions into **High, Medium, and Low Risk** based on merchant risk score.

### 7. Fraud Analysis Using Parameterized Stored Procedure
Created a parameterized stored procedure to retrieve fraudulent transactions based on merchant risk level.

## Project Files

- 📄 [SQL Query File](./Fraud_Analytics.sql)
- 📑 [Complete SQL Project Walkthrough](./Credit_Card_Fraud_Analysis_SQL_Project.pdf)

- [SQL Query File](./Fraud_Analytics.sql)
- [Complete Project Walkthrough](./Credit_Card_Fraud_Analysis_SQL_Project.pdf)

The PDF contains the task-wise SQL queries, analysis, and query outputs.

## Outcome

This project demonstrates how SQL can be used to move from **transaction data → analysis → measurable business insights**, while applying practical SQL techniques to a fraud-analysis use case.
