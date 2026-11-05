-- Tabela de ações: ticker, empresa, setor, preço e dividendo anual
CREATE TABLE acoes (
  ticker TEXT,
  empresa TEXT,
  setor TEXT,
  preco REAL,
  dividendo_anual REAL
);

INSERT INTO acoes (ticker, empresa, setor, preco, dividendo_anual) VALUES
('PETR4', 'Petrobras', 'Petróleo', 38.50, 6.20),
('VALE3', 'Vale', 'Mineração', 62.10, 5.10),
('ITUB4', 'Itaú Unibanco', 'Bancos', 34.80, 2.10),
('BBDC4', 'Bradesco', 'Bancos', 14.20, 1.30),
('WEGE3', 'WEG', 'Indústria', 40.90, 0.60),
('MGLU3', 'Magazine Luiza', 'Varejo', 9.40, 0.00),
('ABEV3', 'Ambev', 'Bebidas', 12.30, 0.90),
('BBAS3', 'Banco do Brasil', 'Bancos', 27.60, 3.40),
('SUZB3', 'Suzano', 'Papel e Celulose', 52.00, 1.50),
('RENT3', 'Localiza', 'Aluguel de Veículos', 44.70, 0.80);


-- Criando a carteira de acoes ficticia
CREATE TABLE carteira (
  ticker TEXT,
  quantidade REAL,
  preco_compra REAL
);

INSERT INTO carteira (ticker, quantidade, preco_compra) VALUES
('BBSE3', 40, 32),
('ITUB4', 200, 30.5),
('MGLU3', 500, 11.2),
('PETR4', 100, 35),
('VALE3', 50, 58),
('WEGE3', 30, 38);
