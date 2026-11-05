-- PARTITION BY divide as linhas em grupos, como o GROUP BY mas sem juntá-las

SELECT ticker,
       setor,
       dividendo_anual,
       RANK() OVER (PARTITION BY setor ORDER BY dividendo_anual DESC) AS ranking_no_setor
FROM acoes
ORDER BY setor, ranking_no_setor; -- Percebe-se que setor tem tudo separado

-- Funções para o ranking caso haja empate no aspecto analisado
-- ROW_NUMBER() -> nunca repete o númetro, desempata de forma arbitrária
-- RANK() -> repete o número e empatados dividem a mesma posição (como no exemplo) e o próximo pula o número
-- DENSE_RANK() -> empatados dividem a posição e o próximo não pula

-- Escreva uma consulta que mostre, para cada setor, apenas a ação de maior preço daquele setor, com ticker, setor e preco.
WITH ranking_preco AS (
	SELECT	ticker, 
			setor, 
			preco,
			RANK() OVER (PARTITION BY setor ORDER BY preco DESC) AS posicao
	FROM acoes 
	-- ordenar dentro de uma CTE não é necessário
)
SELECT ticker, setor, preco
FROM ranking_preco
WHERE posicao = 1  -- filtro para mostrar só os 1 de cada setor
ORDER BY setor DESC ;

-- Sem copiar nada pronto, adapte a consulta acima para mostrar, em cada setor, as duas ações mais caras, em vez de só a primeira.
WITH ranking_preco AS (
	SELECT  ticker,
			setor,
			preco,
			ROW_NUMBER() OVER(PARTITION BY setor ORDER BY preco DESC) AS resultado
	FROM acoes
)
SELECT ticker, preco, setor, resultado
FROM ranking_preco
WHERE resultado = 1 OR resultado = 2
ORDER BY setor DESC ;
