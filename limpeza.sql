create database df_demissoes;

-- copiando a tabela demissoes e seus valores
CREATE TABLE demissoes1
LIKE demissoes;

INSERT demissoes1
SELECT * FROM demissoes;

-- valores nulos
SELECT * FROM demissoes1;
WITH duplicados AS (
SELECT *, ROW_NUMBER()
 OVER(PARTITION BY
    company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS rows_num  
FROM demissoes1
)
SELECT COUNT(*) as Qtd_nulos
FROM duplicados
where rows_num > 1; -- há 5 valores nulos

SELECT 
 *  
FROM demissoes1
WHERE company = 'Casper';
 
 -- para salvar a minha coluna row_number vou criar a tabela demissoes2
CREATE TABLE `demissoes2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `rows_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT demissoes2
SELECT *, ROW_NUMBER()
 OVER(PARTITION BY
    company, location, industry, total_laid_off,
 percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS rows_num  
FROM demissoes1;
 
 -- agora posso remover as linhas duplas
 SELECT 
    *
 FROM demissoes2
 where rows_number > 1;
 
 DELETE
 FROM demissoes2
 WHERE rows_number > 1;
 
 -- contagem de valores brancos
SELECT 
    COUNT(CASE WHEN company = '' THEN 1 END) AS company,
    COUNT(CASE WHEN location = '' THEN 1 END) AS location,
    COUNT(CASE WHEN industry = '' THEN 1 END) AS industry,
    COUNT(CASE WHEN total_laid_off = '' THEN 1 END) AS total_laid_off,
    COUNT(CASE WHEN percentage_laid_off = '' THEN 1 END) AS percentage_laid_off,
    COUNT(CASE WHEN `date` = '' THEN 1 END) AS `date`,
    COUNT(CASE WHEN stage = '' THEN 1 END) AS stage,
    COUNT(CASE WHEN country = '' THEN 1 END) AS country    
FROM demissoes2;

 -- padronizando coluna industry
 SELECT 
   *
 FROM demissoes2
 WHERE industry IS NULL 
 OR industry = '';
 
 UPDATE demissoes2
 SET industry = NULL
 WHERE industry = '';
 
 -- padronizando a coluna industry
SELECT 
DISTINCT industry 
FROM demissoes2;

SELECT 
industry 
FROM demissoes2
WHERE industry LIKE('Crypto%');

UPDATE demissoes2
SET industry = 'Crypto'
WHERE industry LIKE('Crypto%');

-- padronizando country 
SELECT 
DISTINCT country
FROM demissoes2;

UPDATE demissoes2
SET country = 'United States'
WHERE country LIKE('%United States%');

-- padronizando date
SELECT 
 STR_TO_DATE(`date`, '%m/%d/%y')
FROM demissoes2;

UPDATE demissoes2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE demissoes2
MODIFY COLUMN `date` date;

 -- valores nulos
 SELECT 
   *
 FROM demissoes2;
 
 -- contagem de nulos
 SELECT 
    COUNT(CASE WHEN company IS NULL THEN 1 END) AS company,
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS location,
    COUNT(CASE WHEN industry IS NULL THEN 1 END) AS industry,
    COUNT(CASE WHEN total_laid_off IS NULL THEN 1 END) AS total_laid_off,
    COUNT(CASE WHEN percentage_laid_off IS NULL THEN 1 END) AS percentage_laid_off,
    COUNT(CASE WHEN `date` IS NULL THEN 1 END) AS `date`,
    COUNT(CASE WHEN stage IS NULL THEN 1 END) AS stage,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country,
    COUNT(CASE WHEN funds_raised_millions IS NULL THEN 1 END) AS funds_raised_millions
FROM demissoes2;

 SELECT 
   *
 FROM demissoes2
 WHERE industry IS NULL;
 
 SELECT 
   d1.industry d1,
   d2.industry d2
 FROM demissoes2 d1
 JOIN demissoes2 d2
 ON d1.company = d2.company
 WHERE d1.industry IS NULL
 AND d2.industry IS NOT NULL;
 
UPDATE demissoes2 d1 JOIN demissoes2 d2
ON d1.company = d2.company
SET d1.industry = d2.industry
WHERE d1.industry IS NULL
AND d2.industry IS NOT NULL;

-- sobrou uma linhas, vamos deletar
DELETE 
FROM demissoes2 
WHERE company = 'Bally''s Interactive';

-- deletando linhas inúteis
DELETE
FROM demissoes2
WHERE total_laid_off IS NULL
OR percentage_laid_off IS NULL;

DELETE
FROM demissoes2
WHERE `date` IS NULL ;

DELETE
FROM demissoes2
WHERE stage IS NULL;

DELETE
FROM demissoes2
WHERE funds_raised_millions IS NULL;

#dropando coluna inútil 
ALTER TABLE demissoes2
DROP COLUMN rows_number;


