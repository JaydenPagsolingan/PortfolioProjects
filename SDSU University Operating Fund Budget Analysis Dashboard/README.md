# Project: SDSU University Operating Fund Budget Analysis Dashboard
Power BI | Power Query | Excel | DAX | Financial Analysis

<img width="1313" height="728" alt="Fiscal Year Filter" src="https://github.com/user-attachments/assets/aefc620d-c00b-4708-ad0a-ae9399659430" />

## Project Overview

**What:** An interactive dashboard analyzing SDSU University Operating Fund budget data across fiscal years, divisions, and spending categories.

**Business Problem:** The SDSU Budget and Finance department has a repository of budget reports ranging from 2021 to 2026. However, there is not a publicly available way to conduct a variance analysis of budget data. This project aims to transform raw budget report pdfs into a consolidated dataset and dashboard, enabling SDSU stakeholders to monitor and analyze budget variances, investigate divisions and spending categories, and inform future budget forecasting and resource planning. 

**Business Objectives**
- What is SDSU's UOF financial position in FY24-25?
- What are the largest favorable and unfavorable variances by division and category?
- Which recurring variances warrant further investigation?

**Intended Stakeholder**
- Primary Audience: Senior leadership and budget stakeholders
- Use case: Monitor budget performance, investigate variances and trends, and inform resource planning.

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

**Conceptual Diagram:**
<img width="993" height="407" alt="ETL Pipeline" src="https://github.com/user-attachments/assets/0e1f9500-3410-4462-a6f7-2f732edcbc62" />

## Data Quality and Validation
Performed data quality and validation checks throughout the ETL process to ensure budget data is accurate and consistent.
- Verified extracted division names were consistent across budget reports
- Confirmed all 25 divisions were consolidated in the final FY dataset
- Compared extracted totals with reported totals in budget reports
- Validated data tables to ensure consistent data structures
- Investigated "Total Uses" rows, identified rows caused downstream visualization errors, and removed rows to prevent double-counting and improve filtering interactions
- Revalidated dashboard totals with report totals

## Dashboard Design
Utilized a 1-3-10 design approach to ensure insights are clearly visible.
| Time | Question | Dashboard Element |
| -------- | -------- | -------- |
| In 1 second | What is our overall budget position? | KPI Cards |
| In 3 seconds | Which divisions and categories are driving the variance? | Variance Breakdown Bar and Line Charts |
| In 10 seconds | What factors may be contributing to these variances? | Detailed Variance Table + Filters |

## Dashboard Features
- KPI cards - display total budget, total actual, total variance ($), total variance (%), and # of divisions over budget
- Variance Breakdown stacked bar chart - shows total variance ($) across divisions/categories; uses a slicer to toggle between division-level analysis and category-level analysis
- Budget vs Actual Trends line chart - displays total budget and total actual from FY22-23 to FY24-25
- Budget Variance Table - a table showing all budget, actual, total variance ($), and total variance (%) across divisions, categories, and fiscal years
- Fiscal Year, Division, and Category filter - allowing enhancing analysis across all visualizations

## DAX Measures
- Total Budget = SUM(BudgetData[Budget])
- Total Actual = SUM(BudgetData[Actual])
- Total Variance ($) = [Total Budget] - [Total Actual]
- Total Variance (%) = DIVIDE([Total Variance ($)],[Total Budget])
- Divisions Over Budget = COALESCE(
    COUNTROWS(
        FILTER(
            VALUES(BudgetData[Division]),
            [Total Variance ($)] < 0
        )
    ),
    0
) *Used AI to help create this DAX*

## Insights

**High-level Summary: SDSU's $132.76 million favorable variance is primarily driven by changes in reserves accounts, not operational efficiency.**

Designated Balances and Reserves account for 81% of total variances, with Academic Affairs and Student Affair and Cultural Diversity divisions representing 59% of reserve variances alone.
While fewer divisions are overbudget compared to the FY23-24, the 25% increase in total variance reflects changes in reserve planning than improved spending control.

Secondary Concerns:
- Academic Affairs consistently maintains a $37-$46 million annual variance, warranting an analysis of if this reflects conservative budgeting or intentional reserves
- Operating Expense and Equipment has high percentage variances across many divisions (17/25 divisions), prompting further investigation
- College of Graduate studies' high percentage variance is largely driven by reserves, with minimal operational impact  

Recommendation: 
1. Separate Designated Balances and Reserves from operational spending when evaluating budget utilization.
2. Investigate Academic Affair's annual variances by category to identify the main factors behind its large total variance.
3. Analyze recurring Operating Expense and Equipment variances across divisions and adjust future budget projections based on findings.

## In-Depth Analysis Breakdown 

**1. SDSU’s favorable variance increased in FY24-25, but the cause of the increase should be further investigated.**

Evidence: 
- Overall spending was $132.76 million below budget, with a 10% favorable variance
- 0/25 divisions were over budget compared to the 3/25 divisions over budget in the 2023-2024 fiscal year 
- Total dollar variance over the past fiscal years remained around $100 million, but increased by 25.2% from FY23-24 ($26.76 million).
- FY 22-23 had a $110 million favorable variance
- FY 23-24 had a $106 million favorable variance
- FY 24-25 had a $132.76 million favorable variance
  
Interpretation: In FY24-25, fewer divisions over budget compared to the previous fiscal year. However, the increase in total favorable variance does not indicate increased efficiency. It may instead reflect changes in budget assumptions and reserve activity.
  
*Follow-up Analysis:* Further investigate the $26.76 million variance increase by division and category. Separate operational spending variances from reserve activities before making any evaluations or budgetary decisions.

**2. Designated Balances and Reserves accounts for the majority of SDSU’s FY24-25 total variance.**

Evidence: 
- Designated Balances and Reserves has a $107 million favorable variance, representing 81% of SDSU’s total variance
- Of this category, Academic Affairs and Student Affairs and Campus Diversity represent more than half of this variance (59.23%)
- Academic Affairs with a $34 million favorable variance
- Student Affairs and Campus Diversity with a $29 million favorable variance

Interpretation: SDSU’s variance is heavily influenced by its Designated Balances and Reserves, indicating SDSU’s $132.76 million total variance should not be solely interpreted as lower operating spending. Additionally, Academic Affairs and SA+CD are two departments that have the highest designated balances and reserves by a wide margin, indicating they have a big influence on SDSU’s total variance.

*Follow-up Analysis:* To properly evaluate resource utilization, Designated Balances and Reserves must be separate from other operational expenses. Analyze these expenses by diving further into the purpose of each category and the expected use of these budgets. Determine if other recurring variances represent intentional reserve planning or overbudgeting.

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

*Follow-up Analysis:* Further investigation needs to be done with Designated Balances and Reserves and Operating Expense and Equipment categories to determine whether favorable variances are caused by intentional reserve planning, delayed spending, or conservative budgeting. Use these findings to inform future budget projections.

**4. Operating Expense and Equipment variances have a consistent substantial variance across many divisions.**

Evidence: 
- 17/25 divisions reported an Operating Expense and Equipment variance greater than 15%
- However, dollar variances must be evaluated alongside percentage variances
- There seems to be no singular trend across all divisions for this category
- In FY 24-25, Student Affairs’s Operating Expense and Equipment had an unusual $15 million unfavorable variance
- Because of this high variance difference, further investigation needs to be done to identify if this was a budget transfer or budget adjustment.

Interpretation: A large percentage of divisions experience fluctuations in Operating Expense and Equipment variances; Student Affairs’ in particular budgeted significantly less than usual, creating a large unfavorable variance.

*Follow-up Analysis:* Dive deeper into each division’s Operating Expense and Equipment variances to better understand the impact of this category’s variance.

**5. The College of Graduate Studies has the highest division percentage variance among divisions, but a relatively smaller dollar variance.**

Evidence: 
- The College of Graduate Studies has the highest division percentage variance (36%)
- Designated Balances and Reserves account for $2.2 million of the $2.79 million total variance
- Operating Expenses and Equipment also represent a significant proportion of the division’s variance, accounting for 41% variance
- If we look closer at other categories, work study has a 43% unfavorable variance
- FY24-25 was the first year the division budgeted and spent on work study. They budgeted $4,500 but spent $6,434, resulting in an unfavorable $1,934 variance.

Interpretation: The College of Graduate Studies high percentage variance is largely influenced by designated balances and reserves. However, the Work Study variance provides a small opportunity to improve future budget projections.

*Follow-up Analysis:* Review factors contributing to the Work Study budget and what items contributed to the actual spending total. If similar spending is expected in the future, future budget projections can be modified.

