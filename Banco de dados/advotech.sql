-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS `advocaciadb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `advocaciadb`;


CREATE TABLE IF NOT EXISTS `agendamentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) DEFAULT NULL,
  `data_hora` datetime NOT NULL,
  `descricao` text DEFAULT NULL,
  `status` enum('Agendado','Realizado','Cancelado') DEFAULT 'Agendado',
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `agendamentos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `casos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) DEFAULT NULL,
  `descricao` text NOT NULL,
  `tipo_processo` varchar(255) NOT NULL,
  `status` enum('Em andamento','Concluído','Cancelado','Arquivado') DEFAULT 'Em andamento',
  `data_abertura` date NOT NULL,
  `data_conclusao` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `casos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `endereco` text DEFAULT NULL,
  `estado_civil` enum('Solteiro','Casado','Divorciado','Viúvo','União Estável') NOT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `documentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caso_id` int(11) DEFAULT NULL,
  `titulo` varchar(255) NOT NULL,
  `caminho_arquivo` varchar(500) NOT NULL,
  `tipo_documento` enum('Contrato','Procuração','Petição','Holerite','Contrato de Honorários','Outro') NOT NULL,
  `data_upload` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `caso_id` (`caso_id`),
  CONSTRAINT `documentos_ibfk_1` FOREIGN KEY (`caso_id`) REFERENCES `casos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `pagamentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `data_pagamento` date NOT NULL,
  `metodo` enum('Cartão','Boleto','PIX','Dinheiro') NOT NULL,
  `status` enum('Pago','Pendente','Cancelado') DEFAULT 'Pendente',
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `pagamentos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `relatoriosfinanceiros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `periodo` varchar(50) NOT NULL,
  `total_recebido` decimal(10,2) NOT NULL,
  `total_pendente` decimal(10,2) NOT NULL,
  `total_cancelado` decimal(10,2) NOT NULL,
  `data_geracao` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `tipo` enum('Advogado','Administrador') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20)
);


CREATE TABLE processo (
    id_processo INT AUTO_INCREMENT PRIMARY KEY,
    numero_processo VARCHAR(20) UNIQUE NOT NULL,
    id_cliente INT,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    valor_pago DECIMAL(10,2) DEFAULT 0.00,
    valor_a_pagar DECIMAL(10,2) AS (valor_total - valor_pago) STORED,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);


CREATE TABLE advogado (
    id_advogado INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    oab VARCHAR(20) UNIQUE
);


CREATE TABLE area (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);


CREATE TABLE advogado_processo (
    id_advogado INT,
    id_processo INT,
    PRIMARY KEY (id_advogado, id_processo),
    FOREIGN KEY (id_advogado) REFERENCES advogado(id_advogado),
    FOREIGN KEY (id_processo) REFERENCES processo(id_processo)
);


CREATE TABLE advogado_area (
    id_advogado INT,
    id_area INT,
    PRIMARY KEY (id_advogado, id_area),
    FOREIGN KEY (id_advogado) REFERENCES advogado(id_advogado),
    FOREIGN KEY (id_area) REFERENCES area(id_area)
);


CREATE TABLE fase_processo (
    id_fase INT AUTO_INCREMENT PRIMARY KEY,
    id_processo INT,
    descricao VARCHAR(100) NOT NULL,
    data_fase DATE,
    FOREIGN KEY (id_processo) REFERENCES processo(id_processo)
);


CREATE TABLE documento_processo (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_processo INT,
    tipo_documento VARCHAR(50),
    arquivo_path VARCHAR(255), 
    data_upload DATE,
    FOREIGN KEY (id_processo) REFERENCES processo(id_processo)
);


-- Usuário de teste (senha: senha123)
INSERT INTO usuarios (nome, email, senha_hash, tipo)
VALUES (
  'Usuário Teste',
  'teste@exemplo.com',
  '$2y$10$PiH9T2LKLv2XZgU94zV/N.G1HKPEtkSi0ubzR57H2KZ40aLz/FJkC',
  'Administrador'
);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

-- === ALTERAÇÕES PARA USUÁRIO DE TESTE (CLIENTE) ===

-- 1. Adicionar 'Cliente' ao enum da tabela usuarios
ALTER TABLE usuarios
MODIFY tipo ENUM('Advogado','Administrador','Cliente') NOT NULL;

-- 2. Adicionar coluna cliente_id na tabela usuarios
ALTER TABLE usuarios
ADD COLUMN cliente_id INT DEFAULT NULL,
ADD CONSTRAINT fk_usuario_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL;

-- 3. Inserir cliente de teste
INSERT INTO clientes (nome, cpf, email, telefone, endereco, estado_civil)
VALUES (
  'Cliente Teste',
  '123.456.789-00',
  'cliente@teste.com',
  '(11) 91234-5678',
  'Rua Exemplo, 123 - Centro - São Paulo/SP',
  'Solteiro'
);

-- 4. Inserir usuário vinculado ao cliente (senha: senha123)
-- ⚠️ Assume que o cliente inserido tem id = LAST_INSERT_ID()
INSERT INTO usuarios (nome, email, senha_hash, tipo, cliente_id)
VALUES (
  'Cliente Teste',
  'cliente@teste.com',
  '$2y$10$PiH9T2LKLv2XZgU94zV/N.G1HKPEtkSi0ubzR57H2KZ40aLz/FJkC',
  'Cliente',
  (SELECT id FROM clientes WHERE cpf = '123.456.789-00')
);