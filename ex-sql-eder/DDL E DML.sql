-- ============================================================
-- CINEMA - DML
-- Oracle Database 19c+
-- Massa determinística e replicável
-- ============================================================
-- Este script pode ser executado novamente para reconstruir
-- exatamente a mesma massa de dados.
--
-- Ordem de carga:
--   1. exe_clientes
--   2. exe_salas
--   3. exe_filmes_em_cartaz
--   4. exe_sessoes
--   5. exe_ingressos
--
-- Volume esperado:
--   exe_clientes          = 30
--   exe_salas             = 7
--   exe_filmes_em_cartaz  = 12
--   exe_sessoes           = 840
--   exe_ingressos         = 3.360
--
-- Não utiliza geração aleatória ou data atual.
-- ============================================================

DROP TABLE exe_ingressos;
DROP TABLE exe_sessoes;
DROP TABLE exe_filmes_em_cartaz;
DROP TABLE exe_salas;
DROP TABLE exe_clientes;

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


-- ============================================================
-- 3. DML - FILMES EM CARTAZ
-- ============================================================

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