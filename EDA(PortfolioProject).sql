-- EXPLORATORY DATA ANALYSIS

-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers

SELECT*
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of the company l
SELECT*
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC ;

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT*
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;
 
 
 -- GROUPBY
 -- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
-- now that's just on a single day
 
 -- Companies with the most Total Layoffs
 select company,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
 -- layoffs from the year 2020 to year 2023
SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;

-- by country
select country,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY country
 ORDER BY 2 DESC;
 
  -- by industry
 select industry,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY industry
 ORDER BY 2 DESC;
 
  -- by year
 select YEAR(`DATE`),sum(total_laid_off)
 from layoffs_staging2
 GROUP BY YEAR(`DATE`)
 ORDER BY 1 DESC;
 
 SELECT*
FROM layoffs_staging2;

-- by stage
 select stage,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY stage
 ORDER BY 2 DESC;
 
 -- total laid off
 SELECT sum(total_laid_off)
FROM layoffs_staging2;

-- by each month from 2020 to 2023
SELECT SUBSTRING(`date`,1,7 ) AS `MONTH` , SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7 ) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;


-- Rolling Total of Layoffs Per Month
 WITH Rolling_Total AS
(SELECT SUBSTRING(`date`,1,7 ) AS `MONTH` , SUM(TOTAL_LAID_OFF) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7 ) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`,total_off,SUM(total_off) OVER( ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


select company,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
 select company,YEAR(`date`),sum(total_laid_off)
 from layoffs_staging2
 GROUP BY company,YEAR(`date`)
 ORDER BY 3 DESC
;
 
-- Now let's look at that per year
 WITH company_year (COMPANY,`YEAR`,TOTAL_LAID_OFFS) AS
 (select company,YEAR(`date`),sum(total_laid_off)
 from layoffs_staging2
 GROUP BY company,YEAR(`date`))
 , company_rank_year AS
 (SELECT *, DENSE_RANK () OVER(PARTITION BY `YEAR` ORDER BY TOTAL_LAID_OFFS DESC) AS RANK_NUM
 FROM company_year
 WHERE `YEAR` IS NOT NULL)
 SELECT *
 FROM  company_rank_year
 WHERE RANK_NUM <= 5
;
 