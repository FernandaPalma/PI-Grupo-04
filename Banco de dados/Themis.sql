CREATE DATABASE IF NOT EXISTS themis;
USE themis;

-- Tabela Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela Processos
CREATE TABLE IF NOT EXISTS Processos (
    processo_id INT AUTO_INCREMENT PRIMARY KEY,
    numero_processo VARCHAR(50) UNIQUE NOT NULL,
    cliente_id INT NOT NULL,
    valor_total DECIMAL(10, 2) DEFAULT 0.00,
    valor_pago DECIMAL(10, 2) DEFAULT 0.00,
    valor_a_pagar DECIMAL(10, 2) DEFAULT 0.00,
    pendencias DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- Tabela FasesProcesso
CREATE TABLE IF NOT EXISTS FasesProcesso (
    fase_id INT AUTO_INCREMENT PRIMARY KEY,
    processo_id INT NOT NULL,
    tipo_fase ENUM('Conhecimento', 'Execucao') NOT NULL,
    etapa VARCHAR(255) NOT NULL,
    data_conclusao DATE,
    FOREIGN KEY (processo_id) REFERENCES Processos(processo_id)
);

-- Tabela DocumentosProcesso
CREATE TABLE IF NOT EXISTS DocumentosProcesso (
    documento_id INT AUTO_INCREMENT PRIMARY KEY,
    processo_id INT NOT NULL,
    nome_documento VARCHAR(255) NOT NULL,
    caminho_arquivo VARCHAR(255), -- Para armazenar o caminho/URL do documento
    data_upload DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (processo_id) REFERENCES Processos(processo_id)
);

-- Tabela TransacoesFinanceiras
CREATE TABLE IF NOT EXISTS TransacoesFinanceiras (
    transacao_id INT AUTO_INCREMENT PRIMARY KEY,
    processo_id INT NOT NULL,
    data_transacao DATE NOT NULL,
    tipo_transacao ENUM('Recebimento', 'Pagamento', 'Custo') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(255),
    FOREIGN KEY (processo_id) REFERENCES Processos(processo_id)
);

-- Tabela Agendamentos
CREATE TABLE IF NOT EXISTS Agendamentos (
    agendamento_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT, -- Pode ser NULL se o agendamento for para um cliente novo/potencial
    nome_cliente_agendamento VARCHAR(255) NOT NULL, -- Para casos onde o cliente ainda não está cadastrado
    data_agendamento DATE NOT NULL,
    hora_agendamento TIME NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

DELIMITER //

CREATE PROCEDURE AdicionarAgendamento(
    IN p_nome_cliente_agendamento VARCHAR(255),
    IN p_data_agendamento DATE,
    IN p_hora_agendamento TIME,
    IN p_observacoes TEXT
)
BEGIN
    DECLARE v_cliente_id INT DEFAULT NULL;

    -- Tenta encontrar um cliente existente com o mesmo nome
    SELECT cliente_id INTO v_cliente_id FROM Clientes WHERE nome = p_nome_cliente_agendamento LIMIT 1;

    INSERT INTO Agendamentos (cliente_id, nome_cliente_agendamento, data_agendamento, hora_agendamento, observacoes)
    VALUES (v_cliente_id, p_nome_cliente_agendamento, p_data_agendamento, p_hora_agendamento, p_observacoes);

    SELECT 'Agendamento adicionado com sucesso!' AS Mensagem;
END //

DELIMITER ;

CALL AdicionarAgendamento('Novo Cliente Agendado', '2025-06-15', '10:00:00', 'Reunião inicial para caso de família');


DELIMITER //

CREATE PROCEDURE AtualizarSaldosProcesso(
    IN p_processo_id INT
)
BEGIN
    DECLARE v_valor_recebido DECIMAL(10, 2);
    DECLARE v_valor_total DECIMAL(10, 2);

    -- Soma o valor total recebido para o processo
    SELECT SUM(valor) INTO v_valor_recebido
    FROM TransacoesFinanceiras
    WHERE processo_id = p_processo_id AND tipo_transacao = 'Recebimento';

    -- Obtém o valor total do processo
    SELECT valor_total INTO v_valor_total
    FROM Processos
    WHERE processo_id = p_processo_id;

    -- Atualiza valor_pago (recebido), valor_a_pagar e pendencias
    UPDATE Processos
    SET
        valor_pago = IFNULL(v_valor_recebido, 0),
        valor_a_pagar = CASE
                            WHEN v_valor_total > IFNULL(v_valor_recebido, 0) THEN v_valor_total - IFNULL(v_valor_recebido, 0)
                            ELSE 0
                        END,
        pendencias = CASE
                        WHEN v_valor_total > IFNULL(v_valor_recebido, 0) AND v_valor_total - IFNULL(v_valor_recebido, 0) > 0 THEN v_valor_total - IFNULL(v_valor_recebido, 0)
                        ELSE 0
                     END
    WHERE processo_id = p_processo_id;

    SELECT 'Saldos financeiros atualizados com sucesso!' AS Mensagem;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_insert_transacao_financeira
AFTER INSERT ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    CALL AtualizarSaldosProcesso(NEW.processo_id);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_update_transacao_financeira
AFTER UPDATE ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    IF OLD.valor <> NEW.valor OR OLD.tipo_transacao <> NEW.tipo_transacao THEN
        CALL AtualizarSaldosProcesso(NEW.processo_id);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_delete_transacao_financeira
AFTER DELETE ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    CALL AtualizarSaldosProcesso(OLD.processo_id);
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER before_insert_agendamento
BEFORE INSERT ON Agendamentos
FOR EACH ROW
BEGIN
    -- Verifica se o cliente_id está nulo e se existe um nome de cliente para agendamento
    IF NEW.cliente_id IS NULL AND NEW.nome_cliente_agendamento IS NOT NULL THEN
        -- Tenta encontrar um cliente existente com o mesmo nome
        SELECT cliente_id INTO @existing_client_id FROM Clientes WHERE nome = NEW.nome_cliente_agendamento LIMIT 1;

        -- Se o cliente não existe, insere-o na tabela Clientes
        IF @existing_client_id IS NULL THEN
            INSERT INTO Clientes (nome) VALUES (NEW.nome_cliente_agendamento);
            SET NEW.cliente_id = LAST_INSERT_ID();
        ELSE
            -- Se o cliente já existe, usa o ID existente
            SET NEW.cliente_id = @existing_client_id;
        END IF;
    END IF;
END //

DELIMITER ;


-- Inserir Clientes
INSERT INTO Clientes (nome) VALUES ('João Silva');
INSERT INTO Clientes (nome) VALUES ('Maria Souza');
INSERT INTO Clientes (nome) VALUES ('Carlos Oliveira');
INSERT INTO Clientes (nome) VALUES ('Fernanda Lima');

-- Inserir Processos
INSERT INTO Processos (numero_processo, cliente_id, valor_total) VALUES ('0001234-56.2023.8.26.0001', 1, 5000.00);
INSERT INTO Processos (numero_processo, cliente_id, valor_total) VALUES ('0009876-12.2023.8.26.0001', 2, 2500.00);
INSERT INTO Processos (numero_processo, cliente_id, valor_total) VALUES ('0005678-34.2023.8.26.0001', 3, 1200.00);
INSERT INTO Processos (numero_processo, cliente_id, valor_total) VALUES ('0001122-78.2023.8.26.0001', 4, 3000.00);

-- Inserir Fases do Processo para o Processo 1
INSERT INTO FasesProcesso (processo_id, tipo_fase, etapa) VALUES (1, 'Conhecimento', 'Petição inicial');
INSERT INTO FasesProcesso (processo_id, tipo_fase, etapa) VALUES (1, 'Conhecimento', 'Defesa');
INSERT INTO FasesProcesso (processo_id, tipo_fase, etapa) VALUES (1, 'Execucao', 'Liquidação da sentença');

-- Inserir Documentos do Processo para o Processo 1
INSERT INTO DocumentosProcesso (processo_id, nome_documento, caminho_arquivo) VALUES (1, 'Petição Inicial', '/docs/processo1/peticao_inicial.pdf');

-- Inserir Transacoes Financeiras (o trigger AFTER INSERT irá atualizar os saldos do processo)
INSERT INTO TransacoesFinanceiras (processo_id, data_transacao, tipo_transacao, valor, descricao) VALUES (1, '2024-03-01', 'Recebimento', 5000.00, 'Pagamento integral');
INSERT INTO TransacoesFinanceiras (processo_id, data_transacao, tipo_transacao, valor, descricao) VALUES (2, '2024-04-15', 'Recebimento', 2500.00, 'Pagamento total');
INSERT INTO TransacoesFinanceiras (processo_id, data_transacao, tipo_transacao, valor, descricao) VALUES (3, '2024-05-10', 'Recebimento', 0.00, 'Nenhum pagamento inicial');
INSERT INTO TransacoesFinanceiras (processo_id, data_transacao, tipo_transacao, valor, descricao) VALUES (4, '2024-05-22', 'Recebimento', 0.00, 'Nenhum pagamento inicial');

-- Agendamentos
CALL AdicionarAgendamento('Novo Cliente Teste', '2025-06-20', '14:00:00', 'Consulta sobre divórcio');
-- Este agendamento tentará associar-se a um cliente existente ou criar um novo se 'João Silva' não existisse.
INSERT INTO Agendamentos (cliente_id, nome_cliente_agendamento, data_agendamento, hora_agendamento, observacoes)
VALUES (1, 'João Silva', '2025-07-01', '09:00:00', 'Revisão do processo');


SHOW TABLES;

SELECT * FROM Clientes;
SELECT * FROM Processos;
SELECT * FROM TransacoesFinanceiras;
SELECT * FROM Agendamentos;