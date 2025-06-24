-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para themis
CREATE DATABASE IF NOT EXISTS `themis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `themis`;

-- Copiando estrutura para procedure themis.AdicionarAgendamento
DELIMITER //
CREATE PROCEDURE `AdicionarAgendamento`(
    IN p_nome_cliente_agendamento VARCHAR(255),
    IN p_data_agendamento DATE,
    IN p_hora_agendamento TIME,
    IN p_observacoes TEXT
)
BEGIN
    DECLARE v_cliente_id INT DEFAULT NULL;
    SELECT cliente_id INTO v_cliente_id FROM Clientes WHERE nome = p_nome_cliente_agendamento LIMIT 1;
    INSERT INTO Agendamentos (cliente_id, nome_cliente_agendamento, data_agendamento, hora_agendamento, observacoes)
    VALUES (v_cliente_id, p_nome_cliente_agendamento, p_data_agendamento, p_hora_agendamento, p_observacoes);
    SELECT 'Agendamento adicionado com sucesso!' AS Mensagem;
END//
DELIMITER ;

-- Copiando estrutura para tabela themis.agendamentos
CREATE TABLE IF NOT EXISTS `agendamentos` (
  `agendamento_id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `nome_cliente_agendamento` varchar(255) NOT NULL,
  `data_agendamento` date NOT NULL,
  `hora_agendamento` time NOT NULL,
  `observacoes` text DEFAULT NULL,
  PRIMARY KEY (`agendamento_id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `agendamentos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.agendamentos: ~5 rows (aproximadamente)
INSERT INTO `agendamentos` (`agendamento_id`, `cliente_id`, `nome_cliente_agendamento`, `data_agendamento`, `hora_agendamento`, `observacoes`) VALUES
	(1, 1, 'João Silva', '2025-07-01', '09:00:00', 'Revisão do processo'),
	(2, 3, 'Carlos Oliveira', '2025-06-18', '11:20:00', 'NA'),
	(3, 4, 'Fernanda Lima', '2025-06-12', '16:35:00', 'NA'),
	(4, 1, 'João Silva', '2025-06-18', '20:58:00', 'NA'),
	(6, 1, 'João Silva', '2025-06-11', '20:26:00', 'tyu');

-- Copiando estrutura para procedure themis.AtualizarSaldosProcesso
DELIMITER //
CREATE PROCEDURE `AtualizarSaldosProcesso`(
    IN p_processo_id INT
)
BEGIN
    DECLARE v_valor_recebido DECIMAL(10, 2);
    DECLARE v_valor_total DECIMAL(10, 2);

    SELECT SUM(valor) INTO v_valor_recebido
    FROM TransacoesFinanceiras
    WHERE processo_id = p_processo_id AND tipo_transacao = 'Recebimento';

    SELECT valor_total INTO v_valor_total
    FROM Processos
    WHERE processo_id = p_processo_id;

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
END//
DELIMITER ;

-- Copiando estrutura para função themis.CalcularTotalPendenciasCliente
DELIMITER //
CREATE FUNCTION `CalcularTotalPendenciasCliente`(p_cliente_id INT) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
    DECLARE total_pendencias DECIMAL(10, 2);

    SELECT SUM(valor_a_pagar)
    INTO total_pendencias
    FROM Processos
    WHERE cliente_id = p_cliente_id;

    RETURN IFNULL(total_pendencias, 0.00);
END//
DELIMITER ;

-- Copiando estrutura para tabela themis.clientes
CREATE TABLE IF NOT EXISTS `clientes` (
  `cliente_id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `estado_civil` enum('Solteiro','Casado','Divorciado','Viúvo','União Estável') DEFAULT 'Solteiro',
  `data_cadastro` date DEFAULT curdate(),
  PRIMARY KEY (`cliente_id`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.clientes: ~4 rows (aproximadamente)
INSERT INTO `clientes` (`cliente_id`, `nome`, `cpf`, `telefone`, `email`, `endereco`, `estado_civil`, `data_cadastro`) VALUES
	(1, 'João Silva', '000.000.000-00', '(00) 00000-0000', 'joao.silva@email.com', 'Rua Exemplo, 123 - Centro, Araras-SP', 'Solteiro', '2025-06-16'),
	(2, 'Maria Souza', '111.111.111-11', '(11) 11111-1111', 'maria.souza@email.com', 'Rua B, 456', 'Solteiro', '2025-06-16'),
	(3, 'Carlos Oliveira', '222.222.222-22', '(22) 22222-2222', 'carlos.oliveira@email.com', 'Rua C, 789', 'Solteiro', '2025-06-16'),
	(4, 'Fernanda Lima', '333.333.333999', '(33) 33333-3333', 'fernanda.lima@email.com', 'Rua D, 134', 'Solteiro', '2025-06-16');

-- Copiando estrutura para tabela themis.documentosprocesso
CREATE TABLE IF NOT EXISTS `documentosprocesso` (
  `documento_id` int(11) NOT NULL AUTO_INCREMENT,
  `processo_id` int(11) NOT NULL,
  `nome_documento` varchar(255) NOT NULL,
  `caminho_arquivo` varchar(255) DEFAULT NULL,
  `data_upload` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`documento_id`),
  KEY `processo_id` (`processo_id`),
  CONSTRAINT `documentosprocesso_ibfk_1` FOREIGN KEY (`processo_id`) REFERENCES `processos` (`processo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.documentosprocesso: ~0 rows (aproximadamente)
INSERT INTO `documentosprocesso` (`documento_id`, `processo_id`, `nome_documento`, `caminho_arquivo`, `data_upload`) VALUES
	(1, 1, 'Petição Inicial', '/docs/processo1/peticao_inicial.pdf', '2025-06-16 17:45:43');

-- Copiando estrutura para tabela themis.fasesprocesso
CREATE TABLE IF NOT EXISTS `fasesprocesso` (
  `fase_id` int(11) NOT NULL AUTO_INCREMENT,
  `processo_id` int(11) NOT NULL,
  `tipo_fase` enum('Conhecimento','Execucao') NOT NULL,
  `etapa` varchar(255) NOT NULL,
  `data_conclusao` date DEFAULT NULL,
  PRIMARY KEY (`fase_id`),
  KEY `processo_id` (`processo_id`),
  CONSTRAINT `fasesprocesso_ibfk_1` FOREIGN KEY (`processo_id`) REFERENCES `processos` (`processo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.fasesprocesso: ~5 rows (aproximadamente)
INSERT INTO `fasesprocesso` (`fase_id`, `processo_id`, `tipo_fase`, `etapa`, `data_conclusao`) VALUES
	(1, 1, 'Conhecimento', 'Petição inicial', NULL),
	(2, 1, 'Conhecimento', 'Defesa', NULL),
	(3, 1, 'Execucao', 'Liquidação da sentença', NULL),
	(4, 5, 'Execucao', 'Petição inicial', NULL),
	(5, 5, 'Execucao', 'Liquidação da sentença', NULL);

-- Copiando estrutura para procedure themis.ListarProcessosETransacoesCliente
DELIMITER //
CREATE PROCEDURE `ListarProcessosETransacoesCliente`(IN p_cliente_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_processo_id INT;
    DECLARE v_numero_processo VARCHAR(50);
    DECLARE v_data_transacao DATE;
    DECLARE v_tipo_transacao ENUM('Recebimento', 'Pagamento', 'Custo');
    DECLARE v_valor DECIMAL(10, 2);
    DECLARE v_descricao VARCHAR(255);

    DECLARE cur_processos CURSOR FOR
        SELECT processo_id, numero_processo
        FROM Processos
        WHERE cliente_id = p_cliente_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_processos;

    processo_loop: LOOP
        FETCH cur_processos INTO v_processo_id, v_numero_processo;
        IF done THEN
            LEAVE processo_loop;
        END IF;

        SELECT CONCAT('--- Processo: ', v_numero_processo, ' ---') AS InfoProcesso;

        BEGIN
            DECLARE done_transacao INT DEFAULT FALSE;
            DECLARE cur_transacoes CURSOR FOR
                SELECT data_transacao, tipo_transacao, valor, descricao
                FROM TransacoesFinanceiras
                WHERE processo_id = v_processo_id
                ORDER BY data_transacao;

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_transacao = TRUE;

            OPEN cur_transacoes;

            transacao_loop: LOOP
                FETCH cur_transacoes INTO v_data_transacao, v_tipo_transacao, v_valor, v_descricao;
                IF done_transacao THEN
                    LEAVE transacao_loop;
                END IF;

                SELECT CONCAT('  Data: ', v_data_transacao, ', Tipo: ', v_tipo_transacao, ', Valor: R$', v_valor, ', Descrição: ', IFNULL(v_descricao, '')) AS InfoTransacao;
            END LOOP transacao_loop;

            CLOSE cur_transacoes;
        END;

    END LOOP processo_loop;

    CLOSE cur_processos;
END//
DELIMITER ;

-- Copiando estrutura para tabela themis.processos
CREATE TABLE IF NOT EXISTS `processos` (
  `processo_id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_processo` varchar(50) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `valor_total` decimal(10,2) DEFAULT 0.00,
  `valor_pago` decimal(10,2) DEFAULT 0.00,
  `valor_a_pagar` decimal(10,2) DEFAULT 0.00,
  `pendencias` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`processo_id`),
  UNIQUE KEY `numero_processo` (`numero_processo`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `processos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.processos: ~4 rows (aproximadamente)
INSERT INTO `processos` (`processo_id`, `numero_processo`, `cliente_id`, `valor_total`, `valor_pago`, `valor_a_pagar`, `pendencias`) VALUES
	(1, '0001234-56.2023.8.26.0001', 1, 5000.00, 0.00, 0.00, 0.00),
	(2, '0009876-12.2023.8.26.0001', 2, 2500.00, 0.00, 0.00, 0.00),
	(3, '0005678-34.2023.8.26.0001', 3, 1200.00, 0.00, 0.00, 0.00),
	(4, '0001122-78.2023.8.26.0001', 4, 3000.00, 0.00, 0.00, 0.00),
	(5, '0001234-56.2023.8.26.1371', 1, 4000.00, 0.00, 0.00, 0.00);

-- Copiando estrutura para tabela themis.transacoesfinanceiras
CREATE TABLE IF NOT EXISTS `transacoesfinanceiras` (
  `transacao_id` int(11) NOT NULL AUTO_INCREMENT,
  `processo_id` int(11) NOT NULL,
  `data_transacao` date NOT NULL,
  `tipo_transacao` enum('Recebimento','Pagamento','Custo') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`transacao_id`),
  KEY `processo_id` (`processo_id`),
  CONSTRAINT `transacoesfinanceiras_ibfk_1` FOREIGN KEY (`processo_id`) REFERENCES `processos` (`processo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.transacoesfinanceiras: ~4 rows (aproximadamente)
INSERT INTO `transacoesfinanceiras` (`transacao_id`, `processo_id`, `data_transacao`, `tipo_transacao`, `valor`, `descricao`) VALUES
	(1, 1, '2024-03-01', 'Recebimento', 5000.00, 'Pagamento integral'),
	(2, 2, '2024-04-15', 'Recebimento', 2500.00, 'Pagamento total'),
	(3, 3, '2024-05-10', 'Recebimento', 0.00, 'Nenhum pagamento inicial'),
	(4, 4, '2024-05-22', 'Recebimento', 0.00, 'Nenhum pagamento inicial');

-- Copiando estrutura para tabela themis.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `tipo` enum('Advogado','Administrador','Cliente') NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `cliente_id` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela themis.usuarios: ~2 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha_hash`, `tipo`, `cliente_id`) VALUES
	(1, 'João Silva', 'joao.silva@email.com', '$2y$12$ncRZa4/c46AXeMhCjy7tZueeMhhbxyZLE1KVzb4AFXU93g8tpfv92', 'Cliente', 1),
	(2, 'Maria Souza', 'maria.souza@email.com', '$2y$12$ncRZa4/c46AXeMhCjy7tZueeMhhbxyZLE1KVzb4AFXU93g8tpfv92', 'Administrador', 2);

-- Copiando estrutura para trigger themis.after_delete_transacao_financeira
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER after_delete_transacao_financeira
AFTER DELETE ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    CALL AtualizarSaldosProcesso(OLD.processo_id);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger themis.after_insert_transacao_financeira
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER after_insert_transacao_financeira
AFTER INSERT ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    CALL AtualizarSaldosProcesso(NEW.processo_id);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger themis.after_update_transacao_financeira
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER after_update_transacao_financeira
AFTER UPDATE ON TransacoesFinanceiras
FOR EACH ROW
BEGIN
    IF OLD.valor <> NEW.valor OR OLD.tipo_transacao <> NEW.tipo_transacao THEN
        CALL AtualizarSaldosProcesso(NEW.processo_id);
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger themis.before_insert_agendamento
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER before_insert_agendamento
BEFORE INSERT ON Agendamentos
FOR EACH ROW
BEGIN
    IF NEW.cliente_id IS NULL AND NEW.nome_cliente_agendamento IS NOT NULL THEN
        SELECT cliente_id INTO @existing_client_id FROM Clientes WHERE nome = NEW.nome_cliente_agendamento LIMIT 1;

        IF @existing_client_id IS NULL THEN
            INSERT INTO Clientes (nome, cpf, telefone, endereco) VALUES (NEW.nome_cliente_agendamento, '000.000.000-00', '', '');
            SET NEW.cliente_id = LAST_INSERT_ID();
        ELSE
            SET NEW.cliente_id = @existing_client_id;
        END IF;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
