# Project Summary: Traffic Collisions in San Diego (SQL and Tableau)

## Context
I just finished my excel project and wanted to learn SQL. I actually originally wanted to skip straight to python for data analysis because it seemed cooler,
but I wanted to be versatile so I ended up choosing SQL. 

So now that I knew I wanted to tackle a project in SQL, I wanted to analyze real data that was much different than dance studio data. I was looking at data from
data.gov, but nothing seemed interesting; I still wanted to analyze something I'm somewhat familiar with. Eventually, I found a traffic collisions dataset from
San Diego's Open Data Portal. I have a fear of getting into a car accident, so I figured this would be interesting to analyze.

However, unlike the previous project where I had my manager to report to, I had to make up an audience that I believed could benefit.

I ultimately chose the San Diego Police Traffic Division Department. 

## Objectives
- To locate when and where the top collisions occur
- To visualize the trend of collisions per neighborhood
- To find the top reasons for collisions
- To create something helpful

## Techniques
Data cleaning
- Handled inconsistent data, irrelevant data, and null values
- Ensured data quality

Data exploration
- Handled duplicate records and skewed data
- Conducted various analysis including time and trend
- Aggregated, grouped, and filtered data to uncover insights
- Utilized CTEs for complex queries

Data visualization
- Created text tables, lines, and lots of bar charts
- Created calculated fields to better sort data and fix minimal errors
- Created 2 dashboards: One report dashboard and one interactive dashboard to help traffic officers

## Thought Process and What I Learned
Cleaning and exploring the data in SQL took so much longer than it needed to.

I cleaned way more than I needed to originally. I separated the date_time column into a data and time column. I created unnecessary new columns to better categorize the 
severity of injuries. However, I forgot who my audience was while cleaning and created more work for myself than I needed to. Writing my audience and the KPI's I needed
to find at the top of my SQL query helped to focus my energy and time.

The biggest mistake I made was deleting columns I thought I didn't need. I realize now how powerful SQL is; I didn't realize I can query around columns
and values I don't need. I will never delete columns or data unless absolutely necessary.

When creating my dashboard, I tried to fit all my graphs in, but they wouldn't all fit. I realized I should only show the VERY IMPORTANT insights and graphs in dashboards.

I even emailed my dashboards to the SDPD to use. Hopefully they see it!

## My two biggest takeaways from this whole project
- Keep your audience and KPIs in mind 24/7. Planning is key.
- The process is messy. It's not linear. But ... that's part of the fun.
