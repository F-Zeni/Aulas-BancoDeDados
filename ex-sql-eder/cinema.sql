CREATE TABLE exe_clientes (
    id_cliente       NUMBER(10) NOT NULL,
    nome             VARCHAR2(120) NOT NULL,
    email            VARCHAR2(150) NOT NULL,
    data_nascimento  DATE NOT NULL,
    cidade           VARCHAR2(80) NOT NULL,

    CONSTRAINT pk_clientes
        PRIMARY KEY (id_cliente),

    CONSTRAINT uk_clientes_email
        UNIQUE (email)
);


CREATE TABLE exe_salas (
    id_sala      NUMBER(10) NOT NULL,
    nome_sala    VARCHAR2(40) NOT NULL,
    capacidade   NUMBER(4) NOT NULL,
    tipo_sala    VARCHAR2(30) NOT NULL,

    CONSTRAINT pk_salas
        PRIMARY KEY (id_sala),

    CONSTRAINT uk_salas_nome
        UNIQUE (nome_sala),

    CONSTRAINT ck_salas_capacidade
        CHECK (capacidade > 0),

    CONSTRAINT ck_salas_tipo
        CHECK (tipo_sala IN ('DIGITAL', '3D', 'IMAX', 'VIP'))
);

CREATE TABLE exe_filmes_em_cartaz (
    id_filme              NUMBER(10) NOT NULL,
    titulo                VARCHAR2(150) NOT NULL,
    tipo                  VARCHAR2(40) NOT NULL,
    classificacao         VARCHAR2(10) NOT NULL,
    duracao_minutos       NUMBER(4) NOT NULL,
    data_inicio_cartaz    DATE NOT NULL,
    data_fim_cartaz       DATE,
    ativo                 CHAR(1) DEFAULT 'S' NOT NULL,

    CONSTRAINT pk_filmes_em_cartaz
        PRIMARY KEY (id_filme),

    CONSTRAINT ck_filmes_duracao
        CHECK (duracao_minutos > 0),

    CONSTRAINT ck_filmes_classificacao
        CHECK (classificacao IN ('LIVRE', '10', '12', '14', '16', '18')),

    CONSTRAINT ck_filmes_ativo
        CHECK (ativo IN ('S', 'N')),

    CONSTRAINT ck_filmes_periodo
        CHECK (
            data_fim_cartaz IS NULL
            OR data_fim_cartaz >= data_inicio_cartaz
        )
);


CREATE TABLE exe_sessoes (
    id_sessao          NUMBER(10) NOT NULL,
    id_filme           NUMBER(10) NOT NULL,
    id_sala            NUMBER(10) NOT NULL,
    data_hora_inicio   DATE NOT NULL,
    idioma             VARCHAR2(20) NOT NULL,
    formato            VARCHAR2(10) NOT NULL,

    CONSTRAINT pk_sessoes
        PRIMARY KEY (id_sessao),

    CONSTRAINT fk_sessoes_filme
        FOREIGN KEY (id_filme)
        REFERENCES exe_filmes_em_cartaz (id_filme),

    CONSTRAINT fk_sessoes_sala
        FOREIGN KEY (id_sala)
        REFERENCES exe_salas (id_sala),

    CONSTRAINT ck_sessoes_idioma
        CHECK (idioma IN ('DUBLADO', 'LEGENDADO')),

    CONSTRAINT ck_sessoes_formato
        CHECK (formato IN ('2D', '3D'))
);


CREATE TABLE exe_ingressos (
    id_ingresso       NUMBER(10) NOT NULL,
    id_sessao         NUMBER(10) NOT NULL,
    id_cliente        NUMBER(10) NOT NULL,
    numero_assento    VARCHAR2(5) NOT NULL,
    data_venda        DATE NOT NULL,
    tipo_ingresso     VARCHAR2(10) NOT NULL,
    preco_cheio       NUMBER(8,2) NOT NULL,
    desconto          NUMBER(5,2) DEFAULT 0 NOT NULL,
    forma_pagamento   VARCHAR2(20) NOT NULL,
    canal_venda       VARCHAR2(15) NOT NULL,
    status_ingresso   VARCHAR2(12) NOT NULL,

    CONSTRAINT pk_ingressos
        PRIMARY KEY (id_ingresso),

    CONSTRAINT fk_ingressos_sessao
        FOREIGN KEY (id_sessao)
        REFERENCES exe_sessoes (id_sessao),

    CONSTRAINT fk_ingressos_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES exe_clientes (id_cliente),

    CONSTRAINT uk_ingressos_assento
        UNIQUE (id_sessao, numero_assento),

    CONSTRAINT ck_ingressos_tipo
        CHECK (tipo_ingresso IN ('INTEIRA', 'MEIA')),

    CONSTRAINT ck_ingressos_preco
        CHECK (preco_cheio > 0),

    CONSTRAINT ck_ingressos_desconto
        CHECK (desconto BETWEEN 0 AND 100),

    CONSTRAINT ck_ingressos_tipo_desconto
        CHECK (
            (tipo_ingresso = 'INTEIRA' AND desconto = 0)
            OR
            (tipo_ingresso = 'MEIA' AND desconto = 50)
        ),

    CONSTRAINT ck_ingressos_pagamento
        CHECK (
            forma_pagamento IN
            ('PIX', 'CREDITO', 'DEBITO', 'DINHEIRO')
        ),

    CONSTRAINT ck_ingressos_canal
        CHECK (
            canal_venda IN
            ('BILHETERIA', 'SITE', 'APP')
        ),

    CONSTRAINT ck_ingressos_status
        CHECK (
            status_ingresso IN
            ('PAGO', 'UTILIZADO', 'CANCELADO')
        )
);


DELETE FROM exe_ingressos;
DELETE FROM exe_sessoes;
DELETE FROM exe_filmes_em_cartaz;
DELETE FROM exe_salas;
DELETE FROM exe_clientes;

COMMIT;

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (1, 'Ana Carolina Souza', 'ana.souza@email.com',
     DATE '1995-02-14', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (2, 'Bruno Almeida', 'bruno.almeida@email.com',
     DATE '1989-07-22', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (3, 'Camila Rodrigues', 'camila.rodrigues@email.com',
     DATE '1998-11-03', 'Santo André');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (4, 'Daniel Martins', 'daniel.martins@email.com',
     DATE '1985-04-18', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (5, 'Eduardo Ferreira', 'eduardo.ferreira@email.com',
     DATE '1992-09-10', 'São Bernardo do Campo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (6, 'Fernanda Lima', 'fernanda.lima@email.com',
     DATE '1997-01-27', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (7, 'Gabriel Costa', 'gabriel.costa@email.com',
     DATE '2000-05-16', 'Guarulhos');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (8, 'Helena Ribeiro', 'helena.ribeiro@email.com',
     DATE '1990-12-01', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (9, 'Isabela Martins', 'isabela.martins@email.com',
     DATE '2002-03-11', 'Osasco');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (10, 'João Pedro Silva', 'joao.silva@email.com',
     DATE '1994-08-19', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (11, 'Karen Oliveira', 'karen.oliveira@email.com',
     DATE '1999-06-30', 'Barueri');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (12, 'Lucas Mendes', 'lucas.mendes@email.com',
     DATE '1987-10-07', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (13, 'Mariana Santos', 'mariana.santos@email.com',
     DATE '1996-04-25', 'São Caetano do Sul');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (14, 'Nicolas Rocha', 'nicolas.rocha@email.com',
     DATE '2001-02-08', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (15, 'Olivia Barbosa', 'olivia.barbosa@email.com',
     DATE '1993-09-17', 'Guarulhos');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (16, 'Paulo Henrique', 'paulo.henrique@email.com',
     DATE '1984-01-12', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (17, 'Renata Gomes', 'renata.gomes@email.com',
     DATE '1991-07-05', 'Osasco');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (18, 'Rafael Nunes', 'rafael.nunes@email.com',
     DATE '1995-11-29', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (19, 'Sabrina Teixeira', 'sabrina.teixeira@email.com',
     DATE '1998-05-21', 'Santo André');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (20, 'Thiago Moreira', 'thiago.moreira@email.com',
     DATE '1988-03-09', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (21, 'Ursula Azevedo', 'ursula.azevedo@email.com',
     DATE '1997-12-14', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (22, 'Valentina Freitas', 'valentina.freitas@email.com',
     DATE '2003-06-18', 'Guarulhos');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (23, 'William Castro', 'william.castro@email.com',
     DATE '1990-10-23', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (24, 'Yasmin Cardoso', 'yasmin.cardoso@email.com',
     DATE '2000-09-02', 'Barueri');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (25, 'Zeca Almeida', 'zeca.almeida@email.com',
     DATE '1983-06-06', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (26, 'Alice Ramos', 'alice.ramos@email.com',
     DATE '1999-08-13', 'São Caetano do Sul');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (27, 'Beatriz Moura', 'beatriz.moura@email.com',
     DATE '1994-02-20', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (28, 'Carlos Augusto', 'carlos.augusto@email.com',
     DATE '1986-05-04', 'Osasco');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (29, 'Debora Pires', 'debora.pires@email.com',
     DATE '1996-11-15', 'São Paulo');

INSERT INTO exe_clientes
    (id_cliente, nome, email, data_nascimento, cidade)
VALUES
    (30, 'Enzo Vieira', 'enzo.vieira@email.com',
     DATE '2004-01-31', 'Guarulhos');

INSERT ALL
    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (1, 'Sala 01', 180, 'DIGITAL')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (2, 'Sala 02', 150, 'DIGITAL')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (3, 'Sala 03', 120, '3D')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (4, 'Sala 04', 100, '3D')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (5, 'Sala 05', 80, 'IMAX')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (6, 'Sala 06', 60, 'VIP')

    INTO exe_salas (id_sala, nome_sala, capacidade, tipo_sala)
    VALUES (7, 'Sala 07', 200, 'DIGITAL')
SELECT 1
FROM dual;

INSERT ALL
    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (1, 'A Cidade das Estrelas', 'Drama', '12', 128,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (2, 'Missão Horizonte', 'Ação', '14', 142,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (3, 'Pequenos Heróis', 'Animação', 'LIVRE', 96,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (4, 'O Último Código', 'Suspense', '16', 118,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (5, 'Amor em Dezembro', 'Romance', '12', 110,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (6, 'Planeta Azul', 'Documentário', 'LIVRE', 104,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (7, 'Ritmo da Rua', 'Musical', '10', 121,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (8, 'O Reino Perdido', 'Fantasia', '10', 135,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (9, 'Noite de Mistério', 'Terror', '18', 108,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (10, 'Código da Memória', 'Ficção Científica', '14', 129,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (11, 'O Jardim Secreto', 'Família', 'LIVRE', 101,
         DATE '2026-08-01', DATE '2026-10-31', 'S')

    INTO exe_filmes_em_cartaz
        (id_filme, titulo, tipo, classificacao, duracao_minutos,
         data_inicio_cartaz, data_fim_cartaz, ativo)
    VALUES
        (12, 'Velocidade Máxima', 'Ação', '16', 116,
         DATE '2026-08-01', DATE '2026-10-31', 'S')
SELECT 1
FROM dual;

INSERT INTO exe_sessoes
    (
        id_sessao,
        id_filme,
        id_sala,
        data_hora_inicio,
        idioma,
        formato
    )
SELECT
    ((d.dia - 1) * 28)
        + ((s.id_sala - 1) * 4)
        + h.ordem AS id_sessao,

    MOD(
        ((d.dia - 1) * 7)
        + (s.id_sala - 1)
        + (h.ordem - 1),
        12
    ) + 1 AS id_filme,

    s.id_sala,

    DATE '2026-09-01'
        + (d.dia - 1)
        + h.hora_fracao AS data_hora_inicio,

    CASE
        WHEN MOD(d.dia + s.id_sala + h.ordem, 3) = 0
            THEN 'LEGENDADO'
        ELSE 'DUBLADO'
    END AS idioma,

    CASE
        WHEN MOD(s.id_sala + h.ordem, 4) = 0
            THEN '3D'
        ELSE '2D'
    END AS formato

FROM exe_salas s

CROSS JOIN (
    SELECT LEVEL AS dia
    FROM dual
    CONNECT BY LEVEL <= 30
) d

CROSS JOIN (
    SELECT 1 AS ordem, 13/24 AS hora_fracao FROM dual
    UNION ALL
    SELECT 2 AS ordem, 16/24 AS hora_fracao FROM dual
    UNION ALL
    SELECT 3 AS ordem, 19/24 AS hora_fracao FROM dual
    UNION ALL
    SELECT 4 AS ordem, 21.5/24 AS hora_fracao FROM dual
) h;

INSERT INTO exe_ingressos
    (
        id_ingresso,
        id_sessao,
        id_cliente,
        numero_assento,
        data_venda,
        tipo_ingresso,
        preco_cheio,
        desconto,
        forma_pagamento,
        canal_venda,
        status_ingresso
    )
SELECT
    ((s.id_sessao - 1) * 4) + a.ordem AS id_ingresso,

    s.id_sessao,

    MOD(s.id_sessao + a.ordem - 2, 30) + 1 AS id_cliente,

    CHR(64 + a.ordem)
        || LPAD(TO_CHAR(a.ordem), 2, '0') AS numero_assento,

    s.data_hora_inicio
        - (MOD(s.id_sessao + a.ordem, 5))
        - (a.ordem / 24) AS data_venda,

    CASE
        WHEN MOD(s.id_sessao + a.ordem, 4) = 0
            THEN 'MEIA'
        ELSE 'INTEIRA'
    END AS tipo_ingresso,

    CASE
        WHEN MOD(s.id_sala, 4) = 1 THEN 35.00
        WHEN MOD(s.id_sala, 4) = 2 THEN 38.00
        WHEN MOD(s.id_sala, 4) = 3 THEN 45.00
        ELSE 48.00
    END AS preco_cheio,

    CASE
        WHEN MOD(s.id_sessao + a.ordem, 4) = 0
            THEN 50.00
        ELSE 0.00
    END AS desconto,

    CASE MOD(s.id_sessao + a.ordem, 4)
        WHEN 0 THEN 'PIX'
        WHEN 1 THEN 'CREDITO'
        WHEN 2 THEN 'DEBITO'
        ELSE 'DINHEIRO'
    END AS forma_pagamento,

    CASE MOD(s.id_sessao + a.ordem, 3)
        WHEN 0 THEN 'SITE'
        WHEN 1 THEN 'APP'
        ELSE 'BILHETERIA'
    END AS canal_venda,

    CASE
        WHEN MOD(s.id_sessao + a.ordem, 23) = 0
            THEN 'CANCELADO'
        WHEN MOD(s.id_sessao + a.ordem, 7) = 0
            THEN 'UTILIZADO'
        ELSE 'PAGO'
    END AS status_ingresso
FROM exe_sessoes s
CROSS JOIN (
    SELECT LEVEL AS ordem
    FROM dual
    CONNECT BY LEVEL <= 4
) a;

COMMIT;

SELECT
    'exe_clientes' AS tabela,
    COUNT(*) AS quantidade
FROM exe_clientes

UNION ALL

SELECT
    'exe_salas',
    COUNT(*)
FROM exe_salas

UNION ALL

SELECT
    'exe_filmes_em_cartaz',
    COUNT(*)
FROM exe_filmes_em_cartaz

UNION ALL

SELECT
    'exe_sessoes',
    COUNT(*)
FROM exe_sessoes

UNION ALL

SELECT
    'exe_ingressos',
    COUNT(*)
FROM exe_ingressos;

COMMIT;

-- SELECT e Projeções de dados -- 

// Ex 1
SELECT id_cliente, nome, email, cidade FROM EXE_CLIENTES;

// Ex 2
SELECT nome, cidade FROM EXE_CLIENTES;

// Ex 3
SELECT titulo, tipo, classificacao, duracao_minutos FROM EXE_FILMES_EM_CARTAZ;

// Ex 4
SELECT nome_sala, capacidade, tipo_sala FROM EXE_SALAS;

// Ex 5
SELECT id_ingresso, tipo_ingresso, preco_cheio, desconto FROM EXE_INGRESSOS;

// Ex 6
SELECT DISTINCT cidade FROM EXE_CLIENTES;

// Ex 7
SELECT tipo FROM EXE_FILMES_EM_CARTAZ;

// Ex 8
SELECT DISTINCT forma_pagamento FROM EXE_INGRESSOS;

// Ex 9
SELECT titulo 
    FROM EXE_FILMES_EM_CARTAZ
ORDER BY (titulo);

// Ex 10
SELECT nome
    FROM EXE_CLIENTES
ORDER BY (nome) DESC;

-- Where e Condições --
// Ex 11
SELECT * FROM EXE_CLIENTES
    WHERE cidade = 'São Paulo';
    
// Ex 12
SELECT * FROM EXE_CLIENTES
    WHERE cidade IN ('Guarulhos', 'Osasco', 'Santo André');
    
// Ex 13
SELECT * FROM EXE_FILMES_EM_CARTAZ
    WHERE classificacao = '14';

// Ex 14
SELECT * FROM EXE_FILMES_EM_CARTAZ
    WHERE duracao_minutos > 120;
    
// Ex 15
SELECT * FROM EXE_FILMES_EM_CARTAZ
    WHERE duracao_minutos BETWEEN 100 AND 130;
    
// Ex 16
SELECT * FROM EXE_SALAS
    WHERE capacidade > 100;
    
// Ex 17
SELECT * FROM EXE_INGRESSOS
    WHERE tipo_ingresso = 'MEIA';

// Ex 18
SELECT * FROM EXE_INGRESSOS
    WHERE PRECO_CHEIO >= 40;

// Ex 19
SELECT * FROM EXE_INGRESSOS
    WHERE canal_venda IN ('SITE', 'APP');
    
// Ex 20
SELECT * FROM EXE_INGRESSOS
    WHERE status_ingresso = 'CANCELADO';
    
-- Funções escalares --
// Ex 21
SELECT UPPER(nome) As nome 
    FROM EXE_CLIENTES;

// Ex 22
SELECT LOWER(titulo) As titulo
    FROM EXE_FILMES_EM_CARTAZ;

// Ex 23
SELECT nome, LENGTH(nome) As qntd_caracteres
    FROM EXE_CLIENTES;

// Ex 24
SELECT titulo, SUBSTR(titulo, 1, 4) As primeiros_caracteres
    FROM EXE_FILMES_EM_CARTAZ;
    
// Ex 25
SELECT titulo || ' - Classificação: ' || classificacao
    FROM EXE_FILMES_EM_CARTAZ;
    
// Ex 26
SELECT nome || ' de ' || cidade
    FROM EXE_CLIENTES;
    
// Ex 27
SELECT 
    nome 
    || ' - ' ||
    data_nascimento 
    || ' - Idade Aproximada: ' ||
    TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12)  
FROM EXE_CLIENTES;
    
// Ex 28
SELECT TO_CHAR(data_venda, 'DD/MM/YYYY') As data_venda 
    FROM EXE_INGRESSOS;

// Ex 29
SELECT TO_CHAR(data_hora_inicio, 'DD/MM/YYYY HH24:MI') As data_hora_inicio 
    FROM EXE_SESSOES;
    
// Ex 30
SELECT 
    id_ingresso, preco_cheio, desconto,
    ROUND(preco_cheio * (1 - desconto / 100), 2) AS valor_pago
FROM EXE_INGRESSOS;

// Ex 31
SELECT
    preco_cheio,
    ROUND(preco_cheio * (1 - desconto / 100), 2) AS valor_pago,
    ROUND(preco_cheio - (preco_cheio * (1 - desconto / 100)), 2) as diferenca
FROM EXE_INGRESSOS;

-- Funções de Agregação --

// Ex 32
SELECT
    ROUND(duracao_minutos / 60, 2) as horas
    FROM EXE_FILMES_EM_CARTAZ;

// Ex 33
SELECT COUNT(*) FROM EXE_CLIENTES;

// Ex 34
SELECT COUNT(*) FROM EXE_FILMES_EM_CARTAZ;

// Ex 35
SELECT COUNT(*) FROM EXE_SESSOES;

// Ex 36
SELECT COUNT(*) FROM EXE_INGRESSOS;

// Ex 37
SELECT MAX(preco_cheio) As maior_preco
    FROM EXE_INGRESSOS;
    
// Ex 38
SELECT MIN(preco_cheio) As menor_preco
    FROM EXE_INGRESSOS;
    
// Ex 39
SELECT TRUNC(AVG(preco_cheio), 2) As media_de_preco
    FROM EXE_INGRESSOS;
    
// Ex 40
SELECT SUM(preco_cheio * (1 - desconto / 100 )) As Soma
    FROM EXE_INGRESSOS
WHERE status_ingresso != 'CANCELADO';

// Ex 41
SELECT tipo_ingresso, COUNT(tipo_ingresso)
    FROM EXE_INGRESSOS
GROUP BY tipo_ingresso;

// Ex 42
SELECT forma_pagamento, 
    SUM(preco_cheio * (1 - desconto / 100)) As total_arrecadado
    FROM EXE_INGRESSOS
GROUP BY forma_pagamento;
    
// Ex 43
SELECT canal_venda, COUNT(id_ingresso) as qntd_ingressos
    FROM EXE_INGRESSOS
GROUP BY canal_venda;

// Ex 44
SELECT classificacao, COUNT(id_filme) as qntd_filmes
    FROM EXE_FILMES_EM_CARTAZ
GROUP BY classificacao;

// Ex 45
SELECT ROUND(AVG(duracao_minutos), 2)
    FROM EXE_FILMES_EM_CARTAZ;

// Ex 46
SELECT cidade, COUNT(id_cliente) as qntd_clientes
    FROM EXE_CLIENTES
GROUP BY cidade;

// Ex 47
SELECT tipo_ingresso, COUNT(id_ingresso) as qntd_ingressos
    FROM EXE_INGRESSOS
GROUP BY tipo_ingresso;

// Ex 48
SELECT status_ingresso, COUNT(id_ingresso) as qntd_ingressos
    FROM EXE_INGRESSOS
GROUP BY status_ingresso;

// Ex 49
SELECT forma_pagamento, SUM(preco_cheio * (1 - desconto / 100)) as faturamento
    FROM EXE_INGRESSOS
    WHERE status_ingresso != 'CANCELADO'
    GROUP BY forma_pagamento;
    
// Ex 50
SELECT canal_venda, SUM(preco_cheio * (1 - desconto / 100)) as faturamento
    FROM EXE_INGRESSOS
    GROUP BY canal_venda;
    
// Ex 51
SELECT tipo_sala, COUNT(id_sala) as qntd_sala
    FROM EXE_SALAS
GROUP BY tipo_sala;

// Ex 52
SELECT cidade, COUNT(id_cliente)
    FROM EXE_CLIENTES
    GROUP BY cidade HAVING COUNT(id_cliente) > 3;
    
// Ex 53
SELECT tipo, AVG(duracao_minutos)
    FROM EXE_FILMES_EM_CARTAZ
    GROUP BY tipo HAVING AVG(duracao_minutos) > 115;
    
// Ex 54
SELECT forma_pagamento, 
    SUM(preco_cheio * (1 - desconto / 100)) As total_arrecadado
    FROM EXE_INGRESSOS
GROUP BY forma_pagamento HAVING SUM(preco_cheio * (1 - desconto / 100)) > 20000;

// Inner Join

// Ex 55
SELECT id_ingresso, nome
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_CLIENTES c
        ON c.id_cliente = i.id_cliente;
        
// Ex 56
SELECT id_ingresso, nome, data_venda
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_CLIENTES c
    ON c.id_cliente = i.id_cliente;

// 57
SELECT titulo, TO_CHAR(data_hora_inicio, 'DD/MM/YYYY HH24:MI') as data_hora_inicio
    FROM EXE_FILMES_EM_CARTAZ f
    INNER JOIN EXE_SESSOES s
    ON f.id_filme = s.id_filme;

// Ex 58
SELECT titulo, nome_sala, TO_CHAR(data_hora_inicio, 'DD/MM/YYYY HH24:MI') as data_hora_inicio
    FROM EXE_FILMES_EM_CARTAZ f
    INNER JOIN EXE_SESSOES s
    ON f.id_filme = s.id_filme
    INNER JOIN EXE_SALAS se
    ON se.id_sala = s.id_sala;
    
// Ex 59
SELECT i.id_ingresso, c.nome, f.titulo, s.nome_sala, se.data_hora_inicio
    FROM EXE_CLIENTES c
    INNER JOIN EXE_INGRESSOS i
    ON c.id_cliente = i.id_cliente
    INNER JOIN EXE_SESSOES se
    ON se.id_sessao = i.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
    ON f.id_filme = se.id_filme
    INNER JOIN EXE_SALAS s
    ON s.id_sala = se.id_sala;
    
// Ex 60
SELECT i.id_ingresso, f.titulo, f.classificacao
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
    ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
    ON se.id_filme = f.id_filme
    WHERE classificacao = '14';
    
// Ex 61
SELECT i.id_ingresso, s.tipo_sala
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
    ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_SALAS s
    ON s.id_sala = se.id_sala
    WHERE s.tipo_sala = 'IMAX';
    
// Ex 62
SELECT f.id_filme, COUNT(i.id_ingresso) as qntd_ingresso
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
    ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
    ON f.id_filme = se.id_filme
GROUP BY (f.id_filme)
ORDER BY f.id_filme;

// Ex 63
SELECT f.id_filme, SUM(i.preco_cheio * (1 - desconto/100)) as faturamento
    FROM EXE_FILMES_EM_CARTAZ f
    INNER JOIN EXE_SESSOES se
    ON f.id_filme = se.id_filme
    INNER JOIN EXE_INGRESSOS i
    ON i.id_sessao = se.id_sessao
WHERE i.status_ingresso != 'CANCELADO'
GROUP BY (f.id_filme);

// Ex 64
SELECT s.id_sala, COUNT(i.id_ingresso)
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON se.id_sessao = i.id_sessao
    INNER JOIN EXE_SALAS s
        ON s.id_sala = se.id_sala
GROUP BY (s.id_sala);

// Ex 65
SELECT s.id_sala, SUM(i.preco_cheio * (1 - i.desconto/100)) as faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON se.id_sessao = i.id_sessao
    INNER JOIN EXE_SALAS s
        ON s.id_sala = se.id_sala
GROUP BY(s.id_sala);

// Ex 66
SELECT s.tipo_sala, SUM(i.preco_cheio * (1 - i.desconto/100)) as faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON se.id_sessao = i.id_sessao
    INNER JOIN EXE_SALAS s
        ON s.id_sala = se.id_sala
GROUP BY s.tipo_sala;

-- Left Join

// Ex 67
SELECT c.id_cliente, COUNT(i.id_ingresso) as qntd_ingresso
    FROM EXE_CLIENTES c
    LEFT JOIN EXE_INGRESSOS i
        ON c.id_cliente = i.id_cliente
GROUP BY c.id_cliente;

// Ex 68
SELECT i.id_cliente, c.id_cliente 
    FROM EXE_CLIENTES c
    LEFT JOIN EXE_INGRESSOS i
        ON c.id_cliente = i.id_cliente;
        
// Ex 69
SELECT s.id_sala, se.id_sessao
    FROM EXE_SALAS s
    LEFT JOIN EXE_SESSOES se
        ON s.id_sala = se.id_sala;
        
// Ex 70
SELECT s.id_sala, se.id_sessao
    FROM EXE_SALAS s
    LEFT JOIN EXE_SESSOES se
        ON s.id_sala = se.id_sala
        AND s.id_sala IN (
            SELECT id_sala
            FROM EXE_SALAS
            WHERE tipo_sala = 'IMAX'
        );

SELECT s.id_sala, se.id_sessao
    FROM EXE_SALAS s
    LEFT JOIN EXE_SESSOES se
        ON s.id_sala = se.id_sala
        AND se.idioma = 'dublado';
        
// Ex 71
SELECT f.titulo, COUNT(i.id_ingresso) as qntd_ingressos 
    FROM EXE_FILMES_EM_CARTAZ f
    LEFT JOIN EXE_SESSOES se
        ON f.id_filme = se.id_filme
            LEFT JOIN EXE_INGRESSOS i
                ON i.id_sessao = se.id_sessao
GROUP BY f.titulo;

// Ex 72
SELECT f.titulo, COUNT(i.id_ingresso) AS qntd_ingressos
    FROM EXE_FILMES_EM_CARTAZ f
    LEFT JOIN EXE_SESSOES se
        ON f.id_filme = se.id_filme
            LEFT JOIN EXE_INGRESSOS i
                ON i.id_sessao = se.id_sessao
                AND i.status_ingresso = 'PAGO'
GROUP BY f.titulo;

// Ex 73
SELECT c.id_cliente, SUM(i.preco_cheio * (1 - i.desconto/100)) as total_gasto
    FROM EXE_CLIENTES c
        LEFT JOIN EXE_INGRESSOS i
            ON c.id_cliente = i.id_cliente
GROUP BY c.id_cliente;

-- Right Join
// Ex 74
SELECT i.id_ingresso, c.id_cliente
    FROM EXE_INGRESSOS i
    RIGHT JOIN EXE_CLIENTES c
        ON i.id_cliente = c.id_cliente;
        
// Ex 75
SELECT s.id_sala, se.id_sessao
    FROM EXE_SALAS s
    RIGHT JOIN EXE_SESSOES se
        ON s.id_sala = se.id_sala;
        
// Ex 76
SELECT f.id_filme, se.id_sessao
    FROM EXE_FILMES_EM_CARTAZ f
    RIGHT JOIN EXE_SESSOES se
        ON f.id_filme = se.id_filme;
        
// Ex 77
SELECT s.id_sala, se.id_sessao
    FROM EXE_SALAS s
    LEFT JOIN EXE_SESSOES se
        ON s.id_sala = se.id_sala;
        
SELECT se.id_sessao, s.id_sala
    FROM EXE_SESSOES se
        RIGHT JOIN EXE_SALAS s
        ON se.id_sala = s.id_sala;
        
-- Análise de vendas
// Ex 78
SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, SUM(i.preco_cheio * (1 - desconto/100)) As faturamento_diario
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY');

// Ex 79
SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, COUNT(i.id_ingresso) As qntd_ingresso
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY');

// Ex 80
SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, tipo_ingresso, SUM(i.preco_cheio * (1 - desconto/100)) As faturamento_diario
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY'), tipo_ingresso;

// Ex 81
SELECT f.id_filme, TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento_diario
    FROM EXE_INGRESSOS i
        INNER JOIN EXE_SESSOES se
            ON i.id_sessao = se.id_sessao
        INNER JOIN EXE_FILMES_EM_CARTAZ f
            ON f.id_filme = se.id_filme
GROUP BY f.id_filme, TO_CHAR(i.data_venda, 'DD/MM/YYYY');

// Ex 82
SELECT f.id_filme, i.tipo_ingresso, COUNT(i.id_ingresso) As qntd_ingresso
    FROM EXE_INGRESSOS i
        INNER JOIN EXE_SESSOES se
            ON i.id_sessao = se.id_sessao
        INNER JOIN EXE_FILMES_EM_CARTAZ f
            ON f.id_filme = se.id_filme
        WHERE i.status_ingresso != 'CANCELADO'
GROUP BY f.id_filme, i.tipo_ingresso;

// Ex 83
SELECT s.id_sala, TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, SUM(preco_cheio *(1 - desconto/100)) As faturamento_diario
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_SALAS s
        ON se.id_sala = s.id_sala
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY s.id_sala, TO_CHAR(i.data_venda, 'DD/MM/YYYY');

// Ex Ex 84
SELECT c.cidade, COUNT(i.id_ingresso) As qntd_ingressos
    FROM EXE_CLIENTES c
    INNER JOIN EXE_INGRESSOS i
        ON c.id_cliente = i.id_cliente
GROUP BY c.cidade;

// Ex 85
SELECT c.cidade, ROUND(AVG(i.preco_cheio * (1 - desconto/100)), 2) As valor_medio
    FROM EXE_CLIENTES c
    INNER JOIN EXE_INGRESSOS i
        ON c.id_cliente = i.id_cliente
GROUP BY c.cidade;

-- ROLLUP --

// Ex 86
SELECT f.tipo, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento 
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
        ON f.id_filme = se.id_filme
GROUP BY ROLLUP(f.tipo);

// Ex 87
SELECT f.id_filme, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento 
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
        ON f.id_filme = se.id_filme
GROUP BY ROLLUP(f.id_filme);

// Ex 88
SELECT s.tipo_sala, s.id_sala, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_SALAS s
        ON s.id_sala = se.id_sala
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY ROLLUP(s.tipo_sala, s.id_sala);

// Ex 89
SELECT COUNT(i.id_ingresso) As qntd_ingresso, i.tipo_ingresso, i.forma_pagamento
    FROM EXE_INGRESSOS i
GROUP BY ROLLUP(i.tipo_ingresso, i.forma_pagamento);

// Ex 90
SELECT i.canal_venda, i.forma_pagamento, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY ROLLUP(i.canal_venda, i.forma_pagamento);

// Ex 91
SELECT f.classificacao, f.id_filme, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
        ON f.id_filme = se.id_filme
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY ROLLUP(f.classificacao, f.id_filme);

// Ex 92
SELECT f.tipo, f.titulo, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
        ON f.id_filme = se.id_filme
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY ROLLUP(f.tipo, f.titulo);

// Ex 93
SELECT s.nome_sala, f.titulo, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    INNER JOIN EXE_SESSOES se
        ON i.id_sessao = se.id_sessao
    INNER JOIN EXE_FILMES_EM_CARTAZ f
        ON f.id_filme = se.id_filme
    INNER JOIN EXE_SALAS s
        ON s.id_sala = se.id_sala
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY ROLLUP(s.nome_sala, f.titulo);

-- CTE --

// Ex 94
WITH calcula_cada_ingresso AS (
    SELECT i.id_ingresso, i.preco_cheio, i.desconto, i.preco_cheio *(1 - desconto/100) As valor_pago
    FROM EXE_INGRESSOS i
)
SELECT * FROM calcula_cada_ingresso;

// Ex 95
WITH faturamento_diario AS (
    SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY'), SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY')
) 
SELECT * FROM faturamento_diario 
    WHERE faturamento > 3900;
    
-- Integração --

// Ex 101
WITH faturamento_diario AS (
    SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, SUM(i.preco_cheio *(1 - desconto/100)) As faturamento
    FROM EXE_INGRESSOS i
    WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY')
), qntd_ingressos_dia AS (
        SELECT TO_CHAR(i.data_venda, 'DD/MM/YYYY') As data_venda, COUNT(i.id_ingresso) As qntd_ingresso
        FROM EXE_INGRESSOS i
        WHERE i.status_ingresso != 'CANCELADO'
GROUP BY TO_CHAR(i.data_venda, 'DD/MM/YYYY')
)
SELECT f.data_venda, f.faturamento, q.qntd_ingresso
    FROM faturamento_diario f
    INNER JOIN qntd_ingressos_dia q
        ON f.data_venda = q.data_venda;
        
COMMIT;