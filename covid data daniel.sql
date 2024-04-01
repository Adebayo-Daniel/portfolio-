select*
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
order by 3,4

select*
from [DANIEL TUTORIAL].[dbo].[Covid Vaccination]
order by 3,4

-- This is the data we are Useing

select iso_code, continent, location, date,total_cases, new_cases,total_deaths, population
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where total_cases is not null
order by  3,4

-- Total_cases VS Total_deaths 

select location, date, total_deaths, total_cases, (total_deaths/(cast (total_cases as float )))*100 
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where total_cases is not null
order by 1,2

select location, date,  total_cases, total_deaths,(total_deaths/(convert (float ,total_cases )))*100 
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where total_cases is not null
order by 1,2

--Total cases vs Total Deaths In Nigeria

select location, date,  total_cases, total_deaths,(total_deaths/(convert (float ,total_cases )))*100 as percentagedeathsNIG
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where total_cases is not null
and location like '%Nigeria%'
order by 1,2

-- Total Cases Vs Total Deaths in the U S

select location, date,total_cases,total_deaths, (total_deaths/convert(float,total_cases))* 100 as percentageDeathsUS
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where location like '%state%'
and total_cases is not null
order by 1,2

select location, date,total_cases,total_deaths,  (total_deaths/convert(float,total_cases))* 100 as percentageDeathsTAJIK
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where location like '%Tajikistan%'
and total_cases is not null
order by 1,2

--Total cases vs Population (percentage of population with covid in NIG)

select location, date,population,total_cases, (total_cases/population)*100 as casespercentage
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where location like '%Nigeria%'
and total_cases is not null
order by 1,2

select location, date,population,total_cases, (total_cases/population)*100 as casespercentage
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
--where location like '%Nigeria%'
where total_cases is not null
order by 1,2

-- countries with the highest infection rate vs their population

select location,population,max(total_cases) as highestinfectedcount,max (convert(float,total_cases/population))*100 as percentagepopulationinfected
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where total_cases is not null
--where location like '%Nigeria%'
Group by location, population
order by 4 desc

--Highest infected countries with covid

select location, population,MAX(total_cases) as Highestinfected, MAX(total_cases/population)*100 as
         percentagepopulationinfected
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
Group by location, population
order by 3 desc

select location, population,MAX(total_cases) as Highestinfected, MAX(total_cases/population)*100 as
         percentagepopulationinfected
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where location like '%Nigeria%'
Group by location, population
order by 3 desc

--Highest DeathsRate location with covid



select location,MAX (convert(int,total_deaths)) as TotalDeathscount
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
--where location like '%Nigeria%'
--and continent is not null
Group by location
order by 2 desc

--checking the brack dawn for continent (totaldeaths)

select location,MAX (convert(int,total_deaths)) as TotalDeathscount
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where continent is null
--and location like '%Nigeria%'
Group by location
order by 2 desc

select continent,MAX (convert(int,total_deaths)) as TotalDeathscount
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
where continent is not null
--and location like '%Nigeria%'
Group by location
order by 2 desc

--world number


select sum(convert(float, total_cases))as total_cases, sum(convert(float,total_deaths))as toatl_deaths, sum(convert (float,total_deaths))/sum(convert (float,total_cases))* 100 as Deathspercentage
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
--where location like '%Nigeria%'
where continent is not null 
group by date
order by 1,2


select sum(convert(float, total_cases))as total_cases, sum(convert(float,total_deaths))as toatl_deaths, sum(convert (float,total_deaths))/sum(convert (float,total_cases))* 100 as Deathspercentage
from [DANIEL TUTORIAL].[dbo].[covidDeaths]
--where location like '%Nigeria%'
where continent is not null 
--group by date
order by 1,2

-------Total population vs Total vaccination

select*
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date

select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location)
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location) as total_vacci
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location
order by dea.location,dea.date) as  cumulative_total_vacci
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--creating cte 

with popvsvacci (continent,location,data,population,new_vaccinations,cumulative_total_vacci)as(
select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location
order by dea.location,dea.date) as  cumulative_total_vacci
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)


--Temp Table
DROP Table if exists #percentagepopulationvaccinated
create Table #percentagepopulationvaccinated
( continent nvarchar  (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
cumulative_total_vaccination numeric)
set ansi_warnings off
insert into #percentagepopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location
order by dea.location,dea.date) as  cumulative_total_vacci
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3


select (cumulative_total_vacci/population)*100
from #percentagepopulationvaccinated



create view daniel as
select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
sum(convert(float,vac.new_vaccinations))over (partition by dea.location
order by dea.location,dea.date) as  cumulative_total_vacci
from [DANIEL TUTORIAL].[dbo].[covidDeaths] as dea
join [DANIEL TUTORIAL].[dbo].[covid Vaccination] as vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3

select*
from #percentagepopulationvaccinated