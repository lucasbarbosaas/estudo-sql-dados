-- Subquerys -> Consulta dentro da outra, a de dentro roda primeiro e a de fora usa o resultado dela. “quais ações custam mais do que a média de preço?”
SELECT ticker, empresa, preco
FROM acoes
WHERE preco > (SELECT AVG(preco) FROM acoes);

-- Podemos rodar só a subquery, boa prática para depurar.

-- Escreva uma consulta que mostre ticker, empresa e dividendo_anual das ações cujo dividendo anual é maior que a média de dividendo anual de todas as ações.
SELECT ticker, empresa, dividendo_anual
FROM acoes
WHERE dividendo_anual > (SELECT AVG(dividendo_anual) FROM acoes);

-- subquery com IN, serve para devolver uma lista de valores.
SELECT ticker, empresa
FROM acoes
WHERE ticker IN (SELECT ticker FROM carteira); --mantém as linhas cujo ticker está dentro da lista que vier do parêntese.

-- NOT IN, mantém as linhas que não estão na lista
-- Escreva uma consulta que mostre ticker, empresa e setor das ações que não estão na carteira, usando NOT IN com subquery.
SELECT ticker, empresa, setor
FROM acoes
WHERE ticker NOT IN (SELECT ticker FROM carteira);
--Se a lista que a subquery devolve tiver algum valor NULL, o NOT IN não devolve nenhuma linha, sem erro e sem aviso. Isso acontece porque comparar um valor com NULL não dá “verdadeiro” nem “falso”, dá “desconhecido”, e o filtro descarta a linha.
--0 LEFT JOIN ... IS NULL é mais seguro. Guarde as duas formas e escolha conforme o dado: o NOT IN quando você tem certeza de que não há NULL, e o LEFT JOIN quando não tem.

-- CTE (WITH) -> nome para um resultado intermediário que será usado mais a frente como uma tabela. Forma de quebrar consultas grandes em etapas legíveis.
WITH posicoes AS (                 -- Abre a CTE e da o nome de posicoes a ela
  SELECT c.ticker,
 	     a.setor,
	     (a.preco - c.preco_compra) * c.quantidade AS resultado 
  FROM carteira AS c
  INNER JOIN acoes AS a ON c.ticker = a.ticker
)
SELECT setor, SUM(resultado) AS resultado_total
FROM posicoes                    -- Trata a tabela posicoes normalmente
GROUP BY setor 
HAVING SUM(resultado) > 0 
ORDER BY resultado_total DESC;

-- Use uma CTE para calcular o valor atual de cada posição (quantidade * preco, com o nome valor_atual) e, na consulta principal, mostre só as posições com valor atual acima da média dos valores das posições. Mostre ticker e valor_atual.
WITH resultado AS (
	SELECT  c.ticker,
			a.setor,
			a.preco,
			c.quantidade,
			(c.quantidade * a.preco) AS valor_atual
	FROM carteira AS c
	INNER JOIN acoes AS a ON c.ticker = a.ticker 
)
SELECT ticker, valor_atual
FROM resultado
WHERE valor_atual > (SELECT AVG(valor_atual) FROM resultado)
ORDER BY valor_atual DESC;
-- Usar WHERE em vez de HAVING porque estamos filtrando linhas e nao grupos.

-- windows functions, com o GROUP BY as linhas se juntam em uma por grupo. com a windows function vc calcula algo sobre um conjunto de linhas sem junta-las : cada linha continua aparecendo e ganha uma coluna nova.
-- caso mais comum : ranking
SELECT  ticker,
		preco,
		RANK() OVER (ORDER BY preco DESC) AS ranking
FROM acoes;
-- RANK() numera as linhas por posicao 1,2,3...
-- OVER(...) torna a window function, dentro do () voce diz como olhar para as linhas
-- Escreva uma consulta que mostre ticker, setor, dividendo_anual e uma coluna ranking_dividendo que numere as ações do maior dividendo para o menor.
SELECT  ticker,
		setor,
		dividendo_anual,
		RANK () OVER (ORDER BY dividendo_anual DESC) AS ranking_dividendo
FROM acoes;
		
