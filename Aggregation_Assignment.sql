use world;

##  Question 1 : Count how many cities are there in each country?

select Country_Name,count(City_Name) as Total_Cities from city ci
join country co
on ci.CountryCode=co.Country_Code
group by Country_Name;

## Question 2 : Display all continents having more than 30 countries.

select  Continent, count(Country_Name) as total_Countries from country
group by Continent
having total_Countries>30;

## Question 3 : List regions whose total population exceeds 200 million.

select Region, Sum(Country_pop) Total_Population from country
group by Region
having Total_Population>200000000;

## Question 4 : Find the top 5 continents by average GNP per country.

select  Continent, avg(GNP) as Avg_GNP from country
group by Continent
order by Avg_GNP desc
limit 5;

## Question 5 : Find the total number of official languages spoken in each continent.


select Continent,count(Language) as Spoken_Language from countrylanguage cl
join country co
on cl.CountryCode=co.Country_Code
where cl.IsOfficial='T'
group by co.Continent;

## Question 6 : Find the maximum and minimum GNP for each continent.

SELECT Continent,
       MAX(GNP) AS Max_GNP,
       MIN(GNP) AS Min_GNP
FROM country
GROUP BY Continent;

## Question 7 : Find the country with the highest average city population.

select Country_Name,avg(City_Pop) as Avg_city_pop from city ci 
join country co
on ci.CountryCode=co.Country_Code
group by Country_Name
order by Avg_city_pop desc
limit 1;

## Question 8 : List continents where the average city population is greater than 200,000.

select Continent,avg(City_Pop) as Avg_city_pop from city ci 
join country co
on ci.CountryCode=co.Country_Code
group by Continent
having Avg_city_pop>200000;

## Question 9 : Find the total population and average life expectancy for each continent, ordered by average life expectancy descending.

select Continent, sum(Country_Pop) as Total_pop, avg(LifeExpectancy) as Avg_LE from country
group by  Continent
order by Avg_LE desc;

## Question 10 : Find the top 3 continents with the highest average life expectancy, but only include those where the total population is over 200 million.

select Continent, sum(Country_Pop) as Total_pop, avg(LifeExpectancy) as Avg_LE from country
group by  Continent
having Total_pop>200000000
order by Avg_LE desc
limit 3;