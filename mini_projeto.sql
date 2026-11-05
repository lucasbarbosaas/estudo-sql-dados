-- =====================================================
-- Mini-projeto: relatório da carteira
-- Tabelas: acoes (dados de mercado), carteira (posições)
-- Banco: estudos.db (SQLite)
-- =====================================================

-- 1) Situação de cada posição (lucro, prejuizo ou neutro)
-- COMANDO : pegue o SQL do exercício 8 e acrescente uma coluna situacao, com um CASE que classifique o resultado da posição em três valores:'lucro' se o resultado for maior que 0; 'prejuizo' se for menor que 0; 'neutro' caso contrário.
SELECT a.ticker,
	   c.quantidade,
	   a.preco,
	   c.preco_compra,
	   (a.preco - c.preco_compra) * c.quantidade AS resultado,
	   CASE
	   -- escrever a expressão novamente dentro do CASE pq ele não lê alias direto, classifica o resultado
			WHEN (a.preco - c.preco_compra) * c.quantidade > 0 THEN 'lucro'
			WHEN (a.preco - c.preco_compra) * c.quantidade < 0 THEN 'prejuizo'
			ELSE 'neutro'
		END AS situacao
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
ORDER BY resultado DESC ;

-- 2) Resultado por setor (só setores com lucro)
-- COMANDO : escreva uma consulta que mostre, para cada setor: qtd_posicoes: quantas posições da carteira existem naquele setor; resultado_total: a soma do resultado de todas as posições do setor; só os setores com mais de 1 posição (use HAVING); ordenados do maior para o menor resultado_total.

SELECT  a.setor,
	   SUM((a.preco - c.preco_compra) * c.quantidade) AS resultado_total,
	   COUNT(*) AS qtd_posicoes
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
GROUP BY setor HAVING SUM((a.preco - c.preco_compra) * c.quantidade)> 0
ORDER BY resultado_total DESC ;

-- 3) Top 2 ações por dividendo em cada setor
-- COMANDO : as 2 ações com maior dividendo_anual de cada setor. É a mesma estrutura dos exercícios 15 e 16 (CTE + RANK), trocando o critério de preço por dividendo.

WITH ranking AS (
    SELECT
        ticker,
        setor,
        dividendo_anual,
        RANK() OVER (
            PARTITION BY setor
            ORDER BY dividendo_anual DESC
        ) AS posicao
    FROM acoes
)
SELECT ticker, setor, dividendo_anual, posicao
FROM ranking
WHERE posicao <= 2
ORDER BY setor, posicao ;

-- 4) Ações fora da carteira, com faixa de preço
-- COMANDO : escreva uma consulta que mostre, só para as ações que não estão na carteira: ticker, setor e preco; uma coluna faixa_preco com CASE: 'cara' se preco >= 50, 'média' se preco >= 20, 'barata' no resto (as mesmas faixas do exercício 17); o resultado ordenado do maior para o menor dividendo_anual.
		
SELECT  a.ticker,
		a.setor,
		a.preco,
		a.dividendo_anual,
		CASE 
			WHEN a.preco >= 50 THEN 'cara'
			WHEN a.preco >= 20 THEN 'média'
			ELSE 'barata'
		END AS faixa_preco
FROM acoes AS a
LEFT JOIN carteira AS c ON a.ticker = c.ticker
WHERE c.ticker IS NULL
ORDER BY dividendo_anual DESC ;

-- USANDO O NOT IN

SELECT  ticker,
		setor,
		preco,
		dividendo_anual,
		CASE 
			WHEN preco >= 50 THEN 'cara'
			WHEN preco >= 20 THEN 'média'
			ELSE 'barata'
		END AS faixa_preco
FROM acoes
WHERE ticker NOT IN (SELECT ticker FROM carteira)
ORDER BY dividendo_anual DESC ;		
