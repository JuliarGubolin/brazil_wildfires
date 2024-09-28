# BRAZIL WILDFIRES DATASET :deciduous_tree::fire:

Considerando o contexto ambiental atual do Brasil, onde a cada dia surgem mais focos de queimadas e a baixa qualidade do ar, por conta disso, faz com que fumemos "sem querer de 4 a 5 cigarros por dia", resolvi estudar um pouco mais e me fazer perguntas sobre isso. Decidi, portanto, analisar a base de dados disponibilizada no Kaggle pelo usuário **Mayara Valliero** [Link para o Kaggle](https://www.kaggle.com/datasets/mayaravalliero/fire-watch-brazil-2024/data?select=Dataset_FireWatch_Brazil_Q2_2024.csv). Os dados abrangem janeiro, fevereiro e março.

[Notícia da CNN sobre a qualidade do ar](https://www.cnnbrasil.com.br/nacional/niveis-de-poluicao-fazem-com-que-a-gente-fume-sem-querer-de-4-a-5-cigarros-por-dia-diz-medico-a-cnn/).

Para manipular o arquivo .CSV, utilizei o BigQuery, já que é bastante conveniente para utilizar o SQL com uma interface amigável e ferramentas para auxiliar neste processo.

OBS: as consultas estão disponibilizadas acima. O arquivo .CSV pode ser encontrado no link para o Kaggle acima.

## Perguntas

Neste tópico, descreverei as perguntas e conclusões que tirei, baseadas nos dados e em pesquisas retiradas de artigos e notícias.

1) Qual o estado brasileiro com uma média de dias sem chuva maior (ou seja, ficou mais tempo sem chuvas)?

`SELECT estado, bioma, AVG(avg_numero_dias_sem_chuva)` 
`FROM 'dias-de-codigo-alura.wildfires_brazil.wildfires_brazil'`
`WHERE BIOMA IS NOT NULL`
`GROUP BY 1, 2`
`ORDER BY 3 DESC`
`LIMIT 1`

- RESPOSTA: o estado de **RORAIMA** concentra a menor média de precipitação no primeiro trimestre de 2024.

2) Qual o BIOMA deste ESTADO brasileiro a mais tempo sem chuvas?

- RESPOSTA: considerando a resposta anterior (RORAIMA), o bioma deste estado com menor média de chuvas é a **Amazônia**.

3) Qual o mês do primeiro trimestre com a menor média das médias de chuvas?

`SELECT EXTRACT(MONTH FROM date_month) as mes_2022, ROUND(AVG(avg_precipitacao), 2) as media_precipitacao`
`FROM 'dias-de-codigo-alura.wildfires_brazil.wildfires_brazil'`
`GROUP BY 1`
`ORDER BY 2`
`LIMIT 1`

OBS: para responder esta pergunta, precisei alterar o nome da coluna `data` para `date_month`, pois data e date são palavras reservadas do SQL. Após isso, extraí apenas o mês desta coluna de data para fazer a análise.

OBS 2: Alguns municípios não possuiam dados de alguns meses. Por exemplo: o município de NOVA SANTA RITA/RS não possui marcações no mês de FEVEREIRO.

- RESPOSTA: O mês com menor média de precipitação do primeiro trimestre de 2022 foi o mês de **FEVEREIRO**, com uma média de médias 255.23.

4) Qual a cidade de RORAIMA com a maior média das médias de dias sem chuva (ou seja, a mais tempo sem chuvas)?

`SELECT estado, municipio, bioma, MAX(avg_numero_dias_sem_chuva) as media_dias_sem_chuva`
`FROM 'dias-de-codigo-alura.wildfires_brazil.wildfires_brazil'`
`WHERE BIOMA IS NOT NULL`
`GROUP BY 1, 2, 3`
`ORDER BY 4 DESC`
`LIMIT 1;`

- RESPOSTA: Município de Boa Vista. A consulta utilizada foi praticamente a mesma da pergunta 1. 

SOBRE AS PERGUNTAS ACIMA: podemos confirmar através desta notícia publicada no [G1: QUEIMADAS EM RORAIMA CAUSARAM MAIOR DEGRADAÇÃO FLORESTAL DOS ÚLTIMOS 15 ANOS NA AMAZÔNIA](https://g1.globo.com/rr/roraima/noticia/2024/05/21/queimadas-em-roraima-causaram-a-maior-degradacao-florestal-dos-ultimos-15-anos-na-amazonia.ghtml).

Inclusive, através [desta notícia](https://g1.globo.com/rr/roraima/noticia/2024/03/25/seca-se-agrava-em-roraima-e-governo-decreta-situacao-de-emergencia-em-14-municipios.ghtml), também publicada no G1, podemos ver que Boa Vista foi um dos municípios do estado de Roraima que decretou estado de emergência!

5) Vimos que o município de Boa Vista/RR foi o município que ficou mais tempo sem chuvas. Porém, será que ele foi o município com a maior média das médias de risco de fogo?

- RESPOSTA: Não, o município que ficou com o maior risco de fogo foi Uiramutã/RR, com uma média de 97.34. Boa Vista ficou em 4° lugar, com uma média de 95.47.

6) Respondendo a pergunta 3) porém utilizando `PIVOT`, já que gostaria de aprender como utilizar propriamente. Mas claro, neste caso não haveria necessidade de fato.

~~~~
SELECT * FROM
(
  SELECT
  EXTRACT(MONTH FROM date_month) AS month, avg_precipitacao
  FROM 'dias-de-codigo-alura.wildfires_brazil.wildfires_brazil'
)
PIVOT
(
  avg(avg_precipitacao) as avg_chuvas
  FOR month in (1, 2, 3)
);
~~~~

