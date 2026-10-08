-- EXPLORATORY DATA ANALYSIS

SELECT*
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT*
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC ;


SELECT*
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC ;
 
 
 
 select company,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
 
 SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;


select country,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY country
 ORDER BY 2 DESC;
 
  --
  select industry,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY industry
 ORDER BY 2 DESC;
 
  --
   select YEAR(`DATE`),sum(total_laid_off)
 from layoffs_staging2
 GROUP BY YEAR(`DATE`)
 ORDER BY 1 DESC;
 
 SELECT*
FROM layoffs_staging2;


select	 stage,sum(total_laid_off)
 from layoffs_staging2
 GROUP BY stage
 ORDER BY 2 DESC;
 
 
 SELECT sum(total_laid_off)
FROM layoffs_staging2;

SELECT SUBSTRING(`date`,1,7 ) AS `MONTH` , SUM(TOTAL_LAID_OFF)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7 ) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

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
 