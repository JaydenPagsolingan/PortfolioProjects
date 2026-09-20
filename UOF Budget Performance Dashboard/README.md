# Project: SDSU Budget Analysis Dashboard
## Project Overview and Objectives

**What:** An interactive dashboard extracting SDSU University Operating Fund budget data.

**Objectives:**
- Understand how SDSU is managing its financial resources over time
- Enable SDSU stakeholders to analyze, track, and manage SDSU budget spending
- Support data-driven decisions and identify spending patterns across divisions

**Key Technologies:** Power Query, Power BI, Excel, DAX

## Data Pipeline

**Extract:** Downloaded SDSU Fiscal Budget Reports from the SDSU University Budget website.

Reports used:
FY 23-24 budget report: https://budget.sdsu.edu/_resources/files/budget/2023_24_university_budget_reports_v2.pdf
FY 24-25 budget report: https://budget.sdsu.edu/_resources/files/budget/2024_25_university_budget_reports_uof.pdf
FY 25-26 budget report: https://budget.sdsu.edu/_resources/files/budget/2025-26-university-budget-reports-uof-8-22-25.pdf

**Transform:** Used Power Query in Excel to clean and standardize budget data.

- Created an ETL function to easily transform data across 25 different budget tables and 3 budget reports
- Dynamically selected PDF tables using table number and division name parameters
- Renamed, removed, and reordered columns to standardize data structure
- Standardized data types for budget, actual, and variance fields
- Appended transformed tables of the same fiscal year to create a master table

**Load:**: Data into Power BI.
- Loaded transformed data tables into Power BI

## Dashboard Features

Utilized a 1-3-10 design approach to create easily understandable insights.

- KPI cards - display total budget, total actual, total variance ($), total variance (%), and # of divisions over budget
- Variance Breakdown stacked bar chart - shows total variance ($) across divisions/categories; uses a slicer to toggle between division-level analysis and category-level analysis
- Budget vs Actual Trends line chart - displays total budget and total actual from FY22-23 to FY24-25
- Budget Variance Table - a table showing all budget, actual, total variance ($), and total variance (%) across divisions, categories, and fiscal years
- Fiscal Year, Division, and Category filter - allowing enhancing analysis across all visualizations

## Data Quality Checks

