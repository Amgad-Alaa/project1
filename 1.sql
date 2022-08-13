select location,date,total_cases,new_cases,total_deaths,population
from Project1..CovidDeaths
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as detahpercentage
from Project1..CovidDeaths
where location like '%egypt%' and continent is not null
order by 1,2

select location,date,population,total_cases,(total_cases/population)*100 as perecntofpopinfected
from Project1..CovidDeaths
--where location like '%egypt%'
where continent is not null
order by 1,2

select location,population,max(total_cases) as highestinfectioncount,max((total_cases/population))*100 as perecntofpopinfected
from Project1..CovidDeaths
--where location like '%egypt%'
where continent is not null
group by population ,location
order by perecntofpopinfected desc

select location,max(cast(total_deaths as int)) as highestdeath
from Project1..CovidDeaths
where continent is not null
group by  location
order by highestdeath desc

select continent,max(cast(total_deaths as int)) as highestdeath
from Project1..CovidDeaths
where continent is not null
group by  continent
order by highestdeath desc

--Gobal death by day

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage 
from Project1..CovidDeaths
where  continent is not null
group by date
order by 1,2


select * from CovidDeaths
order by 3
------------------------
-- using CTE

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeopleovacinated)
as(
select dea.continent, dea.location,dea.date,population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location ,dea.date) as rollingpeopleovacinated
from CovidDeaths dea
join Covidvaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeopleovacinated/population)*100 from popvsvac

-- using temptable
drop table if exists #perecentpopvacinated
create table #perecentpopvacinated
(continent nvarchar(255),location nvarchar(255),date datetime,population numeric,new_vaccinations numeric,rollingpeopleovacinated numeric)
insert into #perecentpopvacinated
select dea.continent, dea.location,dea.date,population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location ,dea.date) as rollingpeopleovacinated
from CovidDeaths dea
join Covidvaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

select *,(rollingpeopleovacinated/population)*100 from #perecentpopvacinated


--creating view 
create view perecentpopvacinated  as
select dea.continent, dea.location,dea.date,population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location ,dea.date) as rollingpeopleovacinated
from CovidDeaths dea
join Covidvaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3


