select * from public.coviddeaths
order by location,date ;

--Finding out total deaths vs total cases
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from public.coviddeaths
order by location,date;

--Finding out total cases vs population
select location,date,population,total_cases,(total_cases/population)*100 as case_percentage
from public.coviddeaths
--where location= 'United States'
order by location,date;

--looking at countries with highest infection rate compared to population
with cte as
(select location,population,max(total_cases) as highestInfection_count,max((total_cases/population))*100 as percentage_infectedPopulation
from public.coviddeaths
where continent is not null
group by location,population
order by percentage_infectedPopulation desc)
select * from cte
where percentage_infectedPopulation is not null;

--looking at countries with highest death rate compared to population
with cte as
(select location,population,max(total_deaths) as highestDeath_count,max((total_deaths/population))*100 as highest_death_rate
from public.coviddeaths
where continent is not null
group by location,population
order by highest_death_rate desc)
select * from cte
where highest_death_rate is not null;

--Global numbers
--looking at global death rate by continents
with cte as
(select location, (sum(new_deaths)/sum(new_cases))*100 as Death_percentage
from public.coviddeaths
where continent is null
group by location
order by location )
select * from cte
where Death_percentage is not null;


--Finding out total cases vs population globally for each continent
with cte as
(select location,(sum(total_cases)/sum(population))*100 as case_percentage
from public.coviddeaths
where continent is null
group by location
order by location)
select * 
from cte
where case_percentage is not null;

--looking at continents with highest infection rate compared to population
with cte as
(select location,population,max(total_cases) as highestInfection_count,max((total_cases/population))*100 as percentage_infectedPopulation
from public.coviddeaths
where continent is null
group by location,population
order by percentage_infectedPopulation desc)
select * from cte
where percentage_infectedPopulation is not null;

--looking at continents with highest death rate compared to population
with cte as
(select location,population,max(total_deaths) as highestDeath_count,max((total_deaths/population))*100 as highest_death_rate
from public.coviddeaths
where continent is null
group by location,population
order by highest_death_rate desc)
select * from cte
where highest_death_rate is not null;

--Looking at total population vs total vaccinations
select *
from public.coviddeaths d join public.covidvacc v
on d.location=v.location and d.date=v.date;

--Getting total vaccinations done for each location grouped by date
with cte as
(Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From public.coviddeaths dea
Join public.covidvacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3)
select * from cte
where RollingPeopleVaccinated is not null
