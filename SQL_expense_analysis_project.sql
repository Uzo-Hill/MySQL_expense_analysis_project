-- Creating a database named PROJECTS:

CREATE DATABASE IF NOT EXISTS PROJECTS;

-- Selecting our newly created database to use:

USE PROJECTS;

-- Create a table
CREATE TABLE expenditure (
		Expense_ID INT NOT NULL,
        Expense_code INT NOT NULL,
        Expense_type VARCHAR(255),
        Amount INT,
        Date_of_expense CHAR(15)
        );
        
-- We import our csv file into the created table using the data import wizard
-- Let's take a look at the imported csv data table:

SELECT * FROM expenditure LIMIT 10;

-- DATA CLEANING
-- Standardize the Date_of_expense column
SET SQL_SAFE_UPDATES = 0;

UPDATE expenditure SET Date_of_expense = STR_TO_DATE(Date_of_expense, "%m/%d/%Y");

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM expenditure; -- Date_of_expense column has successfully been formated to date datatype

-- Creating new columns (year and month name) from the Date_of_expense column

-- Adding Year column from the Date_of_expense column to the expenditure table:
SET SQL_SAFE_UPDATES = 0;

SELECT EXTRACT(YEAR FROM Date_of_expense) FROM expenditure; 

ALTER TABLE expenditure ADD COLUMN Year INT AFTER Date_of_expense;

UPDATE expenditure SET Year = EXTRACT(YEAR FROM Date_of_expense);

-- Adding Month name column from the Date_of_expense column to the table:
SELECT DATE_FORMAT (Date_of_expense, '%M') AS Month_name FROM expenditure;

ALTER TABLE expenditure ADD COLUMN Month_name VARCHAR(15) AFTER Year;

UPDATE expenditure SET Month_name = DATE_FORMAT (Date_of_expense, '%M');
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM expenditure; -- new look table with 2 more columns

-- CHECKING FOR DUPLICATES USING CTE AND ROW_NUM():
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY Expense_ID, Amount, Expense_code, Date_of_expense 
ORDER BY Date_of_expense) rownum
FROM expenditure)
SELECT COUNT(*) FROM CTE WHERE rownum > 1; -- 0 result, that's no duplicate records found.

-- Checking for outliers
SELECT * FROM expenditure
WHERE Year < 2021 or Year > 2022;  -- found a record id number 123 with Year as 2023.

-- Fixing the outlier value:
UPDATE expenditure
SET Year = 2021
WHERE Expense_ID = 123;

SELECT *
FROM expenditure
WHERE Expense_ID = 123; -- The outlier year value of 2023 has been fixed with the appropiate year of 2021.

-- EXPLORATORY DATA ANALYSIS (EDA)
-- 1. How many rows are in our expenditure dataset?
SELECT COUNT(*) AS Row_count
FROM expenditure; -- The dataset contains 1041 rows. 


-- 2. How many columns are in our expenditure data after cleaning?
SELECT COUNT(*) AS Number_of_columns FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'projects' AND table_name = 'expenditure'; -- The dataset has 7 columns.


-- 3. What are the different Expense types and count of the categorical column?
SELECT DISTINCT Expense_type 
FROM expenditure
ORDER BY Expense_type;

SELECT COUNT(DISTINCT Expense_type) FROM expenditure; -- 23 different types of expenses.

-- Checking that count of expense type matches count of the expense code:
SELECT COUNT(DISTINCT Expense_code) FROM expenditure; -- 23 different expense codes.


-- 4. What are the most frequent or most re-occurring expenses types:
CREATE VIEW expense_count_pct AS      -- A virtual table for the query
SELECT Expense_type, COUNT(*), ROUND((COUNT(*)/ (SELECT COUNT(*) FROM expenditure)) * 100, 1)
AS percentage
FROM expenditure
GROUP BY 1 ORDER BY 3 DESC;

SELECT * FROM expense_count_pct   -- Calling our virtual table
LIMIT 10;


-- 5. What is the total operational expenses made over the period (2021 - 2022)? 
SELECT SUM(Amount) AS Total_expenses
FROM expenditure;


-- 6. What is the total expenses made by year?
SELECT Year, SUM(Amount) AS Total_Expense_Per_Year
FROM expenditure
GROUP BY Year
ORDER BY Total_Expense_Per_Year DESC;


-- 7. Average expense made per year?
SELECT ROUND(SUM(Amount)/COUNT(DISTINCT Year)) AS AVG_Expenses
from expenditure;

SELECT * from expenditure;


-- 8. What are the top cost incurring expense type?
SELECT Expense_code, Expense_type, SUM(Amount) AS Total_Expense
FROM expenditure
GROUP BY Expense_type
ORDER BY Total_Expense DESC;


-- Top 10 most cost incurring expense type
SELECT Expense_code, Expense_type, SUM(Amount) AS Total_Expense
	FROM expenditure
		GROUP BY Expense_type
			ORDER BY Total_Expense DESC
				LIMIT 10;
                
                
-- 9. How much were spent on electricity bills in 2021 and 2022 respectively?
SELECT Year, SUM(Amount) AS Electricity_bill
FROM expenditure
WHERE Expense_type = 'Electricity bill'
GROUP BY Year;


-- total monthly expenses trend
SELECT Year, Month_name, SUM(Amount)
FROM expenditure
GROUP BY Month_name, Year;


-- percentage contribution by the different expenses types to the overall total expenses
SELECT Expense_type, ROUND((SUM(Amount)/ (SELECT SUM(Amount) FROM expenditure)) * 100, 1)
AS percentage
FROM expenditure
GROUP BY 1 ORDER BY 2 DESC;
