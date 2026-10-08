-- SQL Project - Data Cleaning
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT *
FROM world_layoffs.layoffs;

#steps used here to clean the data
#1.REMOVE DUPLICATES
#2.STANDARDIZE THE DATA AND FIX ERRORS
#3.REMOVE NULLS OR POPULATE THE MISSING VALUES
#4.REMOVE ANY COLUMN OR ROW IF NECESSARY

-- creating a copy of the original raw data table so that the original data is not disturbed
CREATE TABLE layoffs_staging
LIKE world_layoffs.layoffs;

SELECT *
FROM world_layoffs.layoffs_staging;

#INSERTING THE DATA OF ORIGINAL TABLE
INSERT INTO layoffs_staging
SELECT*
FROM world_layoffs.layoffs;

SELECT *
FROM world_layoffs.layoffs_staging;


-- 1. Remove Duplicates

-- identifying duplicates(below here is the command to check unique values)
SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`DATE`,stage,country,funds_raised_millions)as row_num
FROM world_layoffs.layoffs_staging;

#creating cte to view duplicates
WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`DATE`,stage,country,funds_raised_millions)as row_num
FROM world_layoffs.layoffs_staging
)
SELECT*
FROM duplicate_cte 
WHERE row_num>1;

-- checking one of the duplicates we got from the above command
SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'casper';
#
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` bigint DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`DATE`,stage,country,funds_raised_millions)as row_num
FROM world_layoffs.layoffs_staging;

-- filtering(viewing duplicates)
SELECT *
FROM layoffs_staging2
WHERE row_num>1;


-- deleting duplicates 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2
WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;


-- data without duplicate values
select *
from layoffs_staging2;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- 2.STANDARDIZING DATA
-- standardizing data means finding issues in your data and fixing it



select *
from layoffs_staging2;

-- removing white spaces from the company column
select trim(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);


select  DISTINCT industry
from layoffs_staging2
ORDER BY 1;

select  *
from layoffs_staging2
WHERE industry LIKE 'crypto%';

-- making cypto currency as crypto
UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry like 'crypto%';



SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- or --
SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';


-- managing date column
select `date`
from layoffs_staging2;


-- formatting dash format rows to dash format date
SELECT `date`,
       STR_TO_DATE(`date`, '%m-%d-%Y')
FROM layoffs_staging2;


-- formatting slash format rows to dash format date
SELECT `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;


-- a correct date format
SELECT `date`,
       CASE 
         WHEN `date` LIKE '%/%' THEN STR_TO_DATE(`date`, '%m/%d/%Y')
         WHEN `date` LIKE '%-%' THEN STR_TO_DATE(`date`, '%m-%d-%Y')
       END AS formatted_date
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = CASE 
                  WHEN `date` LIKE '%/%' THEN STR_TO_DATE(`date`, '%m/%d/%Y')
				  WHEN `date` LIKE '%-%' THEN STR_TO_DATE(`date`, '%m-%d-%Y')
             END;

-- changing date column's type from text to date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

select*
from layoffs_staging2;

-- 3.REMOVING/POPULATING NULL AND BLANK VALUES

--
select*
from layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- checking similar row to populate data 
select*
from layoffs_staging2
where company = 'airbnb';


-- joining  to view industry and populate-----
SELECT t1.company,t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

update layoffs_staging2
set industry = null
where industry = '';

select*
from layoffs_staging2
where company = 'airbnb';


-- 4.REMOVING COLUMNS OR ROWS IF NECESSARY
DELETE 
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

SELECT*
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;


-- THE FINAL CLEANED DATA
SELECT*
FROM layoffs_staging2;