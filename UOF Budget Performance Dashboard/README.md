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
- FY 23-24 budget report: https://budget.sdsu.edu/_resources/files/budget/2023_24_university_budget_reports_v2.pdf
- FY 24-25 budget report: https://budget.sdsu.edu/_resources/files/budget/2024_25_university_budget_reports_uof.pdf
- FY 25-26 budget report: https://budget.sdsu.edu/_resources/files/budget/2025-26-university-budget-reports-uof-8-22-25.pdf

**Transform:** Used Power Query in Excel to clean and standardize budget data.

- Created an ETL function to easily transform data across 25 different budget tables and 3 budget reports
- Dynamically selected PDF tables using table number and division name parameters
- Renamed, removed, and reordered columns to standardize data structure
- Standardized data types for budget, actual, and variance fields
- Appended transformed tables of the same fiscal year to create a master table

**Load:** Data into Power BI.
- Loaded transformed data tables into Power BI

## Dashboard Features

Utilized a 1-3-10 design approach to ensure insights are clearly visible.

In 1 second: What is our overall budget position?
In 3 seconds: Which divisions and categories are driving the variance?
In 10 seconds: What is the root cause for these variances?

Dashboard Features:
- KPI cards - display total budget, total actual, total variance ($), total variance (%), and # of divisions over budget
- Variance Breakdown stacked bar chart - shows total variance ($) across divisions/categories; uses a slicer to toggle between division-level analysis and category-level analysis
- Budget vs Actual Trends line chart - displays total budget and total actual from FY22-23 to FY24-25
- Budget Variance Table - a table showing all budget, actual, total variance ($), and total variance (%) across divisions, categories, and fiscal years
- Fiscal Year, Division, and Category filter - allowing enhancing analysis across all visualizations

## Insights
**1. SDSU’s favorable variance increased in FY24-25, but the cause of the increase should be further investigated.**

Evidence: 
- Overall spending was $132.76 million below budget, with a 10% favorable variance
- 0/25 divisions were over budget compared to the 3/25 divisions over budget in the 2023-2024 fiscal year 
- Total dollar variance over the past fiscal years remained around $100 million, but increased by 25.2% from FY23-24 ($26.76 million).
- FY 22-23 had a $110 million favorable variance
- FY 23-24 had a $106 million favorable variance
- FY 24-25 had a $132.76 million favorable variance
  
Interpretation: Budget performance improved based on the fewer divisions over budget compared to the previous fiscal year. However, the increase in total favorable variance does not indicate increased efficiency. It may instead reflect changes in budget assumptions and reserve activity.
  
*Potential Action:* Further investigate the $26.76 million variance increase by division and category. Separate operational spending variances from reserve activities before making any evaluations or budgetary decisions.

**2. Designated Balances and Reserves accounts for the majority of SDSU’s FY24-25 total variance.**

Evidence: 
- Designated Balances and Reserves has a $107 million favorable variance, representing 81% of SDSU’s total variance
- Of this category, Academic Affairs and Student Affairs and Campus Diversity represent more than half of this variance (59.23%)
- Academic Affairs with a $34 million favorable variance
- Student Affairs and Campus Diversity with a $29 million favorable variance

Interpretation: SDSU’s variance is heavily influenced by its Designated Balances and Reserves, indicating SDSU’s $132.76 million total variance should not be solely interpreted as lower operating spending. Additionally, Academic Affairs and SA+CD are two departments that have the highest designated balances and reserves by a wide margin, indicating they have a big influence on SDSU’s total variance.

*Potential Action:* To properly evaluate resource utilization, Designated Balances and Reserves must be separate from other operational expenses. Analyze these expenses by diving further into the purpose of each category and the expected use of these budgets. Determine if other recurring variances represent intentional reserve planning or overbudgeting.

**3. Academic Affairs consistently has one of SDSU’s largest favorable dollar variances, prompting further investigation.**

Evidence: 
- Each fiscal year, Academic Affairs accounts for a large dollar variance of SDSU’s total variance
- FY22-23 - $37 million
- FY23-24 - $45.77 million 
- FY24-25 - $43.97 million
- Designated Balances and Reserves reports $28 million - $36 million of its annual budget
- Academic Affairs’ Operating Expense and Equipment category also consistently produces around a $6 million favorable variance. 
- In FY24-25, Operating Expense and Equipment had a $6.8 million variance at 20% variance.

Interpretation: Academic Affairs has a history of having a large favorable variance. While Designated Balances and Reserves accounts for a large percentage of this variance, Operating Expense and Equipment is the secondary contributor.

*Potential Action:* Further investigation needs to be done with Designated Balances and Reserves and Operating Expense and Equipment categories to determine whether favorable variances are caused by intentional reserve planning, delayed spending, or conservative budgeting. Use these findings to inform future budget projections.

**4. Operating Expense and Equipment variances have a consistent substantial variance across many divisions.**

Evidence: 
- 17/25 divisions reported an Operating Expense and Equipment variance greater than 15%
- However, dollar variances must be evaluated alongside percentage variances
- There seems to be no singular trend across all divisions for this category
- In FY 24-25, Student Affairs’s Operating Expense and Equipment had an unusual $15 million unfavorable variance
- Because of this high variance difference, further investigation needs to be done to identify if this was a budget transfer or budget adjustment.

Interpretation: A large percentage of divisions experience fluctuations in Operating Expense and Equipment variances; Student Affairs’ in particular budgeted significantly less than usual, creating a large unfavorable variance.

*Potential Action:* Dive deeper into each division’s Operating Expense and Equipment variances to better understand the impact of this category’s variance.

**5. The College of Graduate Studies has the highest division percentage variance among divisions, but a relatively smaller dollar variance.**

Evidence: 
- The College of Graduate Studies has the highest division percentage variance (36%)
- Designated Balances and Reserves account for $2.2 million of the $2.79 million total variance
- Operating Expenses and Equipment also represent a significant proportion of the division’s variance, accounting for 41% variance
- If we look closer at other categories, work study has a 43% unfavorable variance
- FY24-25 was the first year the division budgeted and spent on work study. They budgeted $4,500 but spent $6,434, resulting in an unfavorable $1,934 variance.

Interpretation: The College of Graduate Studies high percentage variance is largely influenced by designated balances and reserves. However, the Work Study variance provides a small opportunity to improve future budget projections.

*Potential Action:* Review factors contributing to the Work Study budget and what items contributed to the actual spending total. If similar spending is expected in the future, future budget projections can be modified.

## Challenges Encountered
1. The power query extracts all table data, including the summed up totals. These totals were left untouched and included in our dataset as I believed it was easier to create DAXs. While the DAX formulas were simple, the "Total Uses" rows prevented category-level visualizations from interacting with other filters. To fix, I created a back-up of the project and removed all "Total Uses" rows from the dataset using Power Query. While I had to replace visualization variables, category-level visualizations became compatible to the rest of the dashboard, resulting in deeper analysis capabilities.   


## Next Steps

