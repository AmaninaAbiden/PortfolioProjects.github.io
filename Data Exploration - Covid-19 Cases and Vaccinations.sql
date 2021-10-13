
Select *
From CovidCases..CovidDeaths
order by 2,3,4

Select *
From CovidCases..CovidVaccinations
order by 2,3,4

--Select data to be used

Select location, date, total_cases, new_cases, total_deaths, population
From CovidCases..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths
-- Likelihood of dying from Covid-19 (if contracted) in Malaysia
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From CovidCases..CovidDeaths
Where location='Malaysia' and total_cases is not null
Order by 1,2

-- Total Cases vs Population (Malaysia)
-- Shows the percentage of people contracted Covid-19 in Malaysia
Select location, date, population, total_cases, (total_cases/population)*100 as infected_percentage
From CovidCases..CovidDeaths
Where location='Malaysia' and total_cases is not null
Order by 1,2

-- Total Cases vs Population (All countries)
Select location, date, population, total_cases, (total_cases/population)*100 as infected_percentage
From CovidCases..CovidDeaths
Where total_cases is not null
Order by 1,2

--Countries with Highest Infection Percentage
Select location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as population_infected_percentage
From CovidCases..CovidDeaths
Where total_cases is not null
Group by location, population
Order by population_infected_percentage desc

--Countries with Highest Death Count
Select location, population, MAX(cast(total_deaths as int)) as total_death_count
From CovidCases..CovidDeaths
--Where continent is not null
Group by location, population
Order by total_death_count desc

--Breakdown of Total Cases and New Deaths per Population, by Continents
Select location as continent, population, MAX(total_cases) as total_cases, MAX(cast(total_deaths as int)) as total_death_count
From CovidCases..CovidDeaths
Where continent is null
Group by location, population
Order by total_death_count desc

--Global Daily Total Cases and Total Deaths
Select date, SUM(total_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths
From CovidCases..CovidDeaths
Group by date
Order by date desc

--Global Daily New Cases and New Deaths (22/01/2020 - 29/08/2021) 
Select date, SUM(total_cases) as total_cases, SUM(total_cases) - LAG(SUM(total_cases)) 
	OVER (ORDER BY date) as new_cases, SUM(cast(total_deaths as int)) as total_deaths, SUM(cast(total_deaths as int)) - LAG(SUM(cast(total_deaths as int))) 
	OVER (ORDER BY date) as new_deaths
From CovidCases..CovidDeaths
Where continent is not null and total_cases is not null
Group by date
Order by date desc

--Global Death % per Confirmed Cases
Select MAX(cast(total_deaths as int))/MAX(total_cases)*100 as death_percentage
From CovidCases..CovidDeaths
Where continent is not null and total_cases is not null

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Total Population vs Vaccinations
---------------------------------------------------------------------------------------------------------------------------------------------------

Select *
From CovidCases..CovidDeaths

Select * From CovidCases..CovidVaccinations
Where location = 'World'
Order by date desc

-- Shows Percentage and no. of of Malaysian Population that has received at least one dose of Covid Vaccine
Select d.location, d.date, d.population, (v.people_vaccinated / d.population * 100) as percentage_of_vaccinated , v.people_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'Malaysia'
Order by date desc

-- Shows Percentage and no. of of Malaysian Population that has been fully vaccinated
Select d.location, d.date, (v.people_fully_vaccinated / d.population * 100) as percentage_of_vaccinated_one_dose, people_fully_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'Malaysia'
Order by date desc

-- Shows Percentage and no. of of Malaysian Population that has received exactly one dose of Covid Vaccine
Select d.location, d.date, ((CAST(v.people_vaccinated as int) - CAST(v.people_fully_vaccinated as int)) / d.population * 100) as percentage_of_vaccinated_one_dose, 
(CAST(v.people_vaccinated as int) - CAST(v.people_fully_vaccinated as int)) as people_vaccinated_one_dose
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'Malaysia'
Order by date desc

-- Shows Percentage and no. of of Malaysian Population that has not been vaccinated
Select d.location, d.date, ((d.population - CAST(v.people_vaccinated as int)) / d.population * 100) as percentage_of_not_vaccinated, 
(d.population - CAST(v.people_vaccinated as int)) as people_not_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'Malaysia'
Order by date desc

-- Shows global population that has received at least one dose of Covid Vaccine
Select d.location, d.date, d.population, (v.people_vaccinated / d.population * 100) as percentage_of_vaccinated , v.people_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'World'
Order by date desc

-- Shows global population that has been fully vaccinated
Select d.location, d.date, d.population as total_world_population, v.people_fully_vaccinated as total_population_fully_vaccinated,
(v.people_fully_vaccinated / d.population) * 100 as percentage_fully_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location
	and d.date = v.date
Where d.location = 'World'
Order by date desc

-- Shows Percentage and no. of of Malaysian Population that has received exactly one dose of Covid Vaccine
Select d.location, d.date, d.population as total_world_population, ((CAST(v.people_vaccinated as bigint) - CAST(v.people_fully_vaccinated as int)) / d.population * 100) as percentage_of_vaccinated_one_dose, 
(CAST(v.people_vaccinated as bigint) - CAST(v.people_fully_vaccinated as int)) as people_vaccinated_one_dose
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'World'
Order by date desc

-- Shows global population that has not been vaccinated
Select d.location, d.date, ((d.population - CAST(v.people_vaccinated as bigint)) / d.population * 100) as percentage_of_not_vaccinated, 
(d.population - CAST(v.people_vaccinated as bigint)) as people_not_vaccinated
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
On d.location = v.location 
	and d.date = v.date
Where d.location = 'World'
Order by date desc

-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select d.continent, d.location, d.date, d.population, v.total_vaccinations, v.new_vaccinations,
AVG(CAST(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.Location, d.Date) as Average_daily_new_vacc
From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
	On d.location = v.location
		and d.date = v.date
Where d.continent is not null 
Order by d.continent, d.location, d.date desc

-- Using CTE to perform Calculation on Partition By in previous query
With GlobalVac (Continent, Location, Date, Population, Total_Vaccinations_to_date, New_Vaccinations, Average_daily_new_vacc)
AS
(
	Select d.continent, d.location, d.date, d.population, v.total_vaccinations, v.new_vaccinations,
	AVG(CAST(v.new_vaccinations as int)) OVER (Partition by d.Location ORDER BY d.Location, d.Date) as Average_daily_new_vacc
	From CovidCases..CovidDeaths d JOIN CovidCases..CovidVaccinations v
	On d.location = v.location
		and d.date = v.date
	Where d.continent is not null 
)
Select *, (
	CASE
		When New_Vaccinations is not null AND Average_daily_new_vacc is not null AND New_Vaccinations != 0 
		AND Average_daily_new_vacc != 0 THEN (CAST(New_Vaccinations as float)/CAST(Average_daily_new_vacc as float)) * 100
		When New_Vaccinations is null THEN 0
		When Average_daily_new_vacc is null THEN 0
	END
	) as Percentage_from_average
From GlobalVac
Order by Continent, Location, Date desc



