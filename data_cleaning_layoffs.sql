--DATA CLEANING


select * from layoffs_modified;

-- identifying duplicate columns
with cte as
(select * ,row_number() 
over(partition by location,company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_modified)  
SELECT * from cte where row_num>1;


-- creating a new table 
CREATE TABLE `layoffs_modified2` (
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



select * from layoffs_modified2;


-- inserting data into layoffs_modified2
insert layoffs_modified2
select * ,row_number() 
over(partition by location,company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_modified;

-- deleting duplicate rows
delete from layoffs_modified2
where row_num>1;

select * from layoffs_modified2;

-- Standardizing

select * from layoffs_modified2 where industry like 'Crypto%';

update layoffs_modified2
set industry='Crypto' 
where industry like 'Crytpo';

select distinct country from layoffs_modified2 order by 1;


select distinct country from layoffs_modified2 where country like 'United States%';


update  layoffs_modified2 
set country= TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

select `date` from layoffs_modified2;

update layoffs_modified2 set `date`=str_to_date(`date`, '%m/%d/%Y');


alter table layoffs_modified2 
MODIFY column `date` DATE;


select * from layoffs_modified2;

-- treating null and blank values

select * from layoffs_modified2 where industry is null || industry ='';



select t1.industry,t2.industry from layoffs_modified2 t1
join layoffs_modified2 t2
on t1.company=t2.company
where (t1.industry is null or t1.industry ='') and  t2.industry<>'';


update layoffs_modified2 t1
join layoffs_modified2 t2
on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null or t1.industry ='') and  t2.industry<>'';

-- removing unnecessary rows

delete from layoffs_modified2 where percentage_laid_off is null
and total_laid_off is null;

-- removing unnecessary column

alter table layoffs_modified2 
drop column row_num;

select * from layoffs_modified2;
