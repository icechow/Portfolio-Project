select* from PortfolioProjects..CovidDeaths
order by 3,4

--select* from PortfolioProjects..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 1,2

--Looking at Total cases vs total deaths
--shows likelihood of dying if you contact covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at total cases vs population
--show what percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProjects..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at Countries with highest infection rate compare to population
select Location, population, Max(total_cases) as HighestInfestionCount,  Max((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProjects..CovidDeaths
group by Location, population
order by PercentagePopulationInfected desc

--showing Countries with Highest Death Count per population
select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc

--showing contintents with the highest Death Count per population
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--Global numbers
select date, SUM(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as TotalNewDeaths, 
sum(cast(new_deaths as int))/ SUM(new_cases) *100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
group by date
order by 1,2


--Looking as Total opulation vs vaccinations
--Use CTE
with popvsVac(contient, location, date, population, NewVaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100 as PercentageVaccinated
from popvsVac



--TEMP Table
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
population numeric,
NewVaccination numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null


select *, (RollingPeopleVaccinated/population)*100 as PercentageVaccinated
from #PercentPopulationVaccinated



--Creating View to store data 
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated