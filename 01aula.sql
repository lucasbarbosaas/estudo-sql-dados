-- Entendendo como funciona o comando SELECT
SELECT * 
FROM acoes ; 

-- Selecionando apenas alguns nomes da tabela
SELECT ticker, empresa, preco
FROM acoes ;

-- Aprendendo a cláusula WHERE, para definir uma condição dentro do SELECT
SELECT ticker, empresa, preco
FROM acoes
WHERE setor = 'Bancos' ; 

SELECT ticker, empresa, preco
FROM acoes
WHERE preco > 30 ;

SELECT ticker, empresa, preco, dividendo_anual
FROM acoes
WHERE dividendo_anual > 2 ;

-- Aprendendo a cláusula ORDER BY para ordenar, de acordo com uma condição, as suas seleções
SELECT empresa, preco, dividendo_anual
FROM acoes
ORDER BY preco ASC ; 

SELECT ticker, preco, dividendo_anual
FROM acoes
ORDER BY preco DESC ;

-- Combinando os comandos e cláusulas
SELECT ticker, preco, dividendo_anual
FROM acoes
WHERE preco > 30
ORDER BY dividendo_anual DESC ;

-- Combinando condições usando os comandos AND ou OR. O SQL lê primeiro o AND, caso vá usar os dois juntos.
SELECT ticker, empresa, setor, preco
FROM acoes
WHERE preco > 10 AND setor = 'Bancos'
ORDER BY preco DESC ; 

SELECT ticker, empresa, setor, preco, dividendo_anual
FROM acoes
WHERE setor = 'Varejo' OR setor = 'Bebidas' 
ORDER BY preco DESC ;
