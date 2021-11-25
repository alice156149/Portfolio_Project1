# Portfolio_Project1
--Brows the whole data in covid_vaccinations table
SELECT *
FROM sql-practice-10252021.covid_deaths.covid_vaccinations
WHERE continent IS NOT NULL
ORDER BY location, date


--Brows the whole data in covid_deaths table
SELECT *
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date


--Select Data that going to be using
SELECT  location, date, total_cases, new_cases, total_deaths, population
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL


-- Looking at the total cases VS total deaths
SELECT  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage 
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date


-- Looking at the Total cases VS Population (in Vietnam)
-- Show what percentage of population got Covid
SELECT location, date, total_cases, population, total_deaths, (total_cases/population)*100 as Percentage_of_population_got_covid
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
AND location like "Viet%"

-- what country has the Highest Infection Rate compare to its population
SELECT location, population, MAX(total_cases) AS highest_infection_count,MAX((total_cases/population))*100 as Percentage_of_population_got_covid
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Percentage_of_population_got_covid desc


-- Showing countries with Highest Death Count per population
SELECT location, MAX(cast(total_deaths as int64)) as Total_deaths_count
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_deaths_count desc


-- BREAK THINGS DOWN BY CONTINENTS
--SHowing the continent with the highest deaths count
SELECT continent, MAX(cast(total_deaths as int64)) as Total_deaths_count
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_deaths_count desc


-- Global numbers (with timeline)
SELECT date, SUM(new_cases) as total_new_cases,SUM(CAST(new_deaths as int64)) as total_new_deaths, SUM(CAST(new_deaths as int64))/SUM(new_cases)*100 as Death_percentage
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date


-- Global numbers (total all until now)
SELECT SUM(new_cases) as total_new_cases,SUM(CAST(new_deaths as int64)) as total_new_deaths, SUM(CAST(new_deaths as int64))/SUM(new_cases)*100 as Death_percentage
FROM sql-practice-10252021.covid_deaths.covid_deaths
WHERE continent IS NOT NULL

--Joining 2 tables
SELECT *
FROM sql-practice-10252021.covid_deaths.covid_deaths as dea
JOIN sql-practice-10252021.covid_deaths.covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date

--Total population Vs vaccinations
--CREATE TABLE with necessary data infomation
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int64)) over (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Rolling_people_vaccinated
FROM sql-practice-10252021.covid_deaths.covid_deaths as dea
JOIN sql-practice-10252021.covid_deaths.covid_vaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY continent, location, date
