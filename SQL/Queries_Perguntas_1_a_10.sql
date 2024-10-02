-- PERGUNTAS 1 e 2:

SELECT estado, bioma, AVG(avg_numero_dias_sem_chuva) as media_dias_sem_chuva
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
WHERE BIOMA IS NOT NULL
GROUP BY 1, 2
ORDER BY 3 DESC;

-- PERGUNTA 3:

-- ALTER TABLE `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil` RENAME COLUMN date TO date_month;

SELECT EXTRACT(MONTH FROM date_month) as mes_2022, ROUND(AVG(avg_precipitacao), 2) as media_precipitacao
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
GROUP BY 1
ORDER BY 2
LIMIT 1;

-- PERGUNTA 4:

SELECT estado, municipio, bioma, AVG(avg_numero_dias_sem_chuva) as media_dias_sem_chuva
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
WHERE BIOMA IS NOT NULL AND estado = 'RORAIMA'
GROUP BY 1, 2, 3
ORDER BY 4 DESC;


-- PERGUNTA 5:

SELECT municipio, estado, AVG(avg_risco_fogo) as media_risco_fogo
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
WHERE BIOMA IS NOT NULL AND estado = 'RORAIMA'
GROUP BY 1, 2
ORDER BY 3 DESC;

-- PERGUNTA 6:

SELECT * FROM
(
  SELECT
  EXTRACT(MONTH FROM date_month) AS month, avg_precipitacao
  FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
)
PIVOT
(
  avg(avg_precipitacao) as avg_chuvas
  FOR month in (1, 2, 3)
);

-- PERGUNTA 7:

SELECT date_month, municipio || ', ' || estado as localizacao
from `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`;

-- PERGUNTA 8:

SELECT municipio, 
estado, 
ROUND(AVG(avg_numero_dias_sem_chuva), 2) as media_dias_sem_chuva,  
ROUND(AVG(avg_precipitacao), 2) as media_chuvas,
ROUND(AVG(avg_risco_fogo), 2) as media_risco_fogo,
ROUND(AVG(avg_frp), 2) as media_frp
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
GROUP BY 1, 2
HAVING media_dias_sem_chuva > 10.00 AND media_chuvas != 0.0
ORDER BY 3;

-- PERGUNTA 9:

SELECT 
CASE 
  WHEN estado IN ('RIO GRANDE DO SUL', 'PARANÁ', 'SANTA CATARINA') THEN 'REGIÃO SUL'
  WHEN estado IN ('SÃO PAULO', 'MINAS GERAIS', 'ESPÍRITO SANTO', 'RIO DE JANEIRO') THEN 'REGIÃO SUDESTE'
  WHEN estado IN ('MATO GROSSO DO SUL', 'MATO GROSSO', 'GOIÁS') THEN 'REGIÃO CENTRO-OESTE'
  WHEN estado IN ('PERNAMBUCO', 'SERGIPE', 'PARAÍBA', 'RIO GRANDE DO NORTE', 'CEARÁ', 'BAHIA', 'MARANHÃO', 'PIAUÍ') THEN 'REGIÃO NORDESTE'
  ELSE 'REGIÃO NORTE'
END AS REGIAO,
ROUND(AVG(avg_numero_dias_sem_chuva), 2) AS media_dias_sem_chuva
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
GROUP BY 1
ORDER BY 2;

-- PERGUNTA 10: 

SELECT COUNT(*) as numero_cidades_com_bioma_por_regiao,
CASE 
  WHEN estado IN ('RIO GRANDE DO SUL', 'PARANÁ', 'SANTA CATARINA') THEN 'REGIÃO SUL'
  WHEN estado IN ('SÃO PAULO', 'MINAS GERAIS', 'ESPÍRITO SANTO', 'RIO DE JANEIRO') THEN 'REGIÃO SUDESTE'
  WHEN estado IN ('MATO GROSSO DO SUL', 'MATO GROSSO', 'GOIÁS') THEN 'REGIÃO CENTRO-OESTE'
  WHEN estado IN ('PERNAMBUCO', 'SERGIPE', 'PARAÍBA', 'RIO GRANDE DO NORTE', 'CEARÁ', 'BAHIA', 'MARANHÃO', 'PIAUÍ') THEN 'REGIÃO NORDESTE'
  ELSE 'REGIÃO NORTE'
END AS REGIAO,
bioma
FROM `dias-de-codigo-alura.wildfires_brazil.wildfires_brazil`
GROUP BY 2, 3
ORDER BY 1;
