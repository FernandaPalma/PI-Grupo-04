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

-- Copiando dados para a tabela themis.agendamentos: ~3 rows (aproximadamente)
INSERT INTO `agendamentos` (`agendamento_id`, `cliente_id`, `nome_cliente_agendamento`, `data_agendamento`, `hora_agendamento`, `observacoes`) VALUES
	(1, 1, 'João Silva', '2025-07-01', '09:00:00', 'Revisão do processo'),
	(2, 3, 'Carlos Oliveira', '2025-06-18', '11:20:00', 'NA'),
	(3, 4, 'Fernanda Lima', '2025-06-12', '16:35:00', 'NA'),
	(4, 1, 'João Silva', '2025-06-18', '20:58:00', 'NA');

-- Copiando dados para a tabela themis.clientes: ~5 rows (aproximadamente)
INSERT INTO `clientes` (`cliente_id`, `nome`, `cpf`, `telefone`, `email`, `endereco`, `estado_civil`, `data_cadastro`) VALUES
	(1, 'João Silva', '000.000.000-00', '(00) 00000-0000', 'joao.silva@email.com', 'Rua Exemplo, 123 - Centro, Araras-SP', 'Solteiro', '2025-06-16'),
	(2, 'Maria Souza', '111.111.111-11', '(11) 11111-1111', 'maria.souza@email.com', 'Rua B, 456', 'Solteiro', '2025-06-16'),
	(3, 'Carlos Oliveira', '222.222.222-22', '(22) 22222-2222', 'carlos.oliveira@email.com', 'Rua C, 789', 'Solteiro', '2025-06-16'),
	(4, 'Fernanda Lima', '333.333.333999', '(33) 33333-3333', 'fernanda.lima@email.com', 'Rua D, 134', 'Solteiro', '2025-06-16'),
	(7, 'wefff', '11123333', '(19) 99999-9999', 'maria.souzasdadsdaa@email.com', 'h615h151', 'Viúvo', '2025-06-17');

-- Copiando dados para a tabela themis.documentosprocesso: ~0 rows (aproximadamente)
INSERT INTO `documentosprocesso` (`documento_id`, `processo_id`, `nome_documento`, `caminho_arquivo`, `data_upload`) VALUES
	(1, 1, 'Petição Inicial', '/docs/processo1/peticao_inicial.pdf', '2025-06-16 17:45:43');

-- Copiando dados para a tabela themis.fasesprocesso: ~5 rows (aproximadamente)
INSERT INTO `fasesprocesso` (`fase_id`, `processo_id`, `tipo_fase`, `etapa`, `data_conclusao`) VALUES
	(1, 1, 'Conhecimento', 'Petição inicial', NULL),
	(2, 1, 'Conhecimento', 'Defesa', NULL),
	(3, 1, 'Execucao', 'Liquidação da sentença', NULL),
	(4, 5, 'Execucao', 'Petição inicial', NULL),
	(5, 5, 'Execucao', 'Liquidação da sentença', NULL);

-- Copiando dados para a tabela themis.processos: ~4 rows (aproximadamente)
INSERT INTO `processos` (`processo_id`, `numero_processo`, `cliente_id`, `valor_total`, `valor_pago`, `valor_a_pagar`, `pendencias`) VALUES
	(1, '0001234-56.2023.8.26.0001', 1, 5000.00, 0.00, 0.00, 0.00),
	(2, '0009876-12.2023.8.26.0001', 2, 2500.00, 0.00, 0.00, 0.00),
	(3, '0005678-34.2023.8.26.0001', 3, 1200.00, 0.00, 0.00, 0.00),
	(4, '0001122-78.2023.8.26.0001', 4, 3000.00, 0.00, 0.00, 0.00),
	(5, '0001234-56.2023.8.26.1371', 1, 4000.00, 0.00, 0.00, 0.00);

-- Copiando dados para a tabela themis.transacoesfinanceiras: ~4 rows (aproximadamente)
INSERT INTO `transacoesfinanceiras` (`transacao_id`, `processo_id`, `data_transacao`, `tipo_transacao`, `valor`, `descricao`) VALUES
	(1, 1, '2024-03-01', 'Recebimento', 5000.00, 'Pagamento integral'),
	(2, 2, '2024-04-15', 'Recebimento', 2500.00, 'Pagamento total'),
	(3, 3, '2024-05-10', 'Recebimento', 0.00, 'Nenhum pagamento inicial'),
	(4, 4, '2024-05-22', 'Recebimento', 0.00, 'Nenhum pagamento inicial');

-- Copiando dados para a tabela themis.usuarios: ~2 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha_hash`, `tipo`, `cliente_id`) VALUES
	(1, 'João Silva', 'joao.silva@email.com', '$2y$12$ncRZa4/c46AXeMhCjy7tZueeMhhbxyZLE1KVzb4AFXU93g8tpfv92', 'Cliente', 1),
	(2, 'Maria Souza', 'maria.souza@email.com', '$2y$12$ncRZa4/c46AXeMhCjy7tZueeMhhbxyZLE1KVzb4AFXU93g8tpfv92', 'Administrador', 2);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
