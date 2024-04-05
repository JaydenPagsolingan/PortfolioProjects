# Project Summary: Web Scraping RateMyProfessors.com
## Links
- [Youtuber's RateMyProfessors Web Scraping Code](https://github.com/ggSamoora/TutorialsBySamoora/blob/main/rate_my_professor_script.Rmd)
## Context
I wanted to get experience web scraping by extracting RateMyProfessors reviews. Initially, I wanted to use an API, but the APIs I found didn't work with my computer and the RMP page dynamically loads. Thus, I forced myself to learn R and web scrape using RStudio. 
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
With no prior experience in R, I found a YouTube tutorial to get the bulk of my code, modifying the loop to handle errors and perform more tasks. I scraped SDSU's current faculty listing website to extract only active tenured faculty and lecturers. The program searches for a professor's last name and iterates through each professor card element to see if their first name in the list matches the first name on the card. If there is a match, the program navigates to the professor's RMP page and collects reviews.

However, some professors have pages where their name is misspelled, and therefore, they are skipped. To handle potentially missed professors, I added an if-statement that copies all of the other professor names into a new dataset called ProfessorCheck. Surely enough, 65 professors were skipped due to their misspelled name on RMP. After formatting their names into a new list called SecondRoundSearches, I imported the dataset into RStudio, modified the code, and ran the review-collecting loop again.

Lastly, sometimes a professor will have two RMP pages, one of which contains a link that no longer exists. This abruptly ends the program and does not collect the professor's data. To handle this, I took note of which professors had a broken page and manually added the remaining professors into the review-collecting loop—successfully finishing the data extraction project.

Throughout the process, I felt constantly stuck. I learned to utilize ChatGPT and ask the right questions to debug my code. I learned to be persistent and always have the end goal in mind. I learned to take breaks, allowing my mind to reset and come back with fresh eyes.

Overall, I'm super proud of what I was able to learn and accomplish with this project, and I hope to utilize web scraping more in the future!
