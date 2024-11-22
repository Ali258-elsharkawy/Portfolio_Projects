--looking at total cases VS total deaths

SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathsPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'egypt'
ORDER BY DeathsPercentage desc


-- SHOWING THE PERCENTAGE OF PEOPLE GOT COVID
SELECT
location,
date,
total_cases,
ROUND((total_cases/population)*100,4) as CasesPercentage
FROM Portfolio_Project..CovidDeaths
ORDER BY CasesPercentage desc


--showing maximum deaths percentage and maximum infection ratio

SELECT
location,
population,
max(total_cases) as MaxCases,
max(ROUND((total_cases/population)*100,4)) as CasesPercentage,
MAX(ROUND((total_deaths/total_cases)*100,4)) as MaxDeathPercentage
FROM Portfolio_Project..CovidDeaths
GROUP BY location,population
ORDER BY MaxDeathPercentage desc


SELECT
dea.continent,
dea.[date],
dea.[location],
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.LOCATION)
FROM Portfolio_Project.dbo.CovidDeaths AS dea
JOIN Portfolio_Project.dbo.CovidVaccinations AS vac
on dea.location = vac.location
WHERE dea.continent IS NOT NULL
and dea.date = vac.date
ORDER BY 3,2

select*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select top 100*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
from Portfolio_Project.dbo.CovidDeaths
order by 1,2

--looking at total cases VS total deaths

SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathsPercentage
FROM Portfolio_Project.dbo.CovidDeaths
WHERE location = 'egypt'
ORDER BY DeathsPercentage desc


-- SHOWING THE PERCENTAGE OF PEOPLE GOT COVID
SELECT
location,
date,
total_cases,
ROUND((total_cases/population)*100,4) as CasesPercentage
FROM Portfolio_Project.dbo.CovidDeaths
ORDER BY CasesPercentage desc

--showing maximum deaths percentage and maximum infection ratio


SELECT
location,
population,
max(total_cases) as MaxCases,
MAX(ROUND((total_cases/population)*100,4)) as PercentPopulationInfected,
MAX(ROUND((total_deaths/total_cases)*100,4)) as MaxDeathPercentage
FROM Portfolio_Project.dbo.CovidDeaths
GROUP BY location,population
ORDER BY PercentPopulationInfected desc

--showing countries with highest death count by population

SELECT
location,
MAX(ROUND((total_deaths/population)*100,4)) as DeathsForPopulation,
MAX(CAST(total_deaths as int)) as HighestDeaths
FROM Portfolio_Project.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location,population
ORDER BY DeathsForPopulation desc
--we added the condition where the continent is not null because when it null that means it refere to the whole continent not certain country

-- showing total number of  acses and deaths from COVID19 and percetnage of deaths due to these cases

SELECT
SUM(new_cases) as OverAllCases,
SUM (CAST(new_deaths AS INT))  AS OverAllDeats,
ROUND((SUM(CAST(new_deaths as INT))/SUM(new_cases)*100),4) as DeathPercentage
from Portfolio_Project.dbo.CovidDeaths

-- Looking at Total population VS Vaccinations

select*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select top 100*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
from Portfolio_Project.dbo.CovidDeaths
order by 1,2

--looking at total cases VS total deaths

SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathsPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'egypt'
ORDER BY DeathsPercentage desc


-- SHOWING THE PERCENTAGE OF PEOPLE GOT COVID
SELECT
location,
date,
total_cases,
ROUND((total_cases/population)*100,4) as CasesPercentage
FROM Portfolio_Project..CovidDeaths
ORDER BY CasesPercentage desc


--showing maximum deaths percentage and maximum infection ratio

SELECT
location,
population,
max(total_cases) as MaxCases,
max(ROUND((total_cases/population)*100,4)) as CasesPercentage,
MAX(ROUND((total_deaths/total_cases)*100,4)) as MaxDeathPercentage
FROM Portfolio_Project..CovidDeaths
GROUP BY location,population
ORDER BY MaxDeathPercentage desc


SELECT
dea.continent,
dea.[date],
dea.[location],
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.LOCATION)
FROM Portfolio_Project.dbo.CovidDeaths AS dea
JOIN Portfolio_Project.dbo.CovidVaccinations AS vac
on dea.location = vac.location
WHERE dea.continent IS NOT NULL
and dea.date = vac.date
ORDER BY 3,2

select*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select top 100*
from Portfolio_Project.dbo.CovidDeaths
order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
from Portfolio_Project.dbo.CovidDeaths
order by 1,2SELECT
location,
date,
total_cases,
ROUND((total_cases/population)*100,4) as CasesPercentage
FROM Portfolio_Project.dbo.CovidDeaths
ORDER BY CasesPercentage desc

--looking at total cases VS total deaths

SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathsPercentage
FROM Portfolio_Project.dbo.CovidDeaths
WHERE location = 'egypt'
ORDER BY DeathsPercentage desc


-- SHOWING THE PERCENTAGE OF PEOPLE GOT COVID

--showing countries with highest death count by population
SELECT
location,
date,
total_cases,
ROUND((total_cases/population)*100,4) as CasesPercentage
FROM Portfolio_Project.dbo.CovidDeaths
ORDER BY CasesPercentage desc

--we added the condition where the continent is not null because when it null that means it refere to the whole continent not certain country

-- showing total number of  acses and deaths from COVID19 and percetnage of deaths due to these cases

SELECT
    SUM(new_cases) as OverAllCases,
    SUM (CAST(new_deaths AS INT))  AS OverAllDeats,
    ROUND((SUM(CAST(new_deaths as INT))/SUM(new_cases)*100),4) as DeathPercentage
    from Portfolio_Project.dbo.CovidDeaths
	where continent is not null

-- Looking at Total population VS Vaccinations

WITH PopVsVac
    (continent,
    date,
    location,
    population,
    New_Vaccinations,
    RollingPeopleVaccinated)
    as
(SELECT
dea.continent,
dea.[date],
dea.[location],
dea.population,
vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY dea.LOCATION ORDER BY dea.location, dea.date) AS RollingUP
FROM Portfolio_Project.dbo.CovidDeaths AS dea
JOIN Portfolio_Project.dbo.CovidVaccinations AS vac
on dea.location = vac.location
WHERE dea.continent IS NOT NULL
and dea.date = vac.date
)

-- you can't run this select statment without running the CTE code, unlike crereating a table in the second solution.
SELECT
    [location],
    date,
    population,
    New_Vaccinations,
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated/population)*100 CurrentVaccinationPercentage
FROM PopVsVac
ORDER BY 1, 2

--we had to use CTE becasuse it is not possiple to operate an operation in column the select statment based on another column created in select statment, the column must be in a table not created in the select statment
-- CTE allow us to create a table to make the result of select statment in a column in a table


-- another way for this instead of using CTE

DROP TABLE IF exists #PercentPopulationVaccinated
-- I added drop if exists to delete this table everytime i run this block of code, this is useful when i want to make changes in the table with the same for it. without dropping it i will get error message that the table I'm rying to create interact with other table with the same name
CREATE TABLE #PercentPopulationVaccinated(
    Continent VARCHAR (250),
    LOCATION NVARCHAR (250),
    Date DATETIME,
    population numeric,
    new_vaccination numeric,
    RollingPeopleVaccinated numeric
);
INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY dea.LOCATION ORDER BY dea.location, dea.date) AS RollingUP
FROM Portfolio_Project.dbo.CovidDeaths AS dea
JOIN Portfolio_Project.dbo.CovidVaccinations AS vac
on dea.location = vac.location
WHERE dea.continent IS NOT NULL
and dea.date = vac.date

SELECT
    [location],
    date,
    population,
    new_vaccination,
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated/population)*100 CurrentVaccinationPercentage
FROM #PercentPopulationVaccinated
WHERE population IS NOT NULL
ORDER BY 1, 2;


DROP VIEW IF EXISTS PercentPopulationVaccinated

GO
CREATE VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.[location],
    dea.[date],
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.LOCATION ORDER BY dea.location, dea.date) AS RollingUP
FROM Portfolio_Project.dbo.CovidDeaths AS dea
JOIN Portfolio_Project.dbo.CovidVaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GO
SELECT *
FROM PercentPopulationVaccinated
