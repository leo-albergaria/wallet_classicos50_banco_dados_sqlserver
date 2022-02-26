
-- Criar DataBase Aulas50
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Aulas50')
    BEGIN
        CREATE DATABASE Aulas50;
    END
GO

-- Escolher a database para trabalhar.
USE Aulas50;
GO

-- Criar a tabela de pessoa física
IF NOT EXISTS (SELECT * FROM sys.tables t WHERE t.name = 'PessoaFisica')
    BEGIN
        CREATE TABLE PessoaFisica (
            Id          INT             IDENTITY(1,1) PRIMARY KEY,
            Nome        VARCHAR(50)     NOT NULL,
            Sobrenome   VARCHAR(100)    NOT NULL,
            Endereco    VARCHAR(MAX)    NULL,
            CPF         VARCHAR(15)     NOT NULL
        );
    END
GO

-- Criar a tabela de Conta Corrente
IF NOT EXISTS (SELECT * FROM sys.tables t WHERE t.name = 'ContaCorrente')
    BEGIN
        CREATE TABLE ContaCorrente (
            Id              INT         IDENTITY(1,1) PRIMARY KEY,
            NumeroDaConta   INT         NOT NULL,
            Saldo           FLOAT       NOT NULL
        );
    END
GO

-- Criar a tabela de Transações
IF NOT EXISTS (SELECT * FROM sys.tables t WHERE t.name = 'Transacoes')
    BEGIN
        CREATE TABLE Transacoes (
            Id          INT             IDENTITY(1,1) PRIMARY KEY,
            Valor       FLOAT           NOT NULL,
            Descricao   VARCHAR(MAX)    NULL
        );
    END
GO

-- Inserir as chaves estrangeiras na tabela de pessoa física
IF NOT EXISTS( SELECT * FROM Aulas50.INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'PessoaFisica' 
            AND  COLUMN_NAME = 'IdContaCorrente')
    BEGIN
        ALTER TABLE PessoaFisica 
        ADD IdContaCorrente INT NOT NULL,
        FOREIGN KEY (IdContaCorrente) REFERENCES ContaCorrente(Id)
    END
GO    

-- Inserir as chaves estrangeiras na tabela de transações
IF NOT EXISTS( SELECT * FROM Aulas50.INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'Transacoes' 
            AND  COLUMN_NAME = 'ContaOrigem')
    BEGIN
        ALTER TABLE Transacoes
        ADD ContaOrigem INT NOT NULL,
            ContaDestino INT NOT NULL,
        FOREIGN KEY (ContaOrigem) REFERENCES ContaCorrente(Id),
        FOREIGN KEY (ContaDestino) REFERENCES ContaCorrente(Id)
    END
GO    

-- Inserir conta corrente.
INSERT 
    INTO ContaCorrente 
        (NumeroDaConta, Saldo) 
    VALUES 
        (25, 0),
        (57, 0),
        (35, 0),
        (55, 0)
GO

-- Inserir pessoa fisica - Inserir conta corrente antes.
INSERT
    INTO PessoaFisica
        (Nome, Sobrenome, Endereco, CPF, IdContaCorrente)
    VALUES 
        ('Vitor', 'Norton', 'Av.Mofarrej','000.000.000-00', 1),
        ('Hugo', 'Mello', 'Rua C','000.000.000-00', 2),
        ('Pedro', 'Alvares', 'Rua dos Portos, 6','000.000.000-00', 3),
        ('Cabral', 'dos Santos', 'Rua Açores, 43','000.000.000-00', 4)
GO     

-- Inserir conta transações.
INSERT 
    INTO Transacoes
        (Valor, Descricao, ContaOrigem, ContaDestino) 
    VALUES 
        (250, 'Pagamento de Conta de Luz', 1, 2),
        (250, 'Pagamento de Aluguel', 3, 1),
        (250, 'Pagamento de Carro', 3, 2),
        (250, 'Pagamento de Escola', 2, 1),
        (250, 'Pagamento de Saida', 2, 3);        
GO

-- Visualizar as informações nas tabelas.
SELECT * from ContaCorrente;
SELECT * from PessoaFisica;
SELECT * FROM Transacoes;

-- Para deletar todoas as informações da Tabela.
DELETE FROM PessoaFisica
-- Para deletar o que for necessário dentro da expressão.
-- DELETE FROM PessoaFisica WHERE (Expressao)

-- Para zerar o contador automático da chave primária.
DBCC CHECKIDENT('[PessoaFisica]', RESEED, 0)

-- Inserir as idade na tabela
IF NOT EXISTS( SELECT * FROM Aulas50.INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'PessoaFisica' 
            AND  COLUMN_NAME = 'Idade')
    BEGIN
        ALTER TABLE PessoaFisica
        ADD Idade INT NULL -- ADD Idade INT DEFAULT 0 NOT NULL
    END
GO 

-- Para efetuar alteração de Dados.
UPDATE PessoaFisica 
    SET Idade = 18
    WHERE Id = 4;

SELECT * FROM PessoaFisica 




