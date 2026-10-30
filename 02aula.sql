-- Com agregação o SQL resume várias linhas em um único valor, como média ou soma em estatística
-- Comando COUNT, uma função de conta
SELECT COUNT(*)
FROM acoes ; 

-- Podemos usar o AS para definir essa conta feita como uma coluna nova
SELECT COUNT(*)
AS total_acoes
FROM acoes ; 

-- Demosntrando as funções (Média, mínimo, máximo e soma)
SELECT	
	AVG(preco) as preco_medio,
	MIN(preco) as menor_preco,
	MAX(preco) as maior_preco,
	SUM(dividendo_anual) as soma_dividendos
FROM acoes ;

-- Agregar colunas com um filtro
SELECT AVG(preco) AS preco_medio_bancos
FROM acoes
WHERE setor = 'Bancos' ; 

-- EXERCIIO 1 : a quantidade de ações com preço maior que 30 (nomeie como qtd_acima_30). a média do dividendo anual dessas mesmas ações (nomeie como dividendo_medio)
SELECT 
	COUNT(*) AS qtd_acima_30,
	AVG(dividendo_anual) AS dividendo_medio
FROM acoes
WHERE preco > 30 ;

-- O GROUP BY divide as linhas em grupos e calcula a agregação dentro de cada grupo
SELECT setor, COUNT(*) qtd_acoes
FROM acoes
GROUP BY setor ; 

-- Com mais de uma métrica associada
SELECT setor,
	AVG(preco) AS preco_medio,
	SUM(dividendo_anual) AS soma_dividendos
FROM acoes
GROUP BY setor
ORDER BY preco_medio DESC ;

-- Escreva uma consulta que mostre, por setor, o dividendo_anual máximo, ordenado do maior para o menor. Dê o nome maior_dividendo à coluna.
SELECT setor,
	MAX(dividendo_anual) AS maior_dividendo
FROM acoes
GROUP BY setor
ORDER BY maior_dividendo DESC ; 

-- Filtrar grupos com HAVING -> a função fica dentro do comando HAVING
SELECT setor, MAX(dividendo_anual) AS maior_dividendo
FROM acoes
GROUP BY setor
HAVING MAX(dividendo_anual) > 2
ORDER BY maior_dividendo DESC ;

-- Juntando WHERE e HAVING -> WHERE filtra as linhas, HAVING filtra os grupos.
SELECT setor, 
	COUNT(*) AS qtd_acoes,
	AVG(preco) AS preco_medio
FROM acoes
WHERE preco > 10 
GROUP BY setor
HAVING COUNT(*) > 2 
ORDER BY preco_medio DESC ; 

-- Escreva uma consulta que mostre, por setor, a soma dos dividendos anuais (chame de soma_dividendos), mas apenas dos setores em que essa soma seja maior que 1, ordenados do maior para o menor.
SELECT setor,
	SUM(dividendo_anual) AS soma_dividendos
FROM acoes
GROUP BY setor
HAVING dividendo_anual > 1
ORDER BY soma_dividendos DESC ;
