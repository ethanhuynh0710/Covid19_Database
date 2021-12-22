--SELECT * 
--FROM OmicronData.dbo.Omicron;

--Data for all countries

--Create data for countries 
DROP Table if exists country_data
CREATE TABLE country_data(country VARCHAR(100), population BIGINT, total_cases BIGINT, total_deaths BIGINT, people_fully_vaccinated BIGINT, continent VARCHAR(100));
INSERT INTO country_data
SELECT location, MAX(cast(population as BIGINT)), MAX(cast(total_cases as BIGINT)),  MAX(cast(total_deaths as BIGINT)), MAX(cast(people_fully_vaccinated as BIGINT)), cast(continent as VARCHAR(100))
FROM OmicronData.dbo.CovidData
GROUP by location,continent;

--Display data for countries
SELECT *,cast (total_deaths as float)/total_cases*100 as Mortality_Rate, cast (people_fully_vaccinated as float) / population * 100 as Vaccination_Rate from country_data
ORDER by country;

--Data for countries sorted by vaccination rate
SELECT country, cast (people_fully_vaccinated as float) / population * 100 as Vaccination_Rate, cast (total_deaths as float)/total_cases*100 as Mortality_Rate from country_data
WHERE people_fully_vaccinated is not null
ORDER by vaccination_rate DESC;

--Raw data
--SELECT Location, Total_Cases, New_Cases, Total_Deaths, Population
--FROM OmicronData.dbo.CovidData
--ORDER BY 1,2;


--Data for United States only
SELECT Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
FROM OmicronData.dbo.CovidData
WHERE location = 'UNITED STATES'
ORDER BY 1,2;

--Total Deaths by country sorted in descending order
SELECT *
FROM country_data
ORDER BY total_deaths DESC;

--Average death percentage by country sorted in descending order
SELECT Location, AVG((total_deaths/total_cases)*100) as Mortality_Rate
FROM OmicronData.dbo.CovidData
GROUP by Location
ORDER BY 2 DESC;

--Total cases by country sorted in descending order
SELECT Location, MAX(total_cases) as Total_Infected
FROM OmicronData.dbo.CovidData
GROUP by Location
ORDER BY 2 DESC;

--Average Infection percentage by country sorted in descending order
SELECT Location, AVG((total_cases/population)*100) as Average_Infection_Percentage
FROM OmicronData.dbo.CovidData
GROUP by Location
ORDER BY 2 DESC;

--Data sorted with respect to vaccination rate


--Create data for continents
DROP Table if exists continent_data
CREATE TABLE continent_data (continent VARCHAR(100), population BIGINT, total_cases BIGINT, total_deaths BIGINT, people_fully_vaccinated BIGINT);	
INSERT INTO continent_data
SELECT cast(continent as VARCHAR(100)),SUM(population), SUM(total_cases), SUM(total_deaths), SUM(people_fully_vaccinated)
FROM country_data
WHERE continent is not null
GROUP BY continent;

--Display data by continent
SELECT *,cast (total_deaths as float)/total_cases*100 as Mortality_Rate, cast (people_fully_vaccinated as float) / population * 100 as Vaccination_Rate from continent_data;





