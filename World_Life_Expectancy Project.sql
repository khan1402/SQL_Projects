
# World Life Expectancy Project; The Project is been divided in two parts. No.1 the Data Cleaning and No.2 Exploratory Data Analysis
# Part.1 Data Cleaning 

SELECT * 
FROM world_life_expectancy
;

#Finding and removing duplicate values

SELECT Country, Year, CONCAT(Country,Year), COUNT(CONCAT(Country,Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country,Year)
HAVING COUNT(CONCAT(Country,Year)) >1
;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country,Year),
	ROW_NUMBER() OVER ( PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num 
	FROM world_life_expectancy 
    ) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country,Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS Row_Num 
	FROM world_life_expectancy 
    ) AS Row_table
WHERE Row_Num > 1
)
;

#Finding and removing blank values 

SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

SELECT DISTINCT (Status) 
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT (Country) 
FROM world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

# AFter Data Cleaning, Here is Part.2 of the Project work: World Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM world_life_expectancy
;

#Finding Min & Max & AVG of life expectancy of a countries and by Year
 
SELECT Country, MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy`<> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

# Finding CORRELATIONS

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1) High_GDP_Life_Expentancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),1) Low_GDP_Life_Expentancy 
FROM world_life_expectancy
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI DESC
;

#Finding Rolling total

SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country Order BY Year) AS Rolling_Total
FROM world_life_expectancy
;

#THE END












    