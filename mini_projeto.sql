-- =====================================================
-- Mini-projeto: relatório da carteira
-- Tabelas: acoes (dados de mercado), carteira (posições)
-- Banco: estudos.db (SQLite)
-- =====================================================

-- 1) Situação de cada posição (lucro, prejuizo ou neutro)
-- Pergunta : quanto cada posição rendeu após a compra, estão dando lucro ou prejuízo?
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
-- Pergunta : qual é o resultado dos setores que dão lucro?

SELECT  a.setor,
	   SUM((a.preco - c.preco_compra) * c.quantidade) AS resultado_total,
	   COUNT(*) AS qtd_posicoes
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
GROUP BY setor HAVING SUM((a.preco - c.preco_compra) * c.quantidade)> 0
ORDER BY resultado_total DESC ;

-- 3) Top 2 ações por dividendo em cada setor
-- Pergunta : fazendo um rank das ações por setor, qual é o top 2 de cada um?

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
-- Pergunta : pegando somente as ações que não estão na carteira do cliente, qual é sua faixa de preço em ordem de dividendos anuais.
		
SELECT  a.ticker,
		a.setor,
		a.preco,
		a.dividendo_anual,
		CASE 
			WHEN a.preco >= 50 THEN 'cara'
			WHEN a.preco >= 20 THEN 'media'
			ELSE 'barata'
		END AS faixa_preco
FROM acoes AS a
LEFT JOIN carteira AS c ON a.ticker = c.ticker
WHERE c.ticker IS NULL
ORDER BY dividendo_anual DESC ;

-- alternativa equivalente usando o NOT IN

-- SELECT  ticker,
--		setor,
--		preco,
--		dividendo_anual,
--		CASE 
--			WHEN preco >= 50 THEN 'cara'
--			WHEN preco >= 20 THEN 'media'
--			ELSE 'barata'
--		END AS faixa_preco
-- FROM acoes
-- WHERE ticker NOT IN (SELECT ticker FROM carteira)
-- ORDER BY dividendo_anual DESC ;		
