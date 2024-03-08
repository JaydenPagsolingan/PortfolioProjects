# Project Summary: Dataset Generation and PowerBI Sales Analysis
## Links
- 
## Context
From talking with peers and analyst in the industry, PowerBI seems to be gaining popularity. After gaining experience in Tableau, I wanted to try out PowerBI.  
## Objectives
- Create a fake retail dataset in python
- Utilize fundamental PowerBI techniques
- Create a sales dashboard analyzing the trends and KPIS
## Techniques
- Data Manipulation
- Power Query
- Data Modeling
- DAX
- Data Visualization
## Thought Process and What I Learned
After planning all the steps needed for the project, I created three dataset:

- Store Dataset: SKU, Product Name, Price, Production Cost
- Customer Dataset: First Name, Last Name, Email, Age, Sex
- Sales Dataset: Email, SKU, Units Sold, sales-channel, location, date

Then, I imported all the datasets into PowerBI, created relationships between tables, and visualized the data. Everything went smoothly until...

... I realized all my data was equally distributed. For example, every age group, sex, and location had the same units sold. Every product had the same amount of units sold. It was hard to discover any insights as, quite frankly, the data was boring to look at. Therefore, I had to go back into my python program and implement an element randomness for each column--creating random probabilities, means, and standard deviations. This allowed my data to be more skewed... and therefore more interesting.

Lastly, I learned to conglomerate multiple charts and insights into one visualization. I wanted to flood my dashboard with one chart about age distribution, one chart comparing profit over different locations, and numerous other charts. However, I remembered the phrase, "less is more," and shrunk everything into a couple visualizations. I believe my dashboard now looks more digestible.
