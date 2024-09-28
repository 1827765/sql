-- Data Cleaning

SELECT 
    *
FROM
    layoffs
ORDER BY country;

-- remove duplicates
-- standarlize the data
-- null values or blank values 
-- remove any colums 

create table layoffs_raw like layoffs;

select * from layoffs_raw;

insert layoffs_raw
select * from layoffs;





with duplicate_cte as 
(select *,
row_number() 
over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_raw
)
select * 
from duplicate_cte 
where row_num > 1;


CREATE TABLE `layoffs_stable` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_stable
where row_num > 1;
insert into layoffs_stable
select *,
row_number() 
over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
 from layoffs_raw;

DELETE FROM layoffs_stable 
WHERE row_num > 1;


select * from layoffs_stable;


-- standardizing data 

SELECT 
    company, TRIM(company)
FROM
    layoffs_stable;

UPDATE layoffs_stable 
SET 
    company = TRIM(company);

SELECT *
FROM
    layoffs_stable
where industry like '%crypto%'
;

UPDATE layoffs_stable 
SET industry = null
where industry = '';

SELECT DISTINCT
    country
FROM
    layoffs_stable
ORDER BY 1;

SELECT 
    *
FROM
    layoffs_stable;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_stable;

alter table layoffs_stable
modify column `date` date;


SELECT 
    *
FROM
    layoffs_stable
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
        
        SELECT 
    *
FROM
    layoffs_stable
    where industry is null or industry = '';
    
    
    SELECT 
    l1.industry, l2.industry
FROM
    layoffs_stable l1
        JOIN
    layoffs_stable l2 ON l1.company = l2.company
WHERE
    (l1.industry IS NULL OR l1.industry = '')
        AND l2.industry IS NOT NULL;
        
        
    UPDATE layoffs_stable l1
        JOIN
    layoffs_stable l2 ON l1.company = l2.company 
SET 
    l1.industry = l2.industry
WHERE
    l1.industry IS NULL
        AND l2.industry IS NOT NULL;
        
        select * 
        from layoffs_stable
        where company like 'bally%';
        
        select *
FROM
    layoffs;
    
    alter table layoffs_stable
    drop column row_num; 











