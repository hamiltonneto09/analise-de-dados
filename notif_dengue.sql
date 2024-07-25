CREATE DATABASE dengue;

USE dengue;

SELECT * FROM df_dengue;

#Vericar se há valores duplicados.
WITH duplicados as (
SELECT 
  *, ROW_NUMBER() OVER(PARTITION BY
  id, sexo, idade, `data`, regiao, uf, estado, municipio  ) AS ROWS_NUM
FROM df_dengue
)
SELECT 
 *
FROM duplicados
WHERE ROWS_NUM > 1; -- não há valores duplos



-- verificando se há valores brancos ou nulos 
SELECT 
   COUNT(CASE WHEN id = '' THEN 1 END) as id,
   COUNT(CASE WHEN sexo = '' THEN 1 END) as sexo,
   COUNT(CASE WHEN idade = '' THEN 1 END) as idade,
   COUNT(CASE WHEN `data` = '' THEN 1 END) as `data`,
   COUNT(CASE WHEN regiao = '' THEN 1 END) as regiao,
   COUNT(CASE WHEN uf = '' THEN 1 END) as uf,
   COUNT(CASE WHEN estado = '' THEN 1 END) as estado,
   COUNT(CASE WHEN municipio = '' THEN 1 END) as municipio
FROM df_dengue;

-- verificando se há nulos
SELECT 
   COUNT(CASE WHEN sexo IS NULL THEN 1 END) AS sexo,
   COUNT(CASE WHEN idade IS NULL THEN 1 END) AS idade,
   COUNT(CASE WHEN `data` IS NULL THEN 1 END) AS `data`,
   COUNT(CASE WHEN regiao IS NULL THEN 1 END) AS regiao,
   COUNT(CASE WHEN uf IS NULL THEN 1 END) AS uf,
   COUNT(CASE WHEN estado IS NULL THEN 1 END) AS estado,
   COUNT(CASE WHEN municipio IS NULL THEN 1 END) AS municipio
FROM df_dengue;

UPDATE df_dengue
SET `data` = STR_TO_DATE(`data`, '%d/%m/%Y');

ALTER TABLE df_dengue
MODIFY COLUMN `data` date;

-- remover os espaços
UPDATE df_dengue
SET regiao = TRIM(regiao); 

UPDATE df_dengue
SET estado = TRIM(estado); 

UPDATE df_dengue
SET municipio = TRIM(municipio);

SELECT
 *	 
FROM df_dengue;
---------------------------------------------------------------------------------------------------------------------------------------------------
-- KPI
-- Total de casos notificados em um período.
SELECT
  *
FROM df_dengue;

SELECT
 MIN(`data`) as MIN_DATA, 
 MAX(`data`) as MAX_DATA,
 COUNT(id) as quantidade_casos 
FROM df_dengue;

-- Distribuição dos casos por sexo.
SELECT 
  sexo,    
  COUNT(id) as qtd_sexo
FROM df_dengue
GROUP BY sexo;  

-- Distribuição dos casos por faixas etárias.
SELECT 
  idade,    
  COUNT(id) as qtd_idade
FROM df_dengue
GROUP BY idade
ORDER BY idade;


-- Casos por Região
SELECT 
 regiao,    
 COUNT(id) as qnt_regiao
FROM df_dengue
GROUP BY regiao
ORDER BY regiao;

-- Total de casos por estado.
SELECT
 uf, COUNT(*) 
 FROM df_dengue 
 GROUP BY uf
 ORDER BY uf;
 
 
 -- Análise da tendência de notificações ao longo do tempo.
 SELECT
   `data`,
   COUNT(id) as quantidade
 FROM df_dengue
 GROUP BY `data` 
 ORDER BY `data` ASC;


-- Análise da distribuição de casos em diferentes faixas etárias.
SELECT
  CASE
    WHEN idade BETWEEN 0 AND 10 THEN '0-10'
    WHEN idade BETWEEN 11 AND 20 THEN '11-20'
    WHEN idade BETWEEN 21 AND 30 THEN '21-30'
    WHEN idade BETWEEN 31 AND 40 THEN '31-40'
    WHEN idade BETWEEN 41 AND 50 THEN '41-50'
    WHEN idade BETWEEN 51 AND 60 THEN '51-60'
    WHEN idade BETWEEN 61 AND 70 THEN '61-70'
    WHEN idade BETWEEN 71 AND 80 THEN '71-80'
    WHEN idade BETWEEN 81 AND 90 THEN '81-90'
    WHEN idade BETWEEN 91 AND 100 THEN '91-100'
    ELSE '100+'
  END AS faixa_etaria,
  COUNT(id) AS quantidade
FROM df_dengue
GROUP BY faixa_etaria
ORDER BY MIN(idade);



-- Descrição: Total de casos por município.
SELECT
 municipio,
 COUNT(*) as qtd_municipio
FROM df_dengue
GROUP BY municipio
ORDER BY qtd_municipio DESC;


-- Proporção de casos entre homens e mulheres.
SELECT
  SUM(CASE WHEN sexo = 'M' THEN 1 ELSE 0 END) / SUM(CASE WHEN sexo = 'F' THEN 1 ELSE 0 END) AS razao_masculino_feminino
FROM df_dengue;
;

SELECT
 *	 
FROM df_dengue; 



