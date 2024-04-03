/*

Traffic Collisions in San Diego Data Analysis Project

Contents:
Data Cleaning
Data Exploration (Clean and Messy Versions)

Project Planning -
Audience: San Diego Police Department Traffic Division
Key Performance Indicators:
- When and where the top collisions occur
- Trend of collisions per neighborhood
- Reasons for collision

*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*

Data Cleaning Section

*/

SELECT *
FROM collisions


-- I normally wouldn't delete columns, but just for this portfolio project I will

ALTER TABLE collisions
DROP COLUMN person_role, person_veh_type, veh_make, veh_type, veh_model, address_no_primary, address_pd_primary, address_pd_intersecting, hit_run_lvl, injured, killed

-- Cleaning report_id
-- I'm gonna delete these 5 null report_id columns because it's only 5 rows (so it won't impact the results significantly) and it'll make data exploration easier

SELECT *
FROM collisions
WHERE report_id IS NULL

DELETE FROM collisions
WHERE report_id IS NULL

-- Cleaning date_time

SELECT *
FROM collisions
WHERE report_id IS NULL
-- None which is awesome, so I'll leave as is

-- Cleaning person_role

SELECT *
FROM collisions
WHERE report_id IS NULL

-- Cleaning person_injury_level

SELECT DISTINCT person_injury_lvl
FROM collisions

-- I'm going to assume null values are unharmed individuals so I'll replace NULL with UNHARMED

SELECT person_injury_lvl,
	CASE WHEN person_injury_lvl IS NULL THEN 'UNHARMED'
	ELSE person_injury_lvl
	END as UPDATED_person_injury_lvl
FROM collisions

UPDATE collisions
SET person_injury_lvl = 
	CASE WHEN person_injury_lvl IS NULL THEN 'UNHARMED'
	ELSE person_injury_lvl
	END

-- On second thought, I also want to replace 'visable', 'pain', and 'severe' with 'INJURED' for simplicity

SELECT person_injury_lvl,
	CASE WHEN person_injury_lvl IN ('PAIN','SEVERE','VISABLE') THEN 'INJURED'
	ELSE person_injury_lvl
	END as UPDATED_person_injury_lvl
FROM collisions

UPDATE collisions
SET person_injury_lvl = 
	CASE WHEN person_injury_lvl IN ('PAIN','SEVERE','VISABLE') THEN 'INJURED'
	ELSE person_injury_lvl
	END

-- Now that I'm thinking about it, let's also rename the column to 'person_condition' in the design menu and rename 'FATAL' to 'DEAD

SELECT person_injury_lvl,
	CASE WHEN person_injury_lvl = 'FATAL' THEN 'DEAD'
	ELSE person_injury_lvl
	END as UPDATED_person_injury_lvl
FROM collisions

UPDATE collisions
SET person_injury_lvl =
	CASE WHEN person_injury_lvl = 'FATAL' THEN 'DEAD'
	ELSE person_injury_lvl
	END

-- Cleaning address_road_primary and address_sfx_primary

-- Check for nulls
SELECT DISTINCT address_road_primary
FROM collisions
WHERE address_sfx_primary IS NULL

-- I'm deleting this single entry with NULL for both address_road_primary and address_sfx_primary
SELECT *
FROM collisions
WHERE address_road_primary IS NULL AND address_sfx_primary  IS NULL

DELETE FROM collisions
WHERE address_road_primary IS NULL AND address_sfx_primary  IS NULL

-- Let's combine them into one primary address in a new column
SELECT address_road_primary, address_sfx_primary, CONCAT(address_road_primary, ' ',address_sfx_primary) AS primary_address
FROM collisions

UPDATE collisions
SET primary_address = CONCAT(address_road_primary, ' ',address_sfx_primary)


-- Cleaning address_name_intersecting and address_sfx_intersecting

-- Checking values
SELECT *
FROM collisions
WHERE address_name_intersecting IS NULL AND address_sfx_intersecting  IS NULL
-- I don't think I need to rename NULL values because it won't affect my analysis
SELECT address_name_intersecting, address_sfx_intersecting, 
	CASE WHEN address_name_intersecting IS NULL AND address_sfx_intersecting  IS NULL THEN 'NONE'
	ELSE CONCAT(address_name_intersecting, ' ',address_sfx_intersecting)
	END AS intersecting_address
FROM collisions

UPDATE collisions
SET intersecting_address = 
	CASE WHEN address_name_intersecting IS NULL AND address_sfx_intersecting  IS NULL THEN 'NONE'
	ELSE CONCAT(address_name_intersecting, ' ',address_sfx_intersecting)
	END

SELECT DISTINCT intersecting_address
FROM collisions

-- Cleaning violation_section

SELECT DISTINCT violation_section
FROM collisions
-- Looks good to me

-- Cleaning violation_type

Select DISTINCT violation_type
FROM collisions
-- I don't think I'll need this column, but I'll keep it just in case when analyzing charge_desc.

-- Cleaning charge_desc

SELECT DISTINCT charge_desc
FROM collisions
-- Looks good

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*

Data Exploration (The Cleaner Version)
Main Takeaways:
- Traffic collisions have decreased from 2022 to 2023.
- The top 5 most collision-prone neighborhoods of 2022 have generally decreased in # of collisions, except Mira Mesa.
- Neighborhoods with Increased Collisions: Logan Heights, Kearny Mesa, Linda Vista, Grantville, Scripps Ranch.
- Streets with Increased Collisions: El Cajon Blvd, Mira Mesa Blvd, Friars Rd, Imperial Ave, and University Ave.
- Misellaneous Hazard Violations of the Vehicle Code are a concerning % of the charges. 
	This leaves a big ? on what the primary charges should be if these misc. charges are sorted.
- The majority of collisions are caused by unsafe turns and speeding.
- Unsafe lane changes have decreased, but speeding may increase by the end of 2023. 
- Overall, the traffic division has done a great job at prevent collisions in the more-collision prone areas.
*/

-- 1. What time did most traffic collisions occur?

-- Grouped all traffic collisions for every half hour
SELECT
    FORMAT(date_time, 'hh') AS hour,
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END AS half_hour,
	FORMAT(date_time, 'tt') AS am_pm,
    COUNT(DISTINCT report_id) AS collision_count
FROM
    collisions
WHERE FORMAT(date_time, 'hh') <> 0 AND DATEPART(MINUTE, date_time) NOT IN (0,1) AND YEAR(DATE_TIME) = 2023
GROUP BY
    FORMAT(date_time, 'hh'),
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END,
	FORMAT(date_time, 'tt')
ORDER BY
    collision_count DESC;

-- Insight: The majority of collisions seem to occur around 3:30-5:30pm.

------------------------------------------------------------------------------------------------------------------------------

-- 2. Have collisions decreased from 2022 to 2023?

-- Displays the # of collisions in 2022 and 2023
SELECT DATEPART(year, date_time) as Year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE DATEPART(year, date_time) >=2022
GROUP BY DATEPART(year, date_time)

-- Insight: Yes, by 908. However, it's important to note that the data was downloaded mid-November.

------------------------------------------------------------------------------------------------------------------------------

-- 3. What are the top 10 primary charges for traffic collisons (2022-2023)

-- Created a CTE to get 2 individuals columns for collisions in 2022 and 2023
WITH CollisionsCounts AS (
    SELECT 
        charge_desc,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2022 THEN report_id END) AS CollisionCount2022,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2023 THEN report_id END) AS CollisionCount2023
    FROM 
        collisions
    WHERE 
        YEAR(date_time) IN (2022, 2023)
    GROUP BY 
        charge_desc
)

SELECT TOP 10 charge_desc, CollisionCount2022, CollisionCount2023
FROM CollisionsCounts
ORDER BY CollisionCount2022 DESC

-- Insight: The primary charges are unsafe turns, misccellaneous violations, and speeding. 
-- Misc. violations is the 2nd highest charge, but acts like a "catch-all" term if the charge
-- was unknown are is a very specific and non-reoccuring charge.

------------------------------------------------------------------------------------------------------------------------------

-- 4. Which neighborhoods are increasing and decreasing in collisions (2022-2023)?

-- Same as #3
WITH CollisionsCounts AS (
    SELECT 
        neighborhood,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2022 THEN report_id END) AS CollisionCount2022,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2023 THEN report_id END) AS CollisionCount2023
    FROM 
        collisions AS c
    INNER JOIN 
        beatcode ON c.police_beat = beatcode.beat
    WHERE 
        YEAR(date_time) IN (2022, 2023)
    GROUP BY 
        neighborhood
)
-- Queried off the CTE to find where collisions increased or decreased
SELECT 
    neighborhood as Neighborhood,
    CollisionCount2022,
    CollisionCount2023,
    CASE 
        WHEN (CollisionCount2022 - CollisionCount2023) < 0 THEN 'INCREASE'
        WHEN (CollisionCount2022 - CollisionCount2023) > 0 THEN 'DECREASE'
        ELSE 'NONE'
    END AS IncreaseOrDecrease,
	abs(CollisionCount2022 - CollisionCount2023) AS Difference
FROM 
    CollisionsCounts
-- I switched between fitlering only increase and only decrease
WHERE (CollisionCount2022 - CollisionCount2023) > 0 
-- I originally ordered by CollisionCount2022 descending to get an overall view, but ordered by difference to find the biggest changes
ORDER BY Difference desc

/* Insights: 
Overall, we see a decrease in collisions.


The top 3 neighborhoods that had the most collisions in 2022 have dropped in 2023.
Pacific Beach by 147 collisions (awesome)
East Village by 71 collisions (nice)
North Park by 49 collisions (sweet)
This means that traffic enforcement has been effective in mitigating collisions in these areas.

However, a few locations had a concerning increase in collisions.
Logan Heights by 42 collisions
Kearney Mesa by 24 collisions
Linda Vista by 22 collisions
Scripps Ranch and Grantville by 16 collisions
These locations need more traffic enforcement.

*/

------------------------------------------------------------------------------------------------------------------------------

-- 5. Which specific address are increasing and decreasing in collisions (2022-2023)


-- Same process as #4
WITH CollisionsCounts AS (
    SELECT 
        primary_address, 
        intersecting_address, 
        neighborhood,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2022 THEN report_id END) AS CollisionCount2022,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2023 THEN report_id END) AS CollisionCount2023
    FROM 
        collisions AS c
    INNER JOIN 
        beatcode ON c.police_beat = beatcode.beat
    WHERE 
        YEAR(date_time) IN (2022, 2023)
    GROUP BY 
        primary_address, intersecting_address, neighborhood
)

SELECT 
    primary_address as PrimaryAddress, 
    intersecting_address as IntersectingAddress, 
    neighborhood as Neighborhood,
    CollisionCount2022,
    CollisionCount2023,
    CASE 
        WHEN (CollisionCount2022 - CollisionCount2023) < 0 THEN 'INCREASE'
        WHEN (CollisionCount2022 - CollisionCount2023) > 0 THEN 'DECREASE'
        ELSE 'NONE'
    END AS IncreaseOrDecrease,
	abs(CollisionCount2022 - CollisionCount2023) AS Difference
FROM 
    CollisionsCounts
WHERE (CollisionCount2022 - CollisionCount2023) > 0 
ORDER BY Difference desc

/* Insights: 

Overall,
Garnet Ave and Grand Ave have seen a signifcant decrease in collisions (LESS 33 and 26 collisions)
However, Linda Vista Road, Palm Avenue, Mirarmar Road have seen increases greater than 10 collisions.
minimal decrease or even an increase in collisions. More attention needs to be put here.

*/

------------------------------------------------------------------------------------------------------------------------------

-- 6. What are the primary charge descriptions for each address (ignores misc.)

-- Created a CTE to rank all the addresses descending
WITH RankedAddresses AS(
	SELECT primary_address as PrimaryAddress, neighborhood as Neighborhood, charge_desc as ChargeDescription, COUNT(DISTINCT report_id) as CollisionCount,
	ROW_NUMBER() OVER (PARTITION BY primary_address ORDER BY COUNT(DISTINCT report_id) DESC, charge_desc) AS Rank
	FROM collisions
	INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
	WHERE YEAR(date_time) = 2023 AND Charge_desc <> 'MISCELLANEOUS HAZARDOUS VIOLATIONS OF THE VEHICLE CODE'
	GROUP BY primary_address, neighborhood, charge_desc
)
-- Queried off the CTE to find the top reason for each Address
SELECT PrimaryAddress, Neighborhood, ChargeDescription, CollisionCount
FROM RankedAddresses
WHERE Rank = 1
Order BY CollisionCount DESC

/* Insights: Let's find the primary charge for each of the problem addresses mentioned in #5
Mira Mesa Blvd: Speeding
Sports Arena Blvd: Unsafe Turns
Sunset Cliffs Blvd: Unsafe Turns
Mirarmar Road: Unsafe Turns


As we discovered before, speeding and unsafe turns are the #1 reason for collisions. 
Patrolling policemen can look out for these 2 charges in these areas.
*/

------------------------------------------------------------------------------------------------------------------------------

-- 7. Are unsafe lane change-caused collisions decreasing?

-- Filtered to only show collisions caused by speeding and sorted # of collisions by year
SELECT DATEPART(year, date_time) AS Year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE charge_desc LIKE 'Turn%' AND YEAR(date_time) >= 2019
GROUP BY DATEPART(year, date_time)
ORDER BY  DATEPART(year, date_time) DESC

-- Insight: Yes!

------------------------------------------------------------------------------------------------------------------------------

-- 8. Are speeding-caused collisions decreasing?

-- Same process as #7
SELECT DATEPART(year, date_time) AS Year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE charge_desc LIKE '%Speed%' AND YEAR(date_time) >= 2019
GROUP BY DATEPART(year, date_time)
ORDER BY  DATEPART(year, date_time) DESC

-- Insight: Yes, however the difference in collisions from 2023 to 2022 is only by 62 collisions.
-- This means that the # of collisions could end greater than 2022. 
-- More effort can be put into catching speeding violations

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*

Data Exploration Section (The Messy Version)

*/

-- What time do collisions most often occur?

SELECT
    FORMAT(date_time, 'hh') AS hour_of_collision,
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END AS half_hour,
	FORMAT(date_time, 'tt') AS am_pm,
    COUNT(DISTINCT report_id) AS collision_count
FROM
    collisions
GROUP BY
    FORMAT(date_time, 'hh'),
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END,
	FORMAT(date_time, 'tt')
ORDER BY
    collision_count DESC;

-- I found a Possible Error - 0:00 has the highest collision count.
-- Which minutes are responsible for this high collision count?
SELECT DATEPART(MINUTE, date_time) AS MIN, COUNT(DISTINCT report_ID) AS CollisionCount
FROM collisions
WHERE DATEPART(HOUR, date_time) = 17
GROUP BY DATEPART(MINUTE, date_time)
ORDER BY CollisionCount DESC
-- 12:01AM with 1432 collisions and 12:00AM with 886 collisions

-- After testing different hours, it seems like the SDPD sometimes records incidents at the hour mark or 
-- half-hour mark instead of its exact time, which is why it usually has the highest amount of collisions.
-- However, at any other time like 6AM and 6:30AM, the count of collisions are in the 100s, which is far from the 1000 range.
-- I will conclude that if accidents aren't recorded timely and the officer doesn't know when the accident occured, the SDPD will often write 12:00AM or 12:01AM. 


-- What times did the most collisions occur in 2023 (LESS 12:00AM AND 12:01AM)?

SELECT
    FORMAT(date_time, 'hh') AS hour_of_collision,
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END AS half_hour,
	FORMAT(date_time, 'tt') AS am_pm,
    COUNT(DISTINCT report_id) AS collision_count
FROM
    collisions
WHERE FORMAT(date_time, 'hh') <> 0 AND DATEPART(MINUTE, date_time) NOT IN (0,1) AND YEAR(DATE_TIME) = 2023
GROUP BY
    FORMAT(date_time, 'hh'),
    CASE
        WHEN DATEPART(MINUTE, date_time) < 30 THEN '00'
        ELSE '30'
    END,
	FORMAT(date_time, 'tt')
ORDER BY
    collision_count DESC;
-- 3:30pm, 4:30pm, 5:30pm. Probably due to rush-hour.

------------------------------------------------------------------------------------------------------------------------------------------------------

-- How many collisions were there in 2022 compared to 2023?
SELECT DATEPART(year, date_time) as year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE DATEPART(year, date_time) >=2022
GROUP BY DATEPART(year, date_time)
-- It seems the number of collisions has decreased. If the data was analyzed post 2023, I would hypothesize the number of collisions would still
-- be less than 2022.

------------------------------------------------------------------------------------------------------------------------------------------------------

-- What months historically have the most accidents?
SELECT DATEPART(month, date_time) as month, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE DATEPART(year, date_time) > 2021
GROUP BY  DATEPART(month, date_time)
ORDER BY CollisionCount DESC
-- Hard to tell with pandemic...
-- Before pandemic, it was september and october
-- After peak pandemic (2022-), it was march, august, and october
-- I will qualify my data to only look at 2022- to avoid the pandemic data

------------------------------------------------------------------------------------------------------------------------------------------------------


-- How many people were unharmed, injured, or died in 2022 and 2023?
SELECT DATEPART(year, date_time) as year, person_condition, COUNT(person_condition) AS Countofperson_condition
FROM collisions
WHERE DATEPART(year, date_time) >= 2022
GROUP BY DATEPART(year, date_time), person_condition
ORDER BY DATEPART(year, date_time), COUNT(person_condition) desc
-- Again, it's kind of difficult to tell with a month and half of data not available. This also doesn't seem too important
-- to the SDPD so I won't continue analyzing this

------------------------------------------------------------------------------------------------------------------------------------------------------


-- What is the primary reason for traffic collisons (2022-2023)?
SELECT charge_desc, DATEPART(year,date_time) AS Year, COUNT(DISTINCT report_id) AS CollisionCount
FROM collisions
WHERE DATEPART(year, date_time) >= 2022
GROUP BY charge_desc, DATEPART(year,date_time)
ORDER BY COUNT(DISTINCT report_id) DESC
-- It's unsafe turns AND/OR no turn singal violations (by a wide margin), miscellaneous hazard violations, and speeding violations. 


------------------------------------------------------------------------------------------------------------------------------------------------------


-- In 2023, where are these unsafe turns happening? Which neighborhood? More specifically, which area?
-- Which neighborhood?
SELECT neighborhood, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
WHERE YEAR(date_time) = 2023
GROUP BY neighborhood
ORDER by CollisionCount DESC
-- Pacific Beach, Mira Mesa, Kearny Mesa, La Jolla, Midway District, North Park, East Village

------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which primary address/intersection?
SELECT primary_address, intersecting_address, neighborhood, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
WHERE YEAR(date_time) = 2023
GROUP BY primary_address, intersecting_address, neighborhood
ORDER by CollisionCount DESC
-- Mira Mesa Boulevard, Mirarmar Road, Garnet Avenue, Sports Arena Boulevard, University Avenue


-- To get a clue of where each of the top 5 collisions occur, where are the most common intersecting addresses?
SELECT primary_address, intersecting_address, neighborhood, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
WHERE YEAR(date_time) = 2023 AND primary_address = 'University Avenue'
GROUP BY primary_address, intersecting_address, neighborhood
ORDER by CollisionCount DESC
/*
Mira Mesa Boulevard - Westview Parkway, Vista Sorrento Parkway
Mirarmar Road - Nobel Drive
Garnet Avenue - Olney St., Garnet Ave., Mission BLVD
Sports Arena Boulevard - West Mission Bay Drive
University Avenue - in Hilcrest & North Park
*/

------------------------------------------------------------------------------------------------------------------------------------------------------


-- What are the causes of these collisions for these areas?
SELECT primary_address, intersecting_address, neighborhood, charge_desc, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
WHERE YEAR(date_time) = 2023
GROUP BY primary_address, intersecting_address, neighborhood, charge_desc
ORDER by CollisionCount DESC
-- Most are caused by miscellanous hazardous violations, unsafe turns, and speeding

------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the primary cause for each address?

-- I need to create a CTE to rank all of the charges for each distinct primary addresses.
-- Once they are ranked, I can query off my CTE to find the #1 charge for each

WITH RankedCollisions AS (
  SELECT
    primary_address,
    intersecting_address,
    neighborhood,
    charge_desc,
    COUNT(DISTINCT report_id) AS CollisionCount,
    ROW_NUMBER() OVER (PARTITION BY primary_address ORDER BY COUNT(DISTINCT report_id) DESC) AS Rank
  FROM
    collisions
    INNER JOIN beatcode ON collisions.police_beat = beatcode.beat
  WHERE
    YEAR(date_time) = 2023
  GROUP BY
    primary_address,
    intersecting_address,
    neighborhood,
    charge_desc
)
SELECT
  primary_address,
  intersecting_address,
  neighborhood,
  charge_desc,
  CollisionCount
FROM
  RankedCollisions
WHERE
  Rank = 1
ORDER BY
  CollisionCount DESC;


------------------------------------------------------------------------------------------------------------------------------------------------------


-- From 2022, which primary addresses are experiencing more collisions than before?

-- I want to count all of the collisions by primary_address in 2022 and 2023 and compare them.
-- I want to create another column that outputs either increase or decrease to filter through quickly
-- Let's use a CTE to count both the collisions in 2022 and 2023 and query the CTE to find an increase or decrease
WITH CollisionsCounts AS (
    SELECT 
        primary_address, 
        intersecting_address, 
        neighborhood,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2022 THEN report_id END) AS CollisionCount2022,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2023 THEN report_id END) AS CollisionCount2023
    FROM 
        collisions AS c
    INNER JOIN 
        beatcode ON c.police_beat = beatcode.beat
    WHERE 
        YEAR(date_time) IN (2022, 2023)
    GROUP BY 
        primary_address, intersecting_address, neighborhood
)

SELECT 
    primary_address, 
    intersecting_address, 
    neighborhood,
    CollisionCount2022,
    CollisionCount2023,
    CASE 
        WHEN (CollisionCount2022 - CollisionCount2023) < 0 THEN 'INCREASE'
        WHEN (CollisionCount2022 - CollisionCount2023) > 0 THEN 'DECREASE'
        ELSE 'NONE'
    END AS Increase_decrease,
	abs(CollisionCount2022 - CollisionCount2023) AS Difference
FROM 
    CollisionsCounts
ORDER BY 
    CollisionCount2022 DESC, CollisionCount2023 DESC;
-- It looks like Mira Mesa Boulevard, Miramar Road, University Avenue, and others are increasing.

------------------------------------------------------------------------------------------------------------------------------------------------------


-- From 2022, which neighborhoods are experiencing more collisions than before?
WITH CollisionsCounts AS (
    SELECT 
        neighborhood,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2022 THEN report_id END) AS CollisionCount2022,
        COUNT(DISTINCT CASE WHEN YEAR(date_time) = 2023 THEN report_id END) AS CollisionCount2023
    FROM 
        collisions AS c
    INNER JOIN 
        beatcode ON c.police_beat = beatcode.beat
    WHERE 
        YEAR(date_time) IN (2022, 2023)
    GROUP BY 
        neighborhood
)

SELECT 
    neighborhood,
    CollisionCount2022,
    CollisionCount2023,
    CASE 
        WHEN (CollisionCount2022 - CollisionCount2023) < 0 THEN 'INCREASE'
        WHEN (CollisionCount2022 - CollisionCount2023) > 0 THEN 'DECREASE'
        ELSE 'NONE'
    END AS Increase_decrease,
	abs(CollisionCount2022 - CollisionCount2023) AS Difference
FROM 
    CollisionsCounts
ORDER BY 
    CollisionCount2022 DESC, CollisionCount2023 DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- What % were MISC. charges for collisions?
SELECT charge_desc, COUNT(charge_desc) AS CollisionCount, CAST(COUNT(charge_desc) AS DECIMAL)/CAST(SUM(COUNT(charge_desc)) OVER() AS DECIMAL) * 100 AS PercentofTotal
FROM collisions
WHERE YEAR(date_time) = 2023
GROUP BY charge_desc
ORDER BY COUNT(charge_desc) DESC
-- MISC. charges are 11% and the #3 reason for charges. Misc. Hazards need to be investigated more.

------------------------------------------------------------------------------------------------------------------------------------------------------

-- Are the number of drunk driving-related collisions decreasing? 
SELECT DATEPART(year, date_time) AS year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE charge_desc LIKE '%DUI%'
GROUP BY DATEPART(year, date_time)
ORDER BY  DATEPART(year, date_time) DESC
-- There was a spike in driving-driving during the pandemic, but it's starting to go down


---Unsafe lane changes?
SELECT DATEPART(year, date_time) AS year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE charge_desc LIKE 'Turn%'
GROUP BY DATEPART(year, date_time)
ORDER BY  DATEPART(year, date_time) DESC
-- YES!

-- Speeding?
SELECT DATEPART(year, date_time) AS year, COUNT(DISTINCT report_id) as CollisionCount
FROM collisions
WHERE charge_desc LIKE '%Speed%'
GROUP BY DATEPART(year, date_time)
ORDER BY  DATEPART(year, date_time) DESC
-- Yes, but it could be around the same amount if not larger than last year


------------------------------------------------------------------------------------------------------------------------------------------------------

-- What are the reasons for MISC-HAZ?
SELECT charge_desc, COUNT(DISTINCT report_id) AS CollisionCount
FROM collisions
WHERE violation_section = 'MISC-HAZ'
GROUP BY charge_desc
ORDER BY CollisionCount DESC
-- "MISCELLANEOUS HAZARDOUS VIOLATIONS OF THE VEHICLE CODE". What are these and can they be grouped as anything else?
-- The phrase is a catch-all term if the violation doesn't meet anything specific in the vehicle code. In this case
-- I think it would be beneficial to update the vehicle code to group these misc-haz so we can better understand and
-- take action.

