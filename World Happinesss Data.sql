select * from Happ..Hap1
select * from Happ..Hap2

--Country with the highest health life expectancy
select TOP (10) Country, Health_Life_Expectancy, Generosity
from Happ..Hap1
order by 2 Desc
--Singapore has the highest health life expectancy but their generosity is low

--Looking at how generosity of countries compares to Trust_Government corruption and Freedom
select Country, Trust_Government_Corruption, Freedom
from Happ..Hap1
where Trust_Government_Corruption > 0.4
order by Trust_Government_Corruption desc
--Most countries don't trust their government to fight corruption as the highest score is 0.55.
--However, these countries have a relatively high level of freedom

--Comparing countries with highest dystopia residual with health life expectancy
select TOP (10) Country, Dystopia_Residual, Health_Life_Expectancy
from Happ..Hap1
order by 2 Desc
--Most countries with high dystopia residual score have a high life expectancy excep for Mozambique and Nigeria (African countries)

--Looking at the relationship between happiness rank with a country's GDP
select * from Happ..Hap2
select Country, Happiness_Rank, Economy_GDP_per_Capita
from Happ..Hap2
where Happiness_Score in 
(select Happiness_Score from Happ..Hap2
where Happiness_Score >5)
order by 2
--There is a positive correlation between a countries happiness Rank with economy GDP
select top (5) Economy_GDP_per_Capita from Happ..Hap2 --To get top scores for GDP
order by 1 desc

--Comparing happiness_score with a county's GDP
select Distinct(Region), sum(Happiness_Score) as Happiness_Score_Total, sum(Economy_GDP_per_Capita) as GDP_Total
from Happ..Hap2
where Happiness_Score in 
(select Happiness_Score from Happ..Hap2
where Happiness_Score >5)
group by Region
order by 2
--There is an inverse relation between happiness score and GDP scores in various continents

--Comparing generosity in each continent
select max(Hap2.Happiness_Score), Hap2.Region, Hap1.Country--, Hap1.Health_Life_Expectancy, Hap1.Dystopia_Residual, 
from Happ..Hap1
join Happ..Hap2 on Hap1.Country = Hap2.Country
--group by Hap2.Region

--Getting the countries with the maximum happiness score and comparing them with trust governemnt region
select Hap2.Country, Hap2.Happiness_Score, Hap1.Trust_Government_Corruption, Hap2.Region
from Hap2
join Hap1 on Hap2.Country = Hap1.Country
where Hap2.Happiness_Score in
(select max(Happiness_Score) from Hap2
Group by Region)
order by 2 desc

--Creating a Temp Table
drop table if exists #WorldPop
create table #WorldPop
(Country nvarchar(30), 
Happiness_Score float, 
Government_Trust_Corruption float, 
Region nvarchar(100))
insert into #WorldPop
select Hap2.Country, Hap2.Happiness_Score, Hap1.Trust_Government_Corruption, Hap2.Region
from Hap2
join Hap1 on Hap2.Country = Hap1.Country
where Hap2.Happiness_Score in
(select max(Happiness_Score) from Hap2
Group by Region)
order by 2 desc

select * from #WorldPop

