# Project Summary: Web Scraping RateMyProfessors.com
## Links
- [Web Scraping Faculty Listing](https://github.com/JaydenPagsolingan/PortfolioProjects/blob/e3103e8920eea16c4c07c3c85dc1bd8f6e913583/R-Webscraping%20Faculty%20Listing.RMD)
- [Cleaning Professor Names to Web Scrape](https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/CleanedProfessorNames.xlsx)
- [Web Scraping RateMyProfessors Reviews](https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/R-Webscraping%20SDSU%20Ratemyprofessor%20Reviews.RMD)
- [Cleaning Professor Names to Conduct Second Round Searches](https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/SecondRoundSearches.xlsx)
- [Youtuber's RateMyProfessor Web Scraping Code](https://github.com/ggSamoora/TutorialsBySamoora/blob/main/rate_my_professor_script.Rmd)
## Context
I wanted to get experience web scraping by extracting RateMyProfessor reviews. Initially, I wanted to use an API, but the APIs I found didn't work with my computer and the RMP page dynamically loads. Thus, I forced myself to learn R and web scrape using RStudio. 
## Objectives
- Learn webscraping
- Practice cleaning data in excel
## Techniques
- Web Automation with RSelenium
- Data Manipulation with Tidyverse
- Data Validation
- Handled Blank Values, Missing Names, Multiple First and Last Names, and Incorrect Names.
- Pop-ups, Ads, Pagination, and Error Handling
- Dynamic URL Construction
## Thought Process and What I Learned
With no prior experience in R, I found a Youtube tutorial to get the bulk of my code, modifying the loop to handle errors and perform more tasks. I scraped SDSU's current faculty listing webste to extract only active tenured faculty and lecturers. The program searches for a Professor's last name and iterates through each professor card element to see if their first name in the list matches the first name in the card. If there is a match, the program navigates to the Professor's RMP page and collects reviews.

However, some Professors have pages where their name is mispelled and therefore skipped. To handle potentially missed professors, I added an if-statement which copies all of the other professor names into a new data set called ProfessorCheck. Surely enough, 65 professors were skipped due to their mispelled name on RMP. After formating their names into a new list called SecondRoundSearches, I imported the dataset into RStudio, modified the code, and ran the review-collecting loop again. 

Lastly, sometimes a Professor will have two RMP pages, one of which contains a link that no longer exists. This abruptly ends the program and does not collect the professor's data. To handle this, I took note of which professor's had a broken page and manually added the remaining professors into the review-collecting loop--succesfully finishing the data extraction project. 

Throughout the process, I felt constantly stuck. I learned to utilize ChatGPT and ask the right questions to debug my code. I learned to be persistent and to always have the end goal in mind. I learned to take breaks, to let my mind reset and come back with fresh eyes. 

Overall, I'm super proud of what I was able to learn and accomplish with this project and I hope to utilize web scraping more in the future!
