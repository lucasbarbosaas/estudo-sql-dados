-- Primeiro comando JOIN -> 
SELECT a.ticker, a.empresa, c.quantidade, a.preco
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker;

-- Calcular com colunas de tabelas diferentes ; Combinar dados de lados diferentes.
SELECT a.ticker,
	   c.quantidade,
	   a.preco,
	   c.quantidade * a.preco AS valor_atual
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
ORDER BY valor_atual DESC ; 

-- Exercício : Escreva uma consulta que mostre, para cada ação da carteira que existe na acoes
SELECT a.ticker,
	   c.quantidade,
	   a.preco,
	   c.preco_compra,
	   (a.preco - c.preco_compra) * c.quantidade AS resultado
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
ORDER BY resultado DESC ;

-- LEFT JOIN -> manter todas as linhas da tabela da esquerda mesmo que não tenha um par
SELECT c.ticker, c.quantidade, a.empresa, a.preco
FROM carteira AS c
LEFT JOIN acoes AS a ON c.ticker = a.ticker;

-- Caso só queira o que não tem par. É uma técnica muito usada para achar registros que “faltam” em outra tabela, por exemplo clientes sem pedido ou dados sem cadastro.
SELECT c.ticker, c.quantidade
FROM carteira AS c
LEFT JOIN acoes AS a ON c.ticker = a.ticker
WHERE a.ticker IS NULL;

-- Inverta a ideia: liste as ações da tabela acoes que não estão na carteira, mostrando ticker, empresa e setor. Dica de raciocínio: qual tabela precisa ficar à esquerda, no FROM?
SELECT a.ticker, a.empresa, a.setor
FROM acoes AS a
LEFT JOIN carteira AS c ON a.ticker = c.ticker
WHERE c.ticker IS NULL;

-- JOIN junto com GROUP BY, A pergunta: “quanto vale a carteira em cada setor?”
SELECT a.setor,
		COUNT (*) AS qtd_posicoes,
		SUM (c.quantidade * a.preco) AS valor_total
FROM carteira AS c
INNER JOIN acoes AS a ON c.ticker = a.ticker
GROUP BY a.setor
ORDER BY valor_total DESC;

-- Escreva uma consulta que mostre, por setor, o resultado total das posições, ou seja, a soma de (preço atual - preço de compra) * quantidade (chame de resultado_total), mantendo apenas os setores com resultado total positivo e ordenando do maior para o menor.
SELECT a.setor,
		SUM((a.preco - c.preco_compra) * c.quantidade) AS resultado_total
FROM carteira as c
INNER JOIN acoes AS a ON c.ticker = a.ticker
GROUP BY a.setor HAVING SUM((a.preco - c.preco_compra) * c.quantidade) > 0
ORDER BY resultado_total DESC;

-- Colocando uma ação nova em varejcom o intuito de dar lucro no final, para ver o resultado
INSERT INTO acoes (ticker, empresa, setor, preco, dividendo_anual)
VALUES ('LREN3', 'Lojas Renner', 'Varejo', 20.00, 0.90);

INSERT INTO carteira (ticker, quantidade, preco_compra)
VALUES ('LREN3', 200, 10.00);

-- Deletando para deixar limpo novamente
DELETE FROM acoes WHERE ticker = 'LREN3';
DELETE FROM carteira WHERE ticker = 'LREN3';


