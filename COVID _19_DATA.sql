SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4


SELECT location, CAST([date] as date) as date, population, total_cases, new_cases, total_deaths, new_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Calculate the Percentage of Deaths over the Cases in all countries

SELECT location, CAST([date] as date) as date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percent_Deaths_over_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



-- Percentage of Cases over the population in all countries

SELECT location, CAST([date] as date) as date, population, total_deaths, (total_deaths/population)*100 as Percent_Cases_over_Population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Top 10 with Highest Infection Rate over Population in the world

SELECT TOP 10
location, population, MAX(total_cases) AS Highest_Infection_Rate, MAX((total_cases/population))*100 as Percent_of_Highest_Infection_Rate
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percent_of_Highest_Infection_Rate desc


-- Top 10 Highest Deaths Cases in the world

SELECT TOP 10
location, MAX(CAST(total_deaths AS INT)) AS Highest_Deaths_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highest_Deaths_Cases desc


-- Top 5 Highest Deaths Cases in Asia region

SELECT TOP 5
location, MAX(CAST(total_deaths AS INT)) AS Highest_Deaths_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
AND continent = 'Asia'
GROUP BY location
ORDER BY Highest_Deaths_Cases desc


-- Total Deaths Cases by continent

SELECT continent, MAX(CAST(total_deaths AS INT)) AS Total_Deaths_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Deaths_Cases desc



-- COVID 19 - World numbers per day

SELECT CAST([date] as date) as date, SUM(new_cases) AS Total_new_cases_each_day, SUM(CAST(new_deaths AS INT)) AS Total_deaths_each_day, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Deaths_Percent_Over_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1


-- COVID 19 - Total  World numbers

SELECT SUM(new_cases) AS Total_new_cases_each_day, SUM(CAST(new_deaths AS INT)) AS Total_deaths_each_day, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Deaths_Percent_Over_Cases
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1


-- 10 countries with the highest vaccinations

SELECT 	DISTINCT TOP 10 d.location, 
		SUM(CAST(v.new_vaccinations AS BIGINT)) OVER (Partition by d.location) as Total_num_vaccinations
FROM coviddeaths d
JOIN covidvaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2 DESC


-- Vaccinations situation in Vietnam per day

CREATE TABLE Vietnam_Vaccinations_Info
(
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
Total_num_vaccinations numeric
)
INSERT INTO Vietnam_Vaccinations_Info
SELECT 	d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS BIGINT)) OVER (Partition by d.location ORDER BY d.location, d.date) as Total_num_vaccinations
FROM coviddeaths d
JOIN covidvaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND d.location = 'Vietnam'
ORDER BY 2

SELECT *
FROM Vietnam_Vaccinations_Info


-- CREATING VIEW TO STORE DATA FOR DATA VISUALIZATION

CREATE VIEW Vietnam_Vaccinations_Situation AS
SELECT 	d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS BIGINT)) OVER (Partition by d.location ORDER BY d.location, d.date) as Total_num_vaccinations
FROM coviddeaths d
JOIN covidvaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND d.location = 'Vietnam'
