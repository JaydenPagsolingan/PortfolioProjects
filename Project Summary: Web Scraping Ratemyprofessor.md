# Project Summary: Web Scraping RateMyProfessors.com
## Links
- [Web Scraping Faculty Listing](https://github.com/JaydenPagsolingan/PortfolioProjects/blob/e3103e8920eea16c4c07c3c85dc1bd8f6e913583/R-Webscraping%20Faculty%20Listing.RMD)
- Cleaning Professor Names to Web Scrape - https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/CleanedProfessorNames.xlsx
- Web Scraping RateMyProfessors reviews - https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/R-Webscraping%20SDSU%20Ratemyprofessor%20Reviews.RMD
- Cleaning Professor Names to Conduct Second Round Searches - https://github.com/JaydenPagsolingan/PortfolioProjects/blob/main/SecondRoundSearches.xlsx
- Youtuber's RateMyProfessor Web Scraping Code - https://github.com/ggSamoora/TutorialsBySamoora/blob/main/rate_my_professor_script.Rmd
## Context
I wanted to get experience web scraping and analyzing my own extracted data. Why not try web scraping SDSU RateMyProfessors.com reviews?

Originally, I wanted to just scratch the surface of web scraping and extract SDSU professor reviews using an API. However, the APIs I found didn't seem to work with my computer. After two weeks of trying different APIS (all of which failed), I forced myself to continue the project without an API and learn web scraping in RStudio. 
## Objectives
- Learn webscraping
- Practice cleaning data in excel
## Techniques
- Web Automation with RSelenium
- Data Manipulation with Tidyverse
- Data Validation
- Handled blank values, missing names, multiple first and last names, and incorrect names.
- Handled Pop-ups and ads in Ratemyprofessor
- Handled Pagination
- Error Handling
- Dynamic URL construction and clicking on elements
## Thought Process and What I Learned
With zero experience in R, I found a Youtube tutorial where a programmer details code he wrote to web scrape RateMyProfessors. I used his pagination-handling and professor review-collecting code, but modified the code to handle errors and perform more tasks. 

Instead of unnecessarily collecting data from retired SDSU professors, I decided to web scrape SDSU's current faculty listing webste to extract only the current tenured faculty and lecturers. Once the dataset of current SDSU Professors was imported, I ran my code. The program searches for the Professor's last name and iterates through each professor card element to see if the first name in the list matches the first name in the card. If there is a match, then the program navigates to the actual Professor's RMP page and performs the review extraction loop--effectively adding all of the information to the data set. If the professor's name is not found, that professor is skipped.

However, some Professors have pages where their name is mispelled and therefore skipped. To handle this, if a professor's name is not found, I added an if statement which copies all of the other professor names into a new data set called ProfessorCheck. After finishing the first round of data extraction, I export the ProfessorCheck dataset into Excel to check for accidentally missed Professors. Surely enough, 65 professors had mispelled names. After formating the names into a new list called SecondRoundSearches, I imported the dataset into RStudio, modified the code, and ran the review-collecting loop again. 

Lastly, sometimes a Professor will have two RMP pages, one of which contains a link that no longer exists. This abruptly ends the program and does not collect the professor's data. To handle this, I took note of which professor's had a broken page and manually added the remaining professors into the review-collecting loop--succesfully finishing the data extraction project. 

Throughout the process, I felt constantly stuck. I learned to utilize ChatGPT and ask the right questions to debug my code. I learned to be persistent and to always have the end goal in mind. I learned to take breaks, to let my mind reset and come back with fresh eyes. 

Overall, I'm super proud of what I was able to learn and accomplish with this project and I hope to utilize web scraping more in the future!
