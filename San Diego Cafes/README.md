# Project Summary: San Diego Cafes
## Links
- [Cafe Tableau Data Visualization](https://public.tableau.com/app/profile/jayden.pagsolingan8481/viz/CafesinSanDiegoDashboard/Dashboard1)
## Context
I've worked on minor projects using python and finally decided to dedicate a project. 
## Objectives
- Use an API
- Perform basic analysis in python
- Visualize data in a new way
## Techniques
- API Calling
- Data Manipulation
- Data Cleaning
- Exploratory Data Analysis
- Geospatial Visualizations
## Insights
- Kearny Mesa has the most popular cafes in San Diego.
- The order of which cafes show up on Yelp changes slightly day-to-day.
- More than 3/4 of cafes serve coffee.
- Cafes typically have coffee or cafe in their name.
- 1/5 of cafes consider themselves a breakfast/brunch spot and another 1/5, a dessert spot.
- More than half of the top 50 cafes diversify themself in another category (ex/ gluten_free, mexican, asianfusion)
- A surprising 1/10 cafes pride themselves on offering acaibowls.
- The majority of popular cafes on Yelp are open 7 days out of the week.
## Thought Process and What I Learned
Smoother process than the last couple of projects. 

Before I started, I planned the project objectives and steps, with each step broken down into more steps. For instance, I knew I wanted to create a
map visualization of where the majority of the top cafes are located. So, I wrote down beforehand to clean the categories column and download a geospatial
file of San Diego neighborhoods.

The most difficult part was connecting the cafe dataset with the geospatial file. Originally, the data only gave the address, latitude, and longitude,
not the neighborhood, preventing me from visualizing the cafes. Therefore, I had to use a geocoding API called Nominatim to find the neighborhood for each. 
Additionally, there were minor differences between the neighborhoods in the dataset and the neighborhoods in the geo spatial file (Ex/ Mission Valley -> 
Mission Valley East & Mission Valley West); I used basic data manipulation techniques to correct these errors. Lastly, working on the project for multiple days 
caused the order of cafes to change slightly everyday, setting back all of the previous progress. To solve this, I exported the current dataset as a excel 
file to reimport every time the notebook reset.

The one thing I regret doing was deleting the 'id' column from the dataset; I didn't plan on conducting an analysis on each cafe's open/closing days. I had
to join a new cafe dataset with my current working dataset to find each cafe's id. In the future, I will not delete any columns from the dataset.

Overall, I would consider this project a success. I used 2 APIs (Yelp and Nominatim), analyzed the word frequency of the names of the most popular cafes, and 
used a geospatial file of San Diego neighborhoods to create a map visualization in Tableau.
