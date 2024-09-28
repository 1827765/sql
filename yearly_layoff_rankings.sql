-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_stable;

SELECT 
    max(total_laid_off), max(percentage_laid_off)
FROM
    layoffs_stable;
    
    select * from layoffs_stable
    where percentage_laid_off = 1;
    
    SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY company;
    
    SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_stable;
    
     SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY industry;

 SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY country;

SELECT 
    *
FROM
    layoffs_stable;
    
     SELECT 
    year(`date`), SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY  year(`date`);

 SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY  stage
order by 2 desc;

   SELECT 
    country, avg(total_laid_off)
FROM
    layoffs_stable
GROUP BY  country;

select substring(`date`, 1,7) as month, sum(total_laid_off) 
from layoffs_stable
where substring(`date`, 1,7) is not null
group by `month`;


with rolling_total as
(select substring(`date`, 1,7) as month, sum(total_laid_off) as total_letgo
from layoffs_stable
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc )

select `month`, total_letgo, sum(total_letgo)  over(order by `month`) as rolling_total
from rolling_total;

SELECT 
    company,year(`date`), SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY company, year(`date`)
order by 3 desc;

with company_year (industry, `year`,total_laid_off) as 
(
SELECT 
    industry,year(`date`), SUM(total_laid_off)
FROM
    layoffs_stable
GROUP BY industry, year(`date`) 
), 
 company_year_rank as
(
select *, dense_rank() over(partition by `year` order by total_laid_off desc) as rankings
 from company_year
 where `year` is not null
 )
 
 select * from company_year_rank
 where rankings <= 5;




    
    
    
