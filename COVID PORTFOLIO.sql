
-- looking at Total cases vs total deaths
SELECT location,date,total_cases,total_deaths,new_cases,new_deaths,(total_deaths/total_cases)*100 as deathpercentage
FROM covid.covid_deaths
where location like '%india%'
order by 1,2;

-- show what % of population got covid 
SELECT location,date,total_cases,population ,(total_cases/population)*100 as percentage_case
FROM covid.covid_deaths
where location like '%india%'
order by 1,2;

-- country with highest infection rate
select location,population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100 as highest_infection_rate
FROM covid.covid_deaths
where continent is not null
group by 1,2
order by 4 desc;

-- Countries with Highest Death Count per Population
SELECT 
    location,
    population,
    MAX(total_deaths) AS highestdeathcount,
    MAX(total_deaths / population) * 100 AS highest_infection_rate
FROM
    covid.covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY 1 , 2
ORDER BY 3 DESC;

-- showing continent with the highest death count per population
select continent, max(total_deaths) as highestdeathcount
FROM covid.covid_deaths
where continent is not null
group by 1
order by 2 desc;

-- Global numbers
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
 SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From covid.covid_deaths
where continent is not null  
Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
with temp_vacc as(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location,cd.date) as Rollingpeoplevaccinated
from covid.covid_deaths cd
join covid.covid_vaccinations cv
on  cd.location=cv.location and cd.date=cv.date
where  cd.continent is not null
order by 1,2,3)
select continent,location,date, (rollingpeoplevaccinated / population )*100 as percentage_people_vacc
from temp_vacc;

-- Creating View to store data for later visualizations

create View PercentPopulationVaccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location,cd.date) as Rollingpeoplevaccinated
from covid.covid_deaths cd
join covid.covid_vaccinations cv
on  cd.location=cv.location and cd.date=cv.date
where  cd.continent is not null
order by 1,2,3;

 