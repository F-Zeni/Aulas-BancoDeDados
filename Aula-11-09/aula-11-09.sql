CREATE TABLE TB_STOCKS ( -- Ações listadas na bolsa de valores da B3
    ticker_id    INTEGER       GENERATED ALWAYS AS IDENTITY, -- Chave primária autonumerada
    ticker       VARCHAR2(10)  NOT NULL, -- Ticker da emprsa listada na B3
    company      VARCHAR(70)   NOT NULL, -- Nome da empresa listada na B3
    trades       NUMBER(10,2)  NOT NULL, -- Total de valores negocidos na B3
    last_price   NUMBER(10,4)  NOT NULL, -- Último preço negociado
    price_change VARCHAR(10)   NOT NULL, -- Variação de preços
    CONSTRAINT TB_STOCK_PK -- Regra da chave primária
        PRIMARY KEY (ticker_id)
);

COMMENT ON TABLE TB_STOCKS
    IS 'Ações listadas na bolsa de valores da B3';
COMMENT ON COLUMN tb_stocks.ticker_id 
    IS 'Chave primária autonumerada';
COMMENT ON COLUMN tb_stocks.ticker
    IS 'Ticker da emprsa listada na B3';
COMMENT ON COLUMN tb_stocks.company
    IS 'Nome da empresa listada na B3';
COMMENT ON COLUMN tb_stocks.trades
    IS 'Total de valores negocidos na B3'; 
COMMENT ON COLUMN tb_stocks.last_price
    IS 'Último preço negociado';
COMMENT ON COLUMN tb_stocks.price_change
    IS 'Variação de preços'; 

-- SELECT * FROM TB_STOCKS
SELECT s.ticker AS codigo, 
       s.ticker AS empresa -- pode por direto, mas é aconselhaveu colocar o AS
FROM TB_STOCKS s; -- aqui é colocado direto

-- Quantidade, soma, minimo, maximo, media, mediana - Funções de Agregação

SELECT COUNT(*) FROM TB_STOCKS; -- Conta todos os registros da tb_stocks
--SELECT COUNT(1) FROM TB_STOCKS; -- Mesma coisa que a de cima - 380
SELECT COUNT(DISTINCT TICKER) FROM TB_STOCKS; -- DISTINCT > Ignora as informações repetidas e traz apenas 1 de cada - Caso tenha repetida - 376

-- AGRUPAR UM CAMPO
SELECT TICKER, COUNT(TICKER)
    FROM TB_STOCKS
    GROUP BY TICKER;

SELECT TICKER, COUNT(TICKER) AS quantidade -- nomeia o count(ticker) e deixa organizado
    FROM TB_STOCKS
    GROUP BY TICKER HAVING COUNT(TICKER) > 1; -- Mostra apenas os que são maior que 1

-- Valor minimo/maximo
SELECT TICKER, COUNT(TICKER) AS quantidade,
    MIN(ticker_id) AS minimo_id,
    MAX(ticker_id) AS maximo_id
FROM TB_STOCKS
GROUP BY TICKER HAVING COUNT(TICKER) > 1;

SELECT * FROM TB_STOCKS
    WHERE TICKER = 'IGTI3'; 
SELECT * FROM TB_STOCKS
    WHERE TICKER = 'RVEE3';
    
-- Função Escalar
--funcao( argumentos ) => um_unico_dado
SELECT company, UPPER(company) -- Upper retorna tudo em maiúscolo
    FROM TB_STOCKS;
    
SELECT company, UPPER(company) 
    FROM TB_STOCKS
ORDER BY company; -- ORDER BY -> classifica em ordem alfabética

SELECT company, UPPER(company)
    FROM TB_STOCKS
ORDER BY company DESC; -- DESC -> De ordem decrescente -- depende do bd instalado, se for em portugues ele coloca as palavras com acento na ordem normal, mas como ta em inglês, as palavras com acentuação fica como ultimo

SELECT s.ticker, s.company, s.last_price 
    FROM TB_STOCKS s
    WHERE s.LAST_PRICE > 2.00
    ORDER BY LAST_PRICE DESC;
    
SELECT s.ticker, s.company, s.last_price 
    FROM TB_STOCKS s
    WHERE s.ticker IN ('PETR3', 'VALE3') -- OR - igual quando usamos no check
    ORDER BY LAST_PRICE DESC;

SELECT s.ticker, s.company, s.last_price 
    FROM TB_STOCKS s
    WHERE s.ticker IN (
                        SELECT TICKER
                        FROM TB_STOCKS
                        GROUP BY TICKER
                        HAVING COUNT(TICKER) > 1
                        ) -- OR - igual quando usamos no check
    ORDER BY LAST_PRICE DESC; -- Traz sempre quem são os registros duplicados atualizando automaticamente

-- App que o professor tava usando na aula -> DBEAVER (Consegue s conectar com outras linguagens de banco de dados)