# Expense Analysis Project Documentation.
---
### Introduction:
---
> This is an SQL project on expense analysis of GIGL Asaba-3. GIGL Asaba-3 is one of many Experience Service Centers of GIG Logistics, Africa’s leading indigenous logistics company.
> 
> Analysing the expenses of a business helps management keep expenses under good control. Systematic analysis of expenses helps the company identify unnecessary expenses before they become large enough to pose a serious problem. Expense analysis also helps spot expense trends and enables the company to plan its finances better.
> 
> The balance between revenue and expenses keeps a business sustainable and financially healthy. To demonstrate my skill in the learning of SQL for data analysis, I will be carrying out my first data analysis portfolio project using the MySQL workbench as a tool in this project.
---

### Problem Statement:
#### The scope of this SQL data analysis project focuses majorly on answer the following questions:
+	What is the total operational expense made over the period from the available dataset?
+	What is the average expense made per year in the experience center?
+	What are the top cost incurring expense types?
+	What are the most reoccurring expense types?
+	What is the yearly and monthly total expense trends?
---

### Skills Demonstrated:
#### MySQL skills
+	Basic SQL queries e.g. CREATE, INSERT, ALTER, UPDATE, WHERE Clause, GROUP BY, ORDER BY etc.
+	MySQL data cleaning/wrangling – Handling dates with date format functions, duplicates, outliers.
+	Aggregate function such as AVG( ), COUNT( ), SUM( ), MAX( ), MIN( ) functions.
+	 Common Table Expression (CTE)
+	Window function such as ROW_NUMBER ( ) with PARTITION BY clause.
#### Excel skills
+ Pivot table, Pivot chart, dashboard, text-to-column formatting etc.
---

### Data Sourcing/ Collection:
#### The dataset for this project analysis was gotten from real-life data of weekly expense report of the daily expenses made in the experience centre from 2021 to 2022. Each week expense data report in Excel file was merged and saved as csv file to come up with our dataset. The dataset contains a record of the expense id, expense code, expense type, amount, and date of expense.
The date column values were uneven aligned due to the fact that excel treated the cells whose month value is greater than 12 as strings because it could not interpret them as date since the highest numerical value for month is 12. Before the data was imported into the MySQL Workbench, the date column values were all aligned to the left by using the excel text to column formatting.
> **_For security purpose, we'll not share the raw data source used for this project._**
---
Unaligned raw csv          |  Aligned csv data
:-------------------------:|:-------------------------:
![](https://github.com/Uzo-Hill/MySQL_expense_analysis_project/blob/main/Unaligned%20raw%20csv%20data.PNG)  |  ![](https://github.com/Uzo-Hill/MySQL_expense_analysis_project/blob/main/Aligned%20data%20using%20excel%20text-to-column.PNG)
---

### Database and Table
#### Before the dataset was imported into the MySQL workbench, we first of all created a database and a table in the MySQL workbench with field names to match the number of columns in the csv data. In creating the table, we specified the field names, then we added the data types of the columns and in the parenthesis we chose the size of the variables.

![Creating the database](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Creation%20of%20database%20Projects.PNG)
:----------------------------------------------------------------------------------------------------------------------------------:
  ###### _Creating the database Projects_
  ---

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Creating%20the%20database%20table%20expenditure.PNG)
:-------------------------------------------------------------------------------------------------------------------------:
  ###### _Creating the table expenditure_
---

##### The csv file was then imported using the MySQL data import wizard. To be sure the data was imported successfully; we take a look at the first 10 rows of the imported data.
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/The%20imported%20data.PNG)
---

### Data Cleaning and Preparation
1.	Standardize the date  column
---
  The ‘date_of_expense’ column is of string type. We used the CHAR datatype for the creation of the date_of_expense column. This is because our original csv data has the date column in the mm-dd-YYYY format. That is two digits for month, two digits for day and four digits for year. This is not the standard for date in MySQL.
We standardize the date_of_expense column by calling the **STR_TO_DATE ( )** function.

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Changing%20date%20datatype%20to%20MySQL%20date.PNG)
---

2. Adding more columns from the date column
---
  We created two more columns (year and month_name) from date_of_expense column. This is to simplify our table for easy understanding of the trends. We used the EXTRACT( ) function to add the year column to the table , while the month name column was added using the DATE_FORMAT( ) function.
  
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Adding%20Year%20and%20Month_name%20columns%20to%20the%20table.PNG)

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/New%20look%20table%20with%202%20more%20columns.PNG)
:-------------------------------------------------------------------------------------------------------------------------:
  ###### _New look table with two more columns_
---

3.	Handling of duplicates
---
I also checked for duplicates in the records using the common table expression (CTE) and the ROW_NUMBER( ) function.
The ROW_NUMBER( ) function assigns sequential rank number to each new record in a partition. This assigns a unique number to each row in the dataset and shows the number of times a row with the same data appears in the dataset.
>
With the CTE defined, I can easily select from it all records that appeared more than once. The query result is zero meaning there are no duplicates in our dataset.


_Checking for duplicates_  |  _Output for duplicate check_
:-------------------------:|:-------------------------:
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Checking%20for%20duplicates.PNG)  |  ![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Result%20set%20for%20duplicate%20records.PNG)
---

4.	Checking for outliers
---
I queried our data to be certain all records of expenses falls within the timeline of this analysis project i.e. between 2021 and 2022. I found record id number 123 having year value as 2023. This is an outlier value that must have probably be caused by typo at the time of data entry.

_Query for outlier_        |  _Output for outlier record_
:-------------------------:|:-------------------------:
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Query%20for%20outliers.PNG)  |  ![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Query%20result%20for%20outliers%20check.PNG)
---
From the position of the outlier in the table, it is obvious that correct year should be 2021. This was fixed by updating the table as shown below:

_Fixing the outlier vallue_|  _Outlier fixed_
:-------------------------:|:-------------------------:
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Fixing%20the%20outlier.PNG)  |  ![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Outlier%20fixed.PNG)
---

### Exploratory Data Analysis (EDA)
---
1.	What’s the shape of our table?
>
After the dataset was cleaned, we queried the table to determine the shape of our table. The result set shows the expenditure table has 1041 rows and 7 columns.

_Count of rows_            |  _Result set for number of row_
:-------------------------:|:-------------------------:
![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Count%20of%20rows.PNG)  |  ![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Result%20set%20for%20number%20of%20rows.PNG)


![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/number%20of%20columns.PNG)
:-------------------------------------------------------------------------------------------------------------------------:
  ###### _Number of columns_
---

2.	Checking for distinct values.
>
The expense_type column is a categorical type. Therefore we checked for the distinct values in the column.

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Distinct%20expense%20type.PNG)
:----------------------------------------------------------------------------------------------------:
 _Distinct expense type_
---

3.	What are the different Expense types and count of the categorical column?.

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Count%20of%20expense%20type.PNG)
:-----------------------------------------------------------------------------------------------------:
 _Count of expense type_
---

4.	What is the total operational expense made over the period (2021 - 2022) from the available dataset?

The result of our query showed that total of N2,187,110 was spent as expenses in the experience center from 2021 to 2022.

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Total%20expenses.PNG)
:------------------------------------------------------------------------------------------:
_Total expenses_
---

5.	What is the average expense made per year?

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Average%20expense%20per%20year.PNG)
:--------------------------------------------------------------------------------------------------------:
_Average spend per year_
---

6.	Top 10 most cost incurring expense type?

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Most%20cost%20incurring%20expense%20type.PNG2.PNG)
:-----------------------------------------------------------------------------------------------------------------------:
_Top 10 most cost incurring expense type_
---

7.  What are the most frequent or most re-occurring expense type?

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Resultset%20-%20most%20reocurring%20expense%20type.PNG)
:-----------------------------------------------------------------------------------------------------------------------------:
_Count of occurrence of the expense types_
---

8.	How much were spent on electricity bills in 2021 and 2022 respectively?

Amount spent on electricity bill in 2022 was significantly higher than that spent in 2021 as shown below:

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/Yearly%20electricity%20bill.PNG)
:------------------------------------------------------------------------------------------------------:
_Yearly electricity bills_
---


### Data visualisation
---
#### The result sets of the exploratory data analysis carried on the expenditure table data were exported back into Excel to produce different charts. I used these charts to make a simple dashboard. I would've love to make the dashboard more interactive, but because I was working with Excel 2007 which does not support slicers.

![](https://github.com/Uzo-Hill/SQL_expense_analysis_project/blob/main/expense_dashboard.png)
:--------------------------------------------------------------------------------------------:
_Expense analysis dashboard_
---

### Conclusion:
---
#### From this SQL data analysis project the following insights were drawn:
1.	A total of N2, 187,110 was spent as expenses in the center from 2021 – 2022.
2.	The average expense per year was N1, 093,555.
3.	Office Janitor expense is the highest with a total of N469000 (21.4%) spent. This is closely followed by electricity bill with a total of N420720 (19.2%).
4.	Transportation expense is the most re-occurring expense type with a count of 593 representing 57.0% of the total number of expenses. This should be looked into in order to drastically reduce the number.
---

### Recommendation
---
+ With the results obtained from the expense data analysis, management should look into the expenses especially in area of transportation, and find the possible causes and solutions to the repeated expenses.
+ Also, more analysis should be carried out on the center's sales data in order determine and compare the revenue growth with its expenditure.
---









#                                  THANK YOU!





