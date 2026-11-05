-- Aula 5: CASE WHEN, LIKE e funções de texto e data
-- CASE WHEN -> Se... Então... parecido com if else no python
-- CASE WHEN cria uma coluna nova com base em condições, parecido com o SE do Excel.
DELETE FROM acoes WHERE ticker = 'LREN3';
DELETE FROM carteira WHERE ticker = 'LREN3';
-- deletando as linhas que eu esqueci de tirar quando fui salvar o arquivo

SELECT 	ticker,
		preco,
		CASE
			WHEN preco >= 50 THEN 'cara'
			WHEN preco >= 20 THEN 'média'
			-- A ordem dos WHEN importa. 
			ELSE 'barata'
		END AS faixa_preco
FROM acoes ;

-- CASE WHEN + GROUP BY (contando por categoria) criando as variaveis e a ordem dentro do próprio CASE WHEN
SELECT
	CASE
		WHEN preco >= 50 THEN 'cara'
		WHEN preco >= 20 THEN 'média'
		ELSE 'barata'
	END AS faixa_preco,
	COUNT (*) AS qtd,
	AVG (preco) AS preco_medio
FROM acoes
GROUP BY faixa_preco ;
-- agrupa pelo resultado do CASE. Aqui o alias funciona no GROUP BY, no SQLite. Na Aula 2 o problema foi usar alias no HAVING, e o motivo é parecido: nem todo banco aceita alias nessas cláusulas. Por isso, em outros bancos, às vezes é preciso repetir o CASE inteiro no GROUP BY.

SELECT
	CASE
		WHEN dividendo_anual >= 2 THEN 'alto'
		ELSE 'baixo'
	END AS faixa_dividendo,
	COUNT(*) AS qtd,
	MAX(preco) AS maior_preco
FROM acoes
GROUP BY faixa_dividendo ;

-- LIKE (buscar texto por padrão), para filtrar texto, usamos = com o valor exato, como WHERE setor = 'Bancos'. O LIKE serve para quando você sabe só parte do texto. 
SELECT ticker, setor
FROM acoes
WHERE ticker LIKE 'ITUB%'; -- O símbolo % é um coringa que significa “qualquer coisa, de qualquer tamanho, inclusive nada”.

-- Exemplos de uso do % -> 'ITUB%'	começa com ITUB ; '%3'	termina com 3 ; '%UB%'	contém UB em qualquer posição
-- Outro coringa _, que vale exatamente um caractere. Por exemplo, 'ITUB_' pega ITUB3 e ITUB4, mas não ITUB.

-- o código dos tickers brasileiros termina em número, e as ações ordinárias costumam terminar em 3. Escreva uma consulta que mostre ticker e setor das ações cujo ticker termina em 3. Depois me diga quantas apareceram.

SELECT ticker, setor
FROM acoes
WHERE ticker LIKE '%3';

-- funções de texto -> Funções são pequenos “comandos” que recebem um valor e devolvem outro, como no Excel. Hoje vemos as quatro mais usadas com texto.
SELECT
	ticker,
	LOWER(ticker) AS minusculo, -- A irmã dela é UPPER(...), que faz o contrário.
	LENGTH(ticker) AS tamanho, -- conta quantos caracteres tem o texto.
	SUBSTR(ticker, 1, 4) AS prefixo, -- extrai um pedaço do texto. Os três argumentos são: o texto, a posição inicial (no SQL a contagem começa em 1, não em 0) e quantos caracteres pegar.
	ticker || ' - ' || setor AS descricao -- os dois || colam textos, igual ao & do Excel.
FROM acoes;

-- escreva uma consulta que mostre: o ticker; uma coluna descricao no formato ITUB4 (Bancos), ou seja, ticker, espaço, o setor entre parênteses (você vai precisar colar '(' e ')'); uma coluna base com só as 4 primeiras letras do ticker, em minúsculas. Aqui você vai combinar duas funções, uma dentro da outra.
SELECT
	ticker,
	ticker || ' (' || setor || ')' AS descricao,
	LOWER (SUBSTR(ticker, 1, 4)) AS base 			-- Combinar duas funções
FROM acoes ;

-- funções de data
SELECT
    DATE('2026-11-05') AS data_base,						-- valida e devolve a data no formato padrão. Serve como ponto de partida.
    STRFTIME('%Y', '2026-11-05') AS ano,					-- extrai um pedaço da data. O primeiro argumento é o “molde”: %Y é o ano com 4 dígitos, %m é o mês e %d é o dia.
    STRFTIME('%m', '2026-11-05') AS mes,					-- mesmo raciocínio, agora pedindo o mês (11).
    DATE('2026-11-05', '+30 days') AS daqui_30_dias,		-- o segundo argumento é um modificador. Dá para usar '+30 days', '-1 month', '+1 year'.
    JULIANDAY('2026-12-25') - JULIANDAY('2026-11-05') AS dias_ate_natal;  		-- converte cada data em um número (a contagem de dias corridos) e subtrai, então o resultado é a diferença em dias.
-- O padrão AAAA-MM-DD é obrigatório.


-- o ano de '2027-03-15'; a data 60 dias depois de '2026-11-05'; quantos dias faltam de '2026-11-05' até '2026-12-31'.
SELECT
    STRFTIME('%Y', '2027-03-15') AS ano,
    DATE('2026-11-05', '+60 days') AS daqui_60_dias,
    JULIANDAY('2026-12-31') - JULIANDAY('2026-11-05') AS dias_ate_anonovo;

