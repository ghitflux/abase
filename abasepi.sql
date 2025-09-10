-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 10/09/2025 às 14:39
-- Versão do servidor: 10.5.27-MariaDB
-- Versão do PHP: 8.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `abasepi`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agente`
--

CREATE TABLE `agente` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(8) NOT NULL COMMENT 'Ex.: AGT001',
  `nome` varchar(180) NOT NULL,
  `loja_id` bigint(20) UNSIGNED DEFAULT NULL,
  `loja` varchar(120) NOT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `agente`
--

INSERT INTO `agente` (`id`, `codigo`, `nome`, `loja_id`, `loja`, `status`, `created_at`, `updated_at`) VALUES
(1, 'AGT001', 'Maria Santos Silva', 1, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-19 00:13:29'),
(2, 'AGT002', 'João Pereira Costa', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(3, 'AGT003', 'Ana Costa Lima', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(4, 'AGT004', 'Carlos Silva Rocha', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(5, 'AGT005', 'Francisca Oliveira', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(6, 'AGT006', 'Roberto Lima Santos', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(7, 'AGT007', 'Luciana Pereira', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(8, 'AGT008', 'Antonio José Barbosa', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(9, 'AGT009', 'Silvia Regina Moura', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(10, 'AGT010', 'Pedro Almeida Dias', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(11, 'AGT011', 'Carmen Lucia Ferreira', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(12, 'AGT012', 'José Carlos Nascimento', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(13, 'AGT013', 'Mariana Sousa Costa', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(14, 'AGT014', 'Ricardo Mendes Lima', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57'),
(15, 'AGT015', 'Patricia Santos Rocha', NULL, 'ABASEPI', 'ativo', '2025-08-18 23:41:57', '2025-08-18 23:41:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `auditoria`
--

CREATE TABLE `auditoria` (
  `id` int(11) NOT NULL,
  `data_hora` datetime NOT NULL,
  `usuario` varchar(100) NOT NULL,
  `acao` enum('Login','Logout','Criar','Editar','Excluir','Consultar','Exportar') NOT NULL,
  `objeto` varchar(100) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `detalhes` text DEFAULT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `auditoria`
--

INSERT INTO `auditoria` (`id`, `data_hora`, `usuario`, `acao`, `objeto`, `ip`, `detalhes`, `criado_em`) VALUES
(1, '2024-01-24 14:30:25', 'João Silva', 'Login', 'Sistema', '192.168.1.100', 'Login realizado com sucesso', '2025-08-19 00:06:30'),
(2, '2024-01-24 14:35:12', 'João Silva', 'Criar', 'Cliente', '192.168.1.100', 'Cliente \"Maria Santos\" criado', '2025-08-19 00:06:30'),
(3, '2024-01-24 14:40:08', 'Maria Santos', 'Editar', 'Agente', '192.168.1.105', 'Agente \"Pedro Costa\" editado', '2025-08-19 00:06:30'),
(4, '2024-01-24 14:45:33', 'Pedro Costa', 'Excluir', 'Convênio', '192.168.1.110', 'Convênio \"TESTE\" excluído', '2025-08-19 00:06:30'),
(5, '2024-01-24 14:50:17', 'Ana Oliveira', 'Consultar', 'Relatório', '192.168.1.115', 'Relatório de produção consultado', '2025-08-19 00:06:30'),
(6, '2024-01-24 14:55:44', 'Carlos Lima', 'Exportar', 'Dados', '192.168.1.120', 'Dados de clientes exportados', '2025-08-19 00:06:30'),
(7, '2024-01-24 15:00:21', 'João Silva', 'Logout', 'Sistema', '192.168.1.100', 'Logout realizado', '2025-08-19 00:06:30');

-- --------------------------------------------------------

--
-- Estrutura para tabela `audit_log`
--

CREATE TABLE `audit_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ts` datetime NOT NULL DEFAULT current_timestamp(),
  `action` varchar(30) NOT NULL,
  `object_type` varchar(60) DEFAULT NULL,
  `object_id` bigint(20) DEFAULT NULL,
  `object_label` varchar(255) DEFAULT NULL,
  `actor_pessoa_id` bigint(20) DEFAULT NULL,
  `actor_name` varchar(180) DEFAULT NULL,
  `actor_email` varchar(180) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `details` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `audit_log`
--

INSERT INTO `audit_log` (`id`, `ts`, `action`, `object_type`, `object_id`, `object_label`, `actor_pessoa_id`, `actor_name`, `actor_email`, `ip`, `user_agent`, `details`) VALUES
(1, '2025-08-22 20:43:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(2, '2025-08-22 20:43:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(3, '2025-08-22 20:43:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(4, '2025-08-22 20:43:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(5, '2025-08-22 20:44:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(6, '2025-08-22 20:44:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(7, '2025-08-22 20:45:04', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(8, '2025-08-22 20:45:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(9, '2025-08-22 20:46:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(10, '2025-08-22 20:46:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(11, '2025-08-22 20:47:17', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(12, '2025-08-22 20:47:17', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(13, '2025-08-22 20:47:20', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(14, '2025-08-22 20:47:20', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(15, '2025-08-22 20:47:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(16, '2025-08-22 20:47:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(17, '2025-08-22 20:48:33', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(18, '2025-08-22 20:48:33', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(19, '2025-08-22 20:48:33', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(20, '2025-08-22 20:50:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(21, '2025-08-22 20:51:17', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(22, '2025-08-22 20:51:17', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(23, '2025-08-22 20:51:17', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(24, '2025-08-22 20:51:21', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(25, '2025-08-22 20:51:21', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(26, '2025-08-22 20:51:21', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=logout\"}'),
(27, '2025-08-22 20:51:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(28, '2025-08-22 20:51:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(29, '2025-08-22 20:51:27', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(30, '2025-08-22 20:51:27', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(31, '2025-08-22 20:51:27', 'Criar', 'pessoa', NULL, NULL, 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(32, '2025-08-22 20:52:58', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(33, '2025-08-22 20:52:58', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(34, '2025-08-22 20:52:58', 'Criar', 'pessoa', NULL, NULL, 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(35, '2025-08-22 20:53:03', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(36, '2025-08-22 20:53:03', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(37, '2025-08-22 20:53:11', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(38, '2025-08-22 20:53:11', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(39, '2025-08-22 20:53:11', 'Criar', 'pessoa', NULL, NULL, 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(40, '2025-08-22 20:55:30', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(41, '2025-08-22 20:55:30', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(42, '2025-08-22 20:55:30', 'Criar', 'pessoa', NULL, NULL, 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(43, '2025-08-22 20:55:37', 'Login', 'Sistema', NULL, 'Login no painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(44, '2025-08-22 20:55:37', 'Logout', 'Sistema', NULL, 'Logout do painel', 7, 'fabiano gomes', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(45, '2025-08-22 20:56:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(46, '2025-08-22 20:56:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(47, '2025-08-22 20:57:38', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(48, '2025-08-22 20:57:38', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(49, '2025-08-22 20:57:38', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(50, '2025-08-22 20:57:41', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(51, '2025-08-22 20:57:41', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(52, '2025-08-22 20:57:41', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=logout\"}'),
(53, '2025-08-22 20:57:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(54, '2025-08-22 20:57:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(55, '2025-08-22 20:57:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(56, '2025-08-22 20:57:55', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(57, '2025-08-22 20:57:55', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(58, '2025-08-22 20:57:55', 'Criar', 'pessoa', NULL, NULL, 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(59, '2025-08-22 20:58:14', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(60, '2025-08-22 20:58:14', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(61, '2025-08-22 20:58:16', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(62, '2025-08-22 20:58:16', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(63, '2025-08-22 20:58:16', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(64, '2025-08-22 20:58:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(65, '2025-08-22 20:58:49', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(66, '2025-08-22 20:58:49', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(67, '2025-08-22 20:58:49', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(68, '2025-08-22 20:58:51', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(69, '2025-08-22 20:58:51', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(70, '2025-08-22 20:58:51', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=logout\"}'),
(71, '2025-08-22 20:58:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(72, '2025-08-22 20:59:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(73, '2025-08-22 20:59:00', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(74, '2025-08-22 20:59:00', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(75, '2025-08-22 20:59:00', 'Criar', 'pessoa', NULL, NULL, 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(76, '2025-08-22 20:59:04', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(77, '2025-08-22 20:59:04', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(78, '2025-08-22 20:59:04', 'Criar', 'pessoa', NULL, NULL, 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=docs&cpfCnpj=067.247.623-16\"}'),
(79, '2025-08-22 21:00:00', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(80, '2025-08-22 21:00:00', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(81, '2025-08-22 21:00:00', 'Criar', 'pessoa', NULL, NULL, 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(82, '2025-08-22 21:00:03', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(83, '2025-08-22 21:00:03', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(84, '2025-08-22 21:00:03', 'Criar', 'pessoa', NULL, NULL, 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=logout\"}'),
(85, '2025-08-22 21:00:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(86, '2025-08-22 21:00:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(87, '2025-08-22 21:00:14', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(88, '2025-08-22 21:00:14', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(89, '2025-08-22 21:00:14', 'Criar', 'pessoa', NULL, NULL, 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(90, '2025-08-22 21:01:54', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(91, '2025-08-22 21:01:54', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(92, '2025-08-22 21:01:54', 'Criar', 'pessoa', NULL, NULL, 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=save\"}'),
(93, '2025-08-22 21:02:22', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(94, '2025-08-22 21:02:22', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(95, '2025-08-22 21:02:22', 'Criar', 'pessoa', NULL, NULL, 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php?action=logout\"}'),
(96, '2025-08-22 21:02:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(97, '2025-08-22 21:02:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(98, '2025-08-22 21:02:29', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(99, '2025-08-22 21:02:29', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(100, '2025-08-22 21:02:29', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(101, '2025-08-22 21:02:54', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(102, '2025-08-22 21:02:54', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(103, '2025-08-22 21:02:54', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(104, '2025-08-22 21:03:48', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(105, '2025-08-22 21:03:48', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(106, '2025-08-22 21:03:48', 'Criar', 'pessoa', NULL, NULL, 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '{\"rota\":\"/abasepi/abase_web_sistem/cadastro.php\"}'),
(107, '2025-08-22 21:07:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.15.51', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(108, '2025-08-22 21:07:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(109, '2025-08-22 21:07:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(110, '2025-08-22 21:07:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(111, '2025-08-22 21:09:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(112, '2025-08-22 21:10:03', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(113, '2025-08-22 21:10:03', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(114, '2025-08-22 21:13:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(115, '2025-08-22 21:13:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(116, '2025-08-22 21:15:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '159.100.17.78', 'Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.166 Safari/537.36', NULL),
(117, '2025-08-22 21:23:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(118, '2025-08-22 21:23:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(119, '2025-08-22 21:23:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(120, '2025-08-22 21:23:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(121, '2025-08-22 21:24:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(122, '2025-08-22 21:24:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(123, '2025-08-22 21:25:47', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.90.62.229', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', NULL),
(124, '2025-08-22 21:26:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(125, '2025-08-22 21:26:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(126, '2025-08-22 21:26:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(127, '2025-08-22 21:26:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(128, '2025-08-22 21:26:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(129, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(130, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(131, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(132, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(133, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(134, '2025-08-22 21:26:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(135, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(136, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(137, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(138, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(139, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(140, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(141, '2025-08-22 21:26:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(142, '2025-08-22 21:26:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.196.39.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(143, '2025-08-22 21:36:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(144, '2025-08-22 21:36:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(145, '2025-08-22 21:36:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(146, '2025-08-22 21:36:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(147, '2025-08-22 21:37:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(148, '2025-08-22 21:37:09', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(149, '2025-08-22 21:37:09', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(150, '2025-08-22 21:40:15', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(151, '2025-08-22 21:40:15', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(152, '2025-08-22 21:40:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(153, '2025-08-22 21:40:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(154, '2025-08-22 21:40:26', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(155, '2025-08-22 21:40:26', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(156, '2025-08-22 21:41:43', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(157, '2025-08-22 21:41:43', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(158, '2025-08-22 21:41:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(159, '2025-08-22 21:41:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(160, '2025-08-22 21:41:52', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(161, '2025-08-22 21:41:52', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(162, '2025-08-22 21:41:57', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(163, '2025-08-22 21:41:57', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(164, '2025-08-22 21:41:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(165, '2025-08-22 21:42:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(166, '2025-08-22 21:42:05', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(167, '2025-08-22 21:42:05', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(168, '2025-08-22 21:42:09', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(169, '2025-08-22 21:42:09', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(170, '2025-08-22 21:42:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(171, '2025-08-22 21:42:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(172, '2025-08-22 21:45:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(173, '2025-08-22 21:45:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(174, '2025-08-22 21:45:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(175, '2025-08-22 21:45:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(176, '2025-08-22 21:45:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(177, '2025-08-22 21:45:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(178, '2025-08-22 21:50:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(179, '2025-08-22 21:50:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(180, '2025-08-22 21:50:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(181, '2025-08-22 21:50:48', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(182, '2025-08-22 21:50:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(183, '2025-08-22 21:50:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(184, '2025-08-22 21:51:22', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(185, '2025-08-22 21:51:22', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(186, '2025-08-22 21:51:31', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(187, '2025-08-22 21:51:31', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(188, '2025-08-22 21:51:42', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(189, '2025-08-22 21:51:42', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(190, '2025-08-22 21:54:33', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(191, '2025-08-22 21:54:33', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(192, '2025-08-22 21:55:58', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(193, '2025-08-22 21:55:58', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(194, '2025-08-22 21:57:07', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(195, '2025-08-22 21:57:07', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(196, '2025-08-22 21:57:27', 'Login', 'Sistema', NULL, 'Login no painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(197, '2025-08-22 21:57:27', 'Logout', 'Sistema', NULL, 'Logout do painel', 11, 'Helcio Helcio', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(198, '2025-08-22 21:57:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(199, '2025-08-22 21:57:51', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(200, '2025-08-22 21:57:51', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(201, '2025-08-22 21:58:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(202, '2025-08-22 22:33:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(203, '2025-08-22 22:33:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(204, '2025-08-22 22:34:35', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(205, '2025-08-22 22:34:35', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(206, '2025-08-22 22:50:36', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(207, '2025-08-22 22:50:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(208, '2025-08-22 22:51:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '187.68.191.36', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(209, '2025-08-22 23:03:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '18.215.234.53', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36', NULL);
INSERT INTO `audit_log` (`id`, `ts`, `action`, `object_type`, `object_id`, `object_label`, `actor_pessoa_id`, `actor_name`, `actor_email`, `ip`, `user_agent`, `details`) VALUES
(210, '2025-08-22 23:16:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.69', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', NULL),
(211, '2025-08-22 23:17:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Mobile Safari/537.36', NULL),
(212, '2025-08-22 23:22:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.71', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(213, '2025-08-22 23:22:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(214, '2025-08-22 23:48:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.207.205.202', 'Mozilla/5.0 (Windows NT 9.9; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.2440.88 Safari/537.36', NULL),
(215, '2025-08-22 23:59:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', NULL),
(216, '2025-08-23 00:02:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.157.188.74', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(217, '2025-08-23 00:04:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(218, '2025-08-23 00:04:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(219, '2025-08-23 00:06:44', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(220, '2025-08-23 00:06:44', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(221, '2025-08-23 00:07:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(222, '2025-08-23 00:11:52', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '20.105.137.134', 'curl/8.6.0', NULL),
(223, '2025-08-23 00:24:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(224, '2025-08-23 00:39:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', NULL),
(225, '2025-08-23 00:51:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(226, '2025-08-23 01:02:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(227, '2025-08-23 01:02:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(228, '2025-08-23 01:02:47', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(229, '2025-08-23 01:02:47', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(230, '2025-08-23 01:03:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.167.232.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(231, '2025-08-23 01:07:28', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(232, '2025-08-23 01:07:28', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(233, '2025-08-23 01:07:28', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(234, '2025-08-23 01:07:34', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(235, '2025-08-23 01:29:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '8.219.229.53', 'Go-http-client/1.1', NULL),
(236, '2025-08-23 01:29:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '8.209.96.245', 'Go-http-client/1.1', NULL),
(237, '2025-08-23 01:29:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '212.193.185.207', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36', NULL),
(238, '2025-08-23 01:34:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(239, '2025-08-23 01:34:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(240, '2025-08-23 01:42:45', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(241, '2025-08-23 01:42:45', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(242, '2025-08-23 02:02:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.155.140.157', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(243, '2025-08-23 02:02:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(244, '2025-08-23 02:02:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(245, '2025-08-23 02:02:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(246, '2025-08-23 02:02:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(247, '2025-08-23 02:02:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(248, '2025-08-23 02:03:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(249, '2025-08-23 02:03:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(250, '2025-08-23 02:03:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(251, '2025-08-23 02:03:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(252, '2025-08-23 02:03:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(253, '2025-08-23 02:03:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(254, '2025-08-23 02:03:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(255, '2025-08-23 02:03:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(256, '2025-08-23 02:03:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(257, '2025-08-23 02:03:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(258, '2025-08-23 02:03:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(259, '2025-08-23 02:03:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(260, '2025-08-23 02:03:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(261, '2025-08-23 02:03:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.85.164.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(262, '2025-08-23 02:31:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_7_10 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/137.0.7151.107 Mobile/15E148 Safari/604.1', NULL),
(263, '2025-08-23 02:38:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '95.177.180.82', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1', NULL),
(264, '2025-08-23 02:46:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '119.45.20.16', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(265, '2025-08-23 03:00:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(266, '2025-08-23 03:00:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(267, '2025-08-23 03:01:05', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(268, '2025-08-23 03:01:05', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(269, '2025-08-23 03:01:45', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(270, '2025-08-23 03:01:45', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(271, '2025-08-23 03:03:31', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(272, '2025-08-23 03:03:31', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(273, '2025-08-23 03:36:29', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(274, '2025-08-23 03:36:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(275, '2025-08-23 05:49:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '122.51.104.231', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(276, '2025-08-23 09:04:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.207.205.202', 'Mozilla/5.0 (Windows NT 7.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.2658.88 Safari/537.36', NULL),
(277, '2025-08-23 09:49:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(278, '2025-08-23 09:50:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(279, '2025-08-23 09:51:33', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(280, '2025-08-23 09:51:33', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(281, '2025-08-23 09:53:57', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(282, '2025-08-23 09:53:57', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(283, '2025-08-23 09:58:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.216.149.106', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(284, '2025-08-23 10:09:39', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(285, '2025-08-23 10:09:39', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(286, '2025-08-23 10:13:55', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(287, '2025-08-23 10:13:55', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(288, '2025-08-23 10:14:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(289, '2025-08-23 10:14:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(290, '2025-08-23 10:17:45', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(291, '2025-08-23 10:17:45', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(292, '2025-08-23 10:47:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(293, '2025-08-23 10:47:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(294, '2025-08-23 10:52:09', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(295, '2025-08-23 10:52:09', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(296, '2025-08-23 10:52:21', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(297, '2025-08-23 10:52:21', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(298, '2025-08-23 11:18:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.212.238.67', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(299, '2025-08-23 11:18:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.212.238.67', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(300, '2025-08-23 11:25:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '193.46.255.83', 'libwww-perl/6.79', NULL),
(301, '2025-08-23 11:25:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '193.46.255.83', 'libwww-perl/6.79', NULL),
(302, '2025-08-23 11:54:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(303, '2025-08-23 11:54:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(304, '2025-08-23 12:00:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.51.178.45', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(305, '2025-08-23 12:02:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.252.18.37', 'Go-http-client/1.1', NULL),
(306, '2025-08-23 12:05:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '60.188.57.0', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(307, '2025-08-23 12:08:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(308, '2025-08-23 12:08:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(309, '2025-08-23 12:10:59', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(310, '2025-08-23 12:10:59', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(311, '2025-08-23 12:35:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.253.252.217', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/138.0.7204.156 Mobile/15E148 Safari/604.1', NULL),
(312, '2025-08-23 12:52:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '84.39.225.173', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/138.0.7204.156 Mobile/15E148 Safari/604.1', NULL),
(313, '2025-08-23 13:46:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(314, '2025-08-23 13:46:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(315, '2025-08-23 15:03:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.130.16.212', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(316, '2025-08-23 15:25:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '182.42.111.156', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(317, '2025-08-23 15:36:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '68.183.11.25', 'Mozilla/5.0 zgrab/0.x', NULL),
(318, '2025-08-23 15:53:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.59', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(319, '2025-08-23 16:49:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '13.95.133.245', 'curl/8.6.0', NULL),
(320, '2025-08-23 18:03:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.119.119', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(321, '2025-08-23 18:30:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '114.117.233.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(322, '2025-08-23 20:45:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.49.218.164', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', NULL),
(323, '2025-08-23 21:07:16', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '170.106.113.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(324, '2025-08-23 21:33:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(325, '2025-08-23 21:33:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(326, '2025-08-23 21:39:08', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(327, '2025-08-23 21:39:08', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(328, '2025-08-23 21:56:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(329, '2025-08-23 21:56:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(330, '2025-08-23 22:26:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.255.10.32', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(331, '2025-08-23 22:26:47', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(332, '2025-08-23 22:26:47', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(333, '2025-08-23 22:29:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.207.205.202', 'Mozilla/5.0 (Windows NT 10.4; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.2908.88 Safari/537.36', NULL),
(334, '2025-08-23 22:29:41', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(335, '2025-08-23 22:29:41', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(336, '2025-08-23 22:34:15', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(337, '2025-08-23 22:34:15', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(338, '2025-08-23 22:37:04', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(339, '2025-08-23 22:37:04', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(340, '2025-08-23 22:41:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '176.53.220.209', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', NULL),
(341, '2025-08-23 23:01:19', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(342, '2025-08-23 23:01:19', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(343, '2025-08-23 23:05:45', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(344, '2025-08-23 23:05:45', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(345, '2025-08-23 23:12:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(346, '2025-08-23 23:12:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(347, '2025-08-23 23:13:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(348, '2025-08-23 23:13:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(349, '2025-08-24 00:01:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '170.106.193.108', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(350, '2025-08-24 00:06:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Dalvik/2.1.0 (Linux; U; Android 9.0; ZTE BA520 Build/MRA58K)', NULL),
(351, '2025-08-24 01:01:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '159.65.147.30', 'Mozilla/5.0 (X11; Linux x86_64; rv:139.0) Gecko/20100101 Firefox/139.0', NULL),
(352, '2025-08-24 01:03:53', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.135.134.127', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(353, '2025-08-24 01:18:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '153.0.50.77', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(354, '2025-08-24 01:21:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '220.167.232.124', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(355, '2025-08-24 01:25:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.173.132.50', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(356, '2025-08-24 01:25:37', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '61.167.255.99', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(357, '2025-08-24 01:27:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '61.166.210.243', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(358, '2025-08-24 01:28:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '222.94.32.199', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(359, '2025-08-24 01:28:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '223.199.174.252', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(360, '2025-08-24 01:28:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '122.96.28.152', 'Mozilla/5.077692140 Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko', NULL),
(361, '2025-08-24 01:29:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.160.194.84', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(362, '2025-08-24 01:30:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '60.13.7.94', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(363, '2025-08-24 01:30:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '123.245.84.42', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(364, '2025-08-24 01:31:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '171.120.159.70', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(365, '2025-08-24 01:31:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '42.63.51.71', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(366, '2025-08-24 01:31:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '221.207.35.124', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(367, '2025-08-24 01:31:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.31.106.140', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(368, '2025-08-24 01:31:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '175.19.75.142', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(369, '2025-08-24 01:31:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '150.255.52.61', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(370, '2025-08-24 01:32:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.191.28.208', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(371, '2025-08-24 01:32:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '42.63.51.199', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(372, '2025-08-24 01:33:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '42.92.120.90', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(373, '2025-08-24 01:33:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '60.13.138.48', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(374, '2025-08-24 01:33:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.31.106.179', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(375, '2025-08-24 01:33:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.172.249.226', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(376, '2025-08-24 01:33:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '101.207.163.141', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(377, '2025-08-24 01:34:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '101.67.139.57', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(378, '2025-08-24 01:34:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '123.158.60.208', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(379, '2025-08-24 01:34:37', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '220.167.232.195', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(380, '2025-08-24 01:34:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '1.83.125.221', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(381, '2025-08-24 01:35:06', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '111.224.219.82', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(382, '2025-08-24 01:35:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '36.32.3.176', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(383, '2025-08-24 01:35:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '220.167.232.199', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(384, '2025-08-24 01:35:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '175.30.48.70', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(385, '2025-08-24 01:35:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '118.212.122.199', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(386, '2025-08-24 01:35:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '101.207.162.92', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(387, '2025-08-24 01:35:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '171.108.182.255', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(388, '2025-08-24 01:35:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '112.112.212.21', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(389, '2025-08-24 01:35:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '125.82.242.80', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(390, '2025-08-24 01:36:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '140.206.195.105', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(391, '2025-08-24 01:36:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.31.105.237', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(392, '2025-08-24 01:36:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '221.207.35.91', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(393, '2025-08-24 01:36:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '1.85.216.236', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(394, '2025-08-24 01:36:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '110.177.183.51', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(395, '2025-08-24 01:36:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '123.191.146.17', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(396, '2025-08-24 01:36:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '139.212.70.176', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(397, '2025-08-24 01:37:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '1.24.16.101', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(398, '2025-08-24 01:37:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '119.4.12.51', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(399, '2025-08-24 01:37:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.191.30.102', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(400, '2025-08-24 01:37:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '221.11.51.30', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(401, '2025-08-24 01:37:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '122.188.30.5', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(402, '2025-08-24 01:37:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '1.24.16.230', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(403, '2025-08-24 01:37:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '218.104.149.94', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(404, '2025-08-24 01:37:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.61.184.176', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(405, '2025-08-24 01:37:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '113.206.177.78', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(406, '2025-08-24 01:37:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '111.224.221.8', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(407, '2025-08-24 01:37:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '123.160.234.12', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(408, '2025-08-24 01:38:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '58.59.246.98', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(409, '2025-08-24 01:38:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '125.82.243.209', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(410, '2025-08-24 01:38:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.248.108.33', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(411, '2025-08-24 01:38:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.248.108.127', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(412, '2025-08-24 01:38:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.148.93.35', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(413, '2025-08-24 01:38:36', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '153.0.82.31', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(414, '2025-08-24 01:38:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '1.24.16.146', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(415, '2025-08-24 01:39:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '223.199.164.44', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(416, '2025-08-24 01:39:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.191.30.33', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(417, '2025-08-24 01:39:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '182.32.50.105', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(418, '2025-08-24 01:39:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '125.82.243.113', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(419, '2025-08-24 02:03:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.102.138', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(420, '2025-08-24 02:40:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '95.177.180.82', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1', NULL),
(421, '2025-08-24 02:41:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '221.236.22.67', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36', NULL),
(422, '2025-08-24 02:47:37', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '178.128.254.133', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(423, '2025-08-24 03:10:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.245.118.83', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(424, '2025-08-24 03:26:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '147.185.133.93', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(425, '2025-08-24 03:34:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '110.40.186.63', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(426, '2025-08-24 07:22:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.23.186.43', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL);
INSERT INTO `audit_log` (`id`, `ts`, `action`, `object_type`, `object_id`, `object_label`, `actor_pessoa_id`, `actor_name`, `actor_email`, `ip`, `user_agent`, `details`) VALUES
(427, '2025-08-24 07:26:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.201.135.169', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Norton/131.0.0.0', NULL),
(428, '2025-08-24 07:27:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '88.99.48.186', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL),
(429, '2025-08-24 07:27:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '88.99.48.186', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/138.0.0.0 Safari/537.36', NULL),
(430, '2025-08-24 08:45:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.203.210.66', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(431, '2025-08-24 08:51:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(432, '2025-08-24 09:05:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '185.177.72.45', 'python-httpx/0.28.1', NULL),
(433, '2025-08-24 09:39:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '87.236.176.245', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', NULL),
(434, '2025-08-24 09:50:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '117.33.163.216', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(435, '2025-08-24 11:38:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '116.207.205.202', 'Mozilla/5.0 (Windows NT 10.9; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.1726.88 Safari/537.36', NULL),
(436, '2025-08-24 11:49:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(437, '2025-08-24 12:04:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.12.58', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(438, '2025-08-24 12:24:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '178.128.166.140', 'Mozilla/5.0 (X11; Linux x86_64; rv:139.0) Gecko/20100101 Firefox/139.0', NULL),
(439, '2025-08-24 12:35:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '164.92.74.154', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', NULL),
(440, '2025-08-24 12:55:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '114.117.233.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(441, '2025-08-24 13:46:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(442, '2025-08-24 13:53:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '23.95.219.166', 'Mozilla/5.0 (Windows NT 5.1) Gecko/20100101 Firefox/4.0.1', NULL),
(443, '2025-08-24 13:55:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '199.244.88.231', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36', NULL),
(444, '2025-08-24 14:09:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.124.183.253', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36', NULL),
(445, '2025-08-24 14:11:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '20.171.207.238', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)', NULL),
(446, '2025-08-24 14:23:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(447, '2025-08-24 14:23:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(448, '2025-08-24 15:04:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.54.138', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(449, '2025-08-24 15:26:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '3.220.232.250', 'okhttp/4.9.2', NULL),
(450, '2025-08-24 15:50:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(451, '2025-08-24 15:50:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(452, '2025-08-24 16:35:09', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(453, '2025-08-24 16:35:09', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(454, '2025-08-24 16:40:48', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(455, '2025-08-24 16:40:48', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(456, '2025-08-24 16:49:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.142.125.47', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(457, '2025-08-24 18:10:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(458, '2025-08-24 18:10:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(459, '2025-08-24 18:15:58', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(460, '2025-08-24 18:15:58', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(461, '2025-08-24 18:16:10', 'Login', 'Sistema', NULL, 'Login no painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(462, '2025-08-24 18:16:10', 'Logout', 'Sistema', NULL, 'Logout do painel', 6, 'lisa', NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(463, '2025-08-24 18:48:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '213.32.122.82', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36', NULL),
(464, '2025-08-24 19:13:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '58.49.233.126', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(465, '2025-08-24 21:05:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(466, '2025-08-24 21:05:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(467, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(468, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(469, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(470, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(471, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(472, '2025-08-24 21:05:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(473, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(474, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(475, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(476, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(477, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(478, '2025-08-24 21:05:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(479, '2025-08-24 21:05:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(480, '2025-08-24 21:05:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(481, '2025-08-24 21:05:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(482, '2025-08-24 21:05:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(483, '2025-08-24 21:05:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.162.36.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(484, '2025-08-24 21:07:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.167.245.18', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(485, '2025-08-24 23:47:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.255.10.32', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(486, '2025-08-24 23:48:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(487, '2025-08-24 23:48:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(488, '2025-08-24 23:50:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(489, '2025-08-25 00:05:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.155.188.157', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(490, '2025-08-25 00:24:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '216.73.172.9', '\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36\"', NULL),
(491, '2025-08-25 01:02:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.157.188.74', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(492, '2025-08-25 01:14:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '113.141.91.58', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(493, '2025-08-25 02:00:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.51.183.15', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(494, '2025-08-25 02:22:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '95.177.180.85', 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1', NULL),
(495, '2025-08-25 03:00:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.130.32.245', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(496, '2025-08-25 03:00:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.19.83', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(497, '2025-08-25 03:11:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.79.130', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(498, '2025-08-25 03:19:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.203.211.177', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(499, '2025-08-25 04:20:37', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '101.42.117.179', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(500, '2025-08-25 04:41:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.216.150.195', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(501, '2025-08-25 10:01:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.189.134.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(502, '2025-08-25 10:01:36', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.189.134.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(503, '2025-08-25 10:01:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.88.91.82', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/68.0.3440.106 Safari/537.36', NULL),
(504, '2025-08-25 10:36:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.232.151.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(505, '2025-08-25 11:59:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(506, '2025-08-25 12:03:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.113.127', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(507, '2025-08-25 12:33:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '52.11.171.106', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0', NULL),
(508, '2025-08-25 13:04:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(509, '2025-08-25 13:46:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(510, '2025-08-25 13:46:52', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(511, '2025-08-25 14:33:40', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '192.104.34.34', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36', NULL),
(512, '2025-08-25 16:16:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '3.255.250.18', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(513, '2025-08-25 16:42:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.82.78.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36', NULL),
(514, '2025-08-25 16:44:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '216.73.216.97', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; ClaudeBot/1.0; +claudebot@anthropic.com)', NULL),
(515, '2025-08-25 17:53:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.33', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(516, '2025-08-25 18:05:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.157.38.131', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(517, '2025-08-25 18:32:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '81.167.26.57', 'Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)', NULL),
(518, '2025-08-25 18:40:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.79.130', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(519, '2025-08-25 19:39:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(520, '2025-08-25 19:39:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(521, '2025-08-25 19:54:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(522, '2025-08-25 19:54:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(523, '2025-08-25 20:02:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '114.117.233.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(524, '2025-08-25 20:09:59', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(525, '2025-08-25 21:00:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.102.138', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(526, '2025-08-25 22:03:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '210.64.24.100', 'Python/3.13 aiohttp/3.12.13', NULL),
(527, '2025-08-25 22:39:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '8.213.133.199', 'Go-http-client/1.1', NULL),
(528, '2025-08-25 22:39:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.91.120.190', 'Go-http-client/1.1', NULL),
(529, '2025-08-25 23:04:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '119.45.20.16', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(530, '2025-08-26 00:05:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.135.208', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(531, '2025-08-26 00:12:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', NULL),
(532, '2025-08-26 00:25:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.78.109.165', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(533, '2025-08-26 00:25:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(534, '2025-08-26 00:34:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(535, '2025-08-26 00:34:16', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(536, '2025-08-26 00:35:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(537, '2025-08-26 00:40:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.236.100.56', 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko', NULL),
(538, '2025-08-26 01:05:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.123.4', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(539, '2025-08-26 01:17:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '216.73.216.97', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; ClaudeBot/1.0; +claudebot@anthropic.com)', NULL),
(540, '2025-08-26 01:22:02', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(541, '2025-08-26 01:44:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '172.82.65.38', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', NULL),
(542, '2025-08-26 02:02:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.130.31.17', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(543, '2025-08-26 04:33:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.216.150.76', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(544, '2025-08-26 05:34:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '139.224.239.220', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36', NULL),
(545, '2025-08-26 05:34:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.100.247.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36', NULL),
(546, '2025-08-26 05:34:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.100.161.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36', NULL),
(547, '2025-08-26 05:34:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.100.161.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36', NULL),
(548, '2025-08-26 06:12:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '72.13.46.6', 'Mozilla/5.0 (compatible; ips-agent)', NULL),
(549, '2025-08-26 07:01:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.74.27.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL),
(550, '2025-08-26 07:01:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.74.27.105', 'Mozilla/5.0 (Linux; Android 7.0; SM-G950U Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.26 Mobile Safari/537.36', NULL),
(551, '2025-08-26 07:27:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '119.196.95.49', 'Go-http-client/1.1', NULL),
(552, '2025-08-26 07:32:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(553, '2025-08-26 09:08:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.216.150.23', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(554, '2025-08-26 10:42:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.248.229.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(555, '2025-08-26 10:42:45', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.248.229.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(556, '2025-08-26 10:59:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '185.177.72.45', 'python-httpx/0.28.1', NULL),
(557, '2025-08-26 12:02:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.135.186.135', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(558, '2025-08-26 13:08:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(559, '2025-08-26 13:08:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(560, '2025-08-26 13:39:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(561, '2025-08-26 13:39:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(562, '2025-08-26 13:39:44', 'Login', 'Sistema', NULL, 'Login no painel', 9, 'Administrador', NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(563, '2025-08-26 13:39:44', 'Logout', 'Sistema', NULL, 'Logout do painel', 9, 'Administrador', NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(564, '2025-08-26 13:49:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(565, '2025-08-26 13:49:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(566, '2025-08-26 14:04:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '164.90.153.190', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(567, '2025-08-26 14:35:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.14.17.48', 'Mozilla/5.0 (Linux; Android 9; Mi A2 Lite) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132', NULL),
(568, '2025-08-26 14:35:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.14.17.48', 'Mozilla/5.0 (Linux; Android 9; Mi A2 Lite) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132', NULL),
(569, '2025-08-26 14:35:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.14.17.48', 'Mozilla/5.0 (Linux; Android 9; Mi A2 Lite) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132', NULL),
(570, '2025-08-26 14:35:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.14.17.48', 'Mozilla/5.0 (Linux; Android 9; Mi A2 Lite) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132', NULL),
(571, '2025-08-26 14:35:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '59.14.17.48', 'Mozilla/5.0 (Linux; Android 9; Mi A2 Lite) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132', NULL),
(572, '2025-08-26 15:04:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.155.188.157', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(573, '2025-08-26 15:45:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(574, '2025-08-26 15:45:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(575, '2025-08-26 15:45:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '138.121.129.120', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(576, '2025-08-26 16:52:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '20.171.207.104', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)', NULL),
(577, '2025-08-26 18:07:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.35.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(578, '2025-08-26 18:23:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '84.246.85.11', '2ip bot/1.1 (+http://2ip.io)', NULL),
(579, '2025-08-26 18:24:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '84.246.85.11', '2ip bot/1.1 (+http://2ip.io)', NULL),
(580, '2025-08-26 18:24:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '84.246.85.11', '2ip bot/1.1 (+http://2ip.io)', NULL),
(581, '2025-08-26 18:33:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Go-http-client/1.1', NULL),
(582, '2025-08-26 18:33:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Go-http-client/1.1', NULL),
(583, '2025-08-26 18:34:00', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/587.53 (KHTML, like Gecko) Chrome/103.0.2923 Safari/537.36', NULL),
(584, '2025-08-26 18:34:01', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 8_2_1) AppleWebKit/544.47 (KHTML, like Gecko) Chrome/101.0.1216 Safari/537.36', NULL),
(585, '2025-08-26 18:34:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Go-http-client/1.1', NULL),
(586, '2025-08-26 18:34:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '165.154.135.215', 'Go-http-client/1.1', NULL),
(587, '2025-08-26 20:27:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.204', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(588, '2025-08-26 21:18:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(589, '2025-08-26 21:18:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(590, '2025-08-26 21:18:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(591, '2025-08-26 21:18:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(592, '2025-08-26 21:18:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(593, '2025-08-26 21:18:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(594, '2025-08-26 21:18:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(595, '2025-08-26 21:18:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(596, '2025-08-26 21:18:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(597, '2025-08-26 21:18:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(598, '2025-08-26 21:18:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(599, '2025-08-26 21:18:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(600, '2025-08-26 21:18:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(601, '2025-08-26 21:18:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(602, '2025-08-26 21:18:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(603, '2025-08-26 21:18:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(604, '2025-08-26 21:18:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(605, '2025-08-26 21:18:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(606, '2025-08-26 21:18:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.169.207.35', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(607, '2025-08-26 23:03:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '87.103.246.30', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.43 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 OPR/108.0.0.0', NULL),
(608, '2025-08-26 23:04:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.33', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(609, '2025-08-26 23:57:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.203.211.25', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(610, '2025-08-27 00:05:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.51.195.195', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(611, '2025-08-27 00:31:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.142.125.193', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(612, '2025-08-27 01:03:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.135.208', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(613, '2025-08-27 02:03:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.159.138.217', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(614, '2025-08-27 02:34:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '199.45.155.90', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(615, '2025-08-27 02:47:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.222.142.44', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(616, '2025-08-27 03:23:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(617, '2025-08-27 03:23:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(618, '2025-08-27 03:23:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(619, '2025-08-27 03:23:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(620, '2025-08-27 03:23:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(621, '2025-08-27 03:23:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(622, '2025-08-27 03:23:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(623, '2025-08-27 03:23:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(624, '2025-08-27 03:23:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(625, '2025-08-27 03:23:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(626, '2025-08-27 03:23:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(627, '2025-08-27 03:23:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(628, '2025-08-27 03:23:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(629, '2025-08-27 03:23:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(630, '2025-08-27 03:23:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(631, '2025-08-27 03:23:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(632, '2025-08-27 03:23:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(633, '2025-08-27 03:23:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '64.225.63.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4240.193 Safari/537.36', NULL),
(634, '2025-08-27 03:48:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', NULL),
(635, '2025-08-27 03:48:37', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', NULL),
(636, '2025-08-27 03:48:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1', NULL),
(637, '2025-08-27 03:48:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1', NULL),
(638, '2025-08-27 03:48:52', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.39', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(639, '2025-08-27 04:05:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '118.26.104.93', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11', NULL),
(640, '2025-08-27 04:11:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', NULL),
(641, '2025-08-27 04:11:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1', NULL),
(642, '2025-08-27 04:11:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', NULL),
(643, '2025-08-27 04:11:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1', NULL),
(644, '2025-08-27 04:21:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.204.214.143', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL),
(645, '2025-08-27 04:30:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '194.187.178.118', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0', NULL);
INSERT INTO `audit_log` (`id`, `ts`, `action`, `object_type`, `object_id`, `object_label`, `actor_pessoa_id`, `actor_name`, `actor_email`, `ip`, `user_agent`, `details`) VALUES
(646, '2025-08-27 04:33:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', NULL),
(647, '2025-08-27 04:33:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '141.148.153.213', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1', NULL),
(648, '2025-08-27 05:27:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.185.131.79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36', NULL),
(649, '2025-08-27 05:55:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '114.117.233.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(650, '2025-08-27 05:56:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '205.210.31.106', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(651, '2025-08-27 07:18:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '147.185.133.81', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(652, '2025-08-27 07:54:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '4.43.184.114', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50728)', NULL),
(653, '2025-08-27 08:48:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '18.209.99.198', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', NULL),
(654, '2025-08-27 11:46:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '159.89.238.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL),
(655, '2025-08-27 12:03:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.133.69.37', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(656, '2025-08-27 12:56:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.188.223.240', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(657, '2025-08-27 12:56:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.188.223.240', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(658, '2025-08-27 13:31:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '107.170.65.169', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', NULL),
(659, '2025-08-27 13:47:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '198.20.67.202', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(660, '2025-08-27 13:47:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '198.20.67.202', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(661, '2025-08-27 14:07:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '185.224.128.137', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', NULL),
(662, '2025-08-27 14:07:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '185.224.128.137', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', NULL),
(663, '2025-08-27 15:05:04', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '170.106.152.218', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(664, '2025-08-27 15:16:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '114.117.233.112', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(665, '2025-08-27 15:43:52', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(666, '2025-08-27 15:43:57', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.230', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(667, '2025-08-27 18:04:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.36.110', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(668, '2025-08-27 19:23:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '199.45.154.139', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(669, '2025-08-27 20:49:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(670, '2025-08-27 20:49:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(671, '2025-08-27 20:49:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(672, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(673, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(674, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(675, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(676, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(677, '2025-08-27 20:49:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(678, '2025-08-27 20:49:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(679, '2025-08-27 20:49:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(680, '2025-08-27 20:49:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(681, '2025-08-27 20:49:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(682, '2025-08-27 20:49:34', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(683, '2025-08-27 20:49:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(684, '2025-08-27 20:49:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(685, '2025-08-27 20:49:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(686, '2025-08-27 20:49:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(687, '2025-08-27 20:49:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.26.24.159', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(688, '2025-08-27 23:56:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.75.133.148', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(689, '2025-08-27 23:58:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.75.137.81', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(690, '2025-08-27 23:58:33', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.75.129.36', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(691, '2025-08-27 23:58:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.75.157.202', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(692, '2025-08-28 00:00:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '106.75.164.139', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36', NULL),
(693, '2025-08-28 00:15:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '223.244.35.77', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(694, '2025-08-28 00:37:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.79.218.146', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Mobile Safari/537.36', NULL),
(695, '2025-08-28 00:42:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.216.150.44', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(696, '2025-08-28 01:15:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '147.185.133.13', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(697, '2025-08-28 01:25:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Dalvik/2.1.0 (Linux; U; Android 9.0; ZTE BA520 Build/MRA58K)', NULL),
(698, '2025-08-28 01:29:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', NULL),
(699, '2025-08-28 02:02:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.157.38.228', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(700, '2025-08-28 03:08:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '110.166.71.39', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(701, '2025-08-28 03:15:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '143.198.143.20', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(702, '2025-08-28 04:54:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.163', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(703, '2025-08-28 06:10:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '193.46.255.83', 'libwww-perl/6.79', NULL),
(704, '2025-08-28 06:10:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '193.46.255.83', 'libwww-perl/6.79', NULL),
(705, '2025-08-28 07:36:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.236.100.56', 'Mozilla/5.0 (X11; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0', NULL),
(706, '2025-08-28 08:04:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.243.114.171', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', NULL),
(707, '2025-08-28 09:03:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '104.248.30.84', 'Mozilla/5.0 (compatible; Odin; https://docs.getodin.com/)', NULL),
(708, '2025-08-28 09:21:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '118.89.233.234', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(709, '2025-08-28 09:45:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.251.72.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(710, '2025-08-28 09:45:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.251.72.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(711, '2025-08-28 11:26:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.125.121.137', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', NULL),
(712, '2025-08-28 12:30:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '140.143.98.18', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(713, '2025-08-28 13:16:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '161.35.130.134', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(714, '2025-08-28 13:46:50', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(715, '2025-08-28 13:47:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(716, '2025-08-28 15:05:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.159.132.207', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(717, '2025-08-28 16:56:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '3.236.162.94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', NULL),
(718, '2025-08-28 16:56:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '3.236.162.94', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', NULL),
(719, '2025-08-28 17:56:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '20.171.207.128', 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.2; +https://openai.com/gptbot)', NULL),
(720, '2025-08-28 18:06:08', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.159.149.216', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(721, '2025-08-28 18:48:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '124.221.245.78', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(722, '2025-08-28 19:31:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(723, '2025-08-28 19:31:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(724, '2025-08-28 19:31:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(725, '2025-08-28 19:31:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(726, '2025-08-28 19:31:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(727, '2025-08-28 19:31:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(728, '2025-08-28 19:31:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(729, '2025-08-28 19:31:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(730, '2025-08-28 19:31:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(731, '2025-08-28 19:31:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(732, '2025-08-28 19:31:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(733, '2025-08-28 19:31:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(734, '2025-08-28 19:31:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(735, '2025-08-28 19:31:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(736, '2025-08-28 19:31:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(737, '2025-08-28 19:31:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(738, '2025-08-28 19:31:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(739, '2025-08-28 19:31:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(740, '2025-08-28 19:31:31', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '34.11.203.135', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36', NULL),
(741, '2025-08-28 21:43:41', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '118.89.233.234', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(742, '2025-08-28 22:54:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '54.39.6.72', 'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)', NULL),
(743, '2025-08-28 23:55:15', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.69', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(744, '2025-08-29 00:05:36', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.157.170.126', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(745, '2025-08-29 00:26:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.142.125.43', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(746, '2025-08-29 00:45:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '36.41.75.167', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(747, '2025-08-29 00:56:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Dalvik/2.1.0 (Linux; U; Android 9.0; ZTE BA520 Build/MRA58K)', NULL),
(748, '2025-08-29 00:58:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Dalvik/2.1.0 (Linux; U; Android 9.0; ZTE BA520 Build/MRA58K)', NULL),
(749, '2025-08-29 00:59:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', NULL),
(750, '2025-08-29 01:00:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '183.134.59.131', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', NULL),
(751, '2025-08-29 01:09:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '111.7.96.169', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36', NULL),
(752, '2025-08-29 01:09:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '111.7.96.169', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36', NULL),
(753, '2025-08-29 02:56:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '2a06:98c0:3600::103', 'Domain-Verification-Tool/1.0', NULL),
(754, '2025-08-29 02:58:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '20.105.137.134', 'curl/8.6.0', NULL),
(755, '2025-08-29 03:56:52', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '198.235.24.121', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(756, '2025-08-29 03:59:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '3.253.15.131', 'Plesk screenshot bot https://support.plesk.com/hc/en-us/articles/10301006946066', NULL),
(757, '2025-08-29 04:04:49', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '24.199.119.128', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL),
(758, '2025-08-29 04:13:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '44.220.185.208', 'Mozilla/5.0 (Windows NT 6.2;en-US) AppleWebKit/537.32.36 (KHTML, live Gecko) Chrome/60.0.3109.84 Safari/537.32', NULL),
(759, '2025-08-29 05:20:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.237.28.40', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36', NULL),
(760, '2025-08-29 05:20:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '47.237.97.248', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36', NULL),
(761, '2025-08-29 05:33:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.203.211.223', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(762, '2025-08-29 06:51:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '132.232.203.74', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(763, '2025-08-29 07:14:07', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.249.244.19', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/121.0 Mobile/15E148 Safari/605.1.15', NULL),
(764, '2025-08-29 07:14:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.249.244.19', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36', NULL),
(765, '2025-08-29 07:14:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.249.244.19', 'curl/7.4.0', NULL),
(766, '2025-08-29 07:14:11', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '45.249.244.19', 'Mozilla/5.0 (Linux; Android 11; SM-G770F; Build/RQ1D.180113.219) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.68 Mobile Safari/537.36', NULL),
(767, '2025-08-29 07:18:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '88.80.188.46', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0', NULL),
(768, '2025-08-29 07:24:21', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Android 10; Mobile; rv:139.0.1) Gecko/139.0.1 Firefox/139.0.1', NULL),
(769, '2025-08-29 07:24:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36', NULL),
(770, '2025-08-29 07:24:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'okhttp/3.14.9', NULL),
(771, '2025-08-29 07:24:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Linux; Android 12; SM-G900T3; Build/SD2A.210410.64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.5563.67 Mobile Safari/537.36', NULL),
(772, '2025-08-29 07:24:26', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'curl/7.4.0', NULL),
(773, '2025-08-29 07:24:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36', NULL),
(774, '2025-08-29 07:24:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Linux; Android 12; SM-G900T3; Build/SD2A.210410.64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.5563.67 Mobile Safari/537.36', NULL),
(775, '2025-08-29 07:24:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36', NULL),
(776, '2025-08-29 07:24:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/537.36 (KHTML, like Gecko) CriOS/105.0.5195.26 Mobile/15E148 Safari/537.36', NULL),
(777, '2025-08-29 07:24:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '103.218.241.128', 'Mozilla/5.0 (Linux; Android 8; SM-G930V; Build/OPR6.180613.174) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.6422.62 Mobile Safari/537.36', NULL),
(778, '2025-08-29 09:05:54', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '212.71.248.89', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0', NULL),
(779, '2025-08-29 09:49:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '35.203.211.160', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', NULL),
(780, '2025-08-29 09:51:58', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '162.14.197.180', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(781, '2025-08-29 09:55:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '18.237.237.72', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(782, '2025-08-29 09:55:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '18.237.237.72', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36', NULL),
(783, '2025-08-29 10:38:09', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '77.83.36.43', 'Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1', NULL),
(784, '2025-08-29 12:02:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '43.153.9.143', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(785, '2025-08-29 12:03:59', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '77.83.36.43', 'Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1', NULL),
(786, '2025-08-29 12:59:19', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '60.188.57.0', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(787, '2025-08-29 13:48:35', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(788, '2025-08-29 13:48:43', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(789, '2025-08-29 15:05:32', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '49.51.39.209', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL),
(790, '2025-08-29 15:10:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(791, '2025-08-29 15:21:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(792, '2025-08-29 15:24:44', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(793, '2025-08-29 15:24:51', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(794, '2025-08-29 15:24:55', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(795, '2025-08-29 15:26:17', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(796, '2025-08-29 15:26:18', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(797, '2025-08-29 15:26:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(798, '2025-08-29 15:28:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '177.107.29.82', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(799, '2025-08-29 23:13:03', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '189.97.243.83', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(800, '2025-08-30 00:56:30', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '206.168.34.117', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(801, '2025-08-30 13:49:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(802, '2025-08-30 13:49:22', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(803, '2025-08-31 01:54:13', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '206.168.34.126', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(804, '2025-08-31 13:48:10', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.62', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(805, '2025-08-31 13:48:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.62', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(806, '2025-09-01 01:10:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.68.69', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(807, '2025-09-01 02:52:48', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '206.168.34.203', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(808, '2025-09-01 13:47:56', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(809, '2025-09-02 03:52:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '167.94.138.184', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', NULL),
(810, '2025-09-02 13:48:36', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(811, '2025-09-02 13:48:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(812, '2025-09-03 13:48:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(813, '2025-09-03 13:48:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(814, '2025-09-04 13:48:23', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(815, '2025-09-04 13:48:28', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(816, '2025-09-04 18:52:12', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '187.123.42.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(817, '2025-09-05 13:48:38', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.60', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(818, '2025-09-05 13:48:42', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.60', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(819, '2025-09-05 18:00:39', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '187.123.42.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', NULL),
(820, '2025-09-05 18:21:46', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '66.249.75.67', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.183 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', NULL),
(821, '2025-09-06 13:46:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(822, '2025-09-06 13:46:05', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.61', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(823, '2025-09-07 13:46:25', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(824, '2025-09-07 13:46:29', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(825, '2025-09-08 13:46:24', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(826, '2025-09-08 13:46:27', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.36.186', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(827, '2025-09-09 13:47:02', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(828, '2025-09-09 13:47:16', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.76.35', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL),
(829, '2025-09-10 13:46:14', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.62', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/6.0)', NULL),
(830, '2025-09-10 13:46:20', 'Login', 'Sistema', NULL, 'Login no painel', NULL, NULL, NULL, '184.154.139.62', 'SiteLockSpider [en] (WinNT; I ;Nav)', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `cadastro`
--

CREATE TABLE `cadastro` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tipo_documento` enum('CPF','CNPJ') NOT NULL DEFAULT 'CPF' COMMENT 'Tipo do documento principal',
  `documento` varchar(20) NOT NULL COMMENT 'CPF ou CNPJ (com ou sem máscara)',
  `data_nascimento` date DEFAULT NULL,
  `nome_razao_social` varchar(180) NOT NULL,
  `estado_civil` enum('Solteiro(a)','Casado(a)','Divorciado(a)','Viúvo(a)','União Estável','Separado(a)','Outro') DEFAULT NULL,
  `rg` varchar(20) DEFAULT NULL,
  `profissao` varchar(100) DEFAULT NULL,
  `cep` varchar(9) DEFAULT NULL COMMENT 'Ex: 00000-000',
  `complemento` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  `endereco` varchar(180) DEFAULT NULL,
  `bairro` varchar(120) DEFAULT NULL,
  `cidade` varchar(120) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL COMMENT 'Ex: (00) 0000-0000',
  `celular` varchar(20) DEFAULT NULL COMMENT 'Ex: (00) 00000-0000',
  `matricula` varchar(60) DEFAULT NULL,
  `beneficio` varchar(120) DEFAULT NULL,
  `banco_nome` varchar(120) DEFAULT NULL,
  `agencia` varchar(20) DEFAULT NULL,
  `conta` varchar(30) DEFAULT NULL,
  `tipo_conta` enum('Corrente','Poupança') DEFAULT NULL,
  `pix_chave` varchar(140) DEFAULT NULL COMMENT 'CPF/CNPJ, e-mail, telefone ou aleatória',
  `salario_liquido` decimal(12,2) DEFAULT 0.00,
  `antecipacao` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `cadastro`
--

INSERT INTO `cadastro` (`id`, `tipo_documento`, `documento`, `data_nascimento`, `nome_razao_social`, `estado_civil`, `rg`, `profissao`, `cep`, `complemento`, `uf`, `endereco`, `bairro`, `cidade`, `telefone`, `celular`, `matricula`, `beneficio`, `banco_nome`, `agencia`, `conta`, `tipo_conta`, `pix_chave`, `salario_liquido`, `antecipacao`, `created_at`, `updated_at`) VALUES
(1, 'CPF', '000.000.000-00', '1990-05-14', 'João da Silva', 'Solteiro(a)', '12.345.678-9', 'Analista de Sistemas', '64000-000', 'Apto 302', 'PI', 'Av. Principal, 123', 'Centro', 'Teresina', '(86) 3232-0000', '(86) 99999-0000', 'MAT-001', 'Auxílio Saúde', 'Banco do Brasil', '1234-5', '98765-0', 'Corrente', '000.000.000-00', 4500.00, 0.00, '2025-08-18 23:36:11', '2025-08-18 23:36:11');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(8) NOT NULL COMMENT 'Ex: CLI001',
  `data_cadastro` date NOT NULL,
  `nome` varchar(180) NOT NULL,
  `cpf` varchar(20) NOT NULL,
  `status_contrato` enum('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
  `status_antecipacao` enum('LIBERADO','PENDENTE','BLOQUEADO') NOT NULL DEFAULT 'PENDENTE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`id`, `codigo`, `data_cadastro`, `nome`, `cpf`, `status_contrato`, `status_antecipacao`, `created_at`, `updated_at`) VALUES
(1, 'CLI001', '2024-01-14', 'João Silva Santos', '***.***.***-12', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(2, 'CLI002', '2024-01-15', 'Maria Oliveira Costa', '***.***.***-34', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(3, 'CLI003', '2024-01-16', 'Pedro Almeida Lima', '***.***.***-56', 'INATIVO', 'BLOQUEADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(4, 'CLI004', '2024-01-17', 'Ana Carolina Ferreira', '***.***.***-78', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(5, 'CLI005', '2024-01-18', 'Carlos Eduardo Sousa', '***.***.***-90', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(6, 'CLI006', '2024-01-19', 'Francisca Santos Rocha', '***.***.***-01', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(7, 'CLI007', '2024-01-20', 'Roberto Lima Nascimento', '***.***.***-23', 'INATIVO', 'BLOQUEADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(8, 'CLI008', '2024-01-21', 'Luciana Pereira Dias', '***.***.***-45', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(9, 'CLI009', '2024-01-22', 'Antonio José Barbosa', '***.***.***-67', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(10, 'CLI010', '2024-01-23', 'Silvia Regina Moura', '***.***.***-89', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(11, 'CLI011', '2024-01-24', 'Fernando Costa Lima', '***.***.***-11', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(12, 'CLI012', '2024-01-25', 'Mariana Santos Silva', '***.***.***-22', 'INATIVO', 'BLOQUEADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(13, 'CLI013', '2024-01-26', 'Ricardo Oliveira Souza', '***.***.***-33', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(14, 'CLI014', '2024-01-27', 'Patricia Lima Costa', '***.***.***-44', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(15, 'CLI015', '2024-01-28', 'Marcos Antonio Silva', '***.***.***-55', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(16, 'CLI016', '2024-01-29', 'Juliana Ferreira Santos', '***.***.***-66', 'INATIVO', 'BLOQUEADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(17, 'CLI017', '2024-01-31', 'Eduardo Santos Lima', '***.***.***-77', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(18, 'CLI018', '2024-02-01', 'Camila Costa Oliveira', '***.***.***-88', 'ATIVO', 'PENDENTE', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(19, 'CLI019', '2024-02-02', 'Rafael Lima Santos', '***.***.***-99', 'ATIVO', 'LIBERADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30'),
(20, 'CLI020', '2024-02-03', 'Beatriz Silva Costa', '***.***.***-00', 'INATIVO', 'BLOQUEADO', '2025-08-18 23:46:30', '2025-08-18 23:46:30');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente_extra`
--

CREATE TABLE `cliente_extra` (
  `codigo` varchar(8) NOT NULL,
  `estado_civil` varchar(40) DEFAULT NULL,
  `dados_bancarios` mediumtext DEFAULT NULL,
  `contrato` mediumtext DEFAULT NULL,
  `antecipacao` mediumtext DEFAULT NULL,
  `pagamentos` mediumtext DEFAULT NULL,
  `observacoes` mediumtext DEFAULT NULL,
  `repasse` mediumtext DEFAULT NULL,
  `assinatura` varchar(120) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `contrato`
--

CREATE TABLE `contrato` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `mensalidade` decimal(12,2) DEFAULT NULL,
  `prazo_meses` int(11) DEFAULT NULL,
  `taxa_antecipacao` decimal(5,2) DEFAULT NULL,
  `margem_disponivel` decimal(12,2) DEFAULT NULL,
  `data_aprovacao` date DEFAULT NULL,
  `data_envio_primeira` date DEFAULT NULL,
  `convenio` varchar(120) DEFAULT NULL,
  `valor_antecipacao` decimal(12,2) DEFAULT NULL,
  `status_contrato` varchar(40) DEFAULT NULL,
  `mes_averbacao` date DEFAULT NULL,
  `codigo_contrato` varchar(60) DEFAULT NULL,
  `doacao_associado` decimal(12,2) DEFAULT NULL,
  `agente_responsavel` varchar(120) DEFAULT NULL,
  `filial` varchar(120) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `contrato`
--

INSERT INTO `contrato` (`id`, `pessoa_id`, `mensalidade`, `prazo_meses`, `taxa_antecipacao`, `margem_disponivel`, `data_aprovacao`, `data_envio_primeira`, `convenio`, `valor_antecipacao`, `status_contrato`, `mes_averbacao`, `codigo_contrato`, `doacao_associado`, `agente_responsavel`, `filial`, `created_at`, `updated_at`) VALUES
(1, 4, 400.00, 3, 30.00, 140.00, '2025-08-21', '2025-09-21', '1414', 30.00, 'Pendente', '2025-09-01', 'CTR1515', 10.00, 'helcio', 'teresina', '2025-08-21 13:02:20', '2025-08-21 13:02:20'),
(2, 4, 400.00, 3, 30.00, NULL, '2025-08-21', '2025-09-21', 'idk', NULL, 'Aprovado', '2025-09-01', NULL, 10.00, 'AAA', 'AAAA', '2025-08-21 20:37:43', '2025-08-21 20:37:43'),
(3, 4, 400.00, 3, 30.00, NULL, '2025-08-21', '2025-08-05', 'aa', NULL, 'Pendente', '2025-09-01', NULL, 10.00, 'aaa', 'aaa', '2025-08-21 20:53:59', '2025-08-21 20:53:59'),
(4, 12, 500.00, 3, 30.00, NULL, '2025-08-21', '2025-09-21', 'a', NULL, 'Pendente', '2025-09-01', NULL, NULL, 'GUTEMBERG', 'TERESINA', '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(5, 13, 4000.00, 3, 30.00, NULL, '2025-08-21', '2025-09-21', '111', NULL, 'Pendente', '2025-08-01', NULL, NULL, 'lisasimpson', 'teresina', '2025-08-21 22:35:30', '2025-08-21 22:35:30'),
(6, 14, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-01', NULL, NULL, NULL, NULL, '2025-08-21 23:08:38', '2025-08-21 23:08:38'),
(7, 15, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-01', NULL, NULL, NULL, NULL, '2025-08-21 23:21:55', '2025-08-21 23:21:55'),
(8, 4, 400.00, 3, 30.00, NULL, '2025-08-22', '2025-10-05', '10', NULL, 'Pendente', '2025-09-01', NULL, NULL, 'peltison', 'GOVERNO DO ESTADO DO PIAUI', '2025-08-22 11:51:01', '2025-08-22 11:51:01'),
(9, 13, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-01', NULL, NULL, NULL, NULL, '2025-08-22 13:08:37', '2025-08-22 13:08:37'),
(10, 4, 400.00, 3, 30.00, NULL, '2025-08-22', '2025-09-05', '11', NULL, 'Pendente', '2025-09-01', NULL, 0.10, 'pitson', 'la ele', '2025-08-22 13:10:55', '2025-08-22 13:10:55'),
(11, 19, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-22 13:16:47', '2025-08-22 13:16:47'),
(12, 20, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-22 13:22:47', '2025-08-22 13:22:47'),
(13, 21, NULL, 3, 30.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-22 13:27:02', '2025-08-22 13:27:02'),
(14, 22, 350.00, 3, 30.00, NULL, '2025-08-22', '2025-10-05', NULL, NULL, 'Em Andamento', '2025-09-01', NULL, NULL, 'FERNANDA BB', 'ABASEPI', '2025-08-22 18:17:53', '2025-08-22 18:17:53'),
(15, 4, 4000.00, 3, 30.00, NULL, '2025-08-22', '2025-09-05', NULL, NULL, 'Em Andamento', '2025-09-01', NULL, 10.00, 'fla', 'outro', '2025-08-22 21:01:54', '2025-08-22 21:01:54'),
(16, 8, 400.05, 3, 30.00, NULL, '2025-08-20', '2025-10-05', 'GOV-PI', NULL, 'Pendente', '2025-09-01', NULL, 360.00, 'PELTSON', 'TERSINA', '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(17, 25, 400.00, 3, 30.00, NULL, '2025-08-23', '2025-10-05', 'BB', NULL, 'Em Andamento', '2025-09-01', NULL, 380.00, 'Helcio Admin', 'Abase Matriz', '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(18, 26, 500.00, 3, 30.00, NULL, '2025-08-23', '2025-10-05', 'ss', NULL, 'Em Andamento', '2025-09-01', NULL, 450.00, 'Peltson', 'Abasepi', '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(19, 4, 400.00, 3, 30.00, NULL, '2025-08-23', '2025-09-05', 'a', NULL, 'Em Andamento', '2025-09-01', NULL, 1.00, 'aaa', 'aaa', '2025-08-23 12:10:44', '2025-08-23 12:10:44'),
(20, 28, 500.00, 3, 30.00, NULL, '2025-08-23', '2025-10-05', NULL, NULL, 'Pendente', NULL, NULL, 450.00, 'HElcio', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `contratos`
--

CREATE TABLE `contratos` (
  `contrato` varchar(40) NOT NULL,
  `cliente` varchar(120) NOT NULL,
  `cpf` char(11) NOT NULL,
  `uf` char(2) NOT NULL,
  `produto` varchar(100) NOT NULL,
  `vlr_antecipacao` decimal(15,2) NOT NULL,
  `prazo_meses` smallint(5) UNSIGNED NOT NULL,
  `mensalidade` decimal(15,2) NOT NULL,
  `rent_mensalidade` decimal(15,2) DEFAULT 0.00,
  `total_antec_mens` decimal(15,2) DEFAULT NULL,
  `mes_averb` date DEFAULT NULL,
  `data_aprov` date DEFAULT NULL,
  `status_contrato` varchar(20) NOT NULL DEFAULT 'PENDENTE',
  `responsavel` varchar(120) DEFAULT NULL,
  `rent_total` decimal(15,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `contratos`
--

INSERT INTO `contratos` (`contrato`, `cliente`, `cpf`, `uf`, `produto`, `vlr_antecipacao`, `prazo_meses`, `mensalidade`, `rent_mensalidade`, `total_antec_mens`, `mes_averb`, `data_aprov`, `status_contrato`, `responsavel`, `rent_total`, `created_at`, `updated_at`) VALUES
('1', 'RITA LINDALVA ALVES DE OLIVEIRA', '20034431349', 'PI', 'GOVERNO DO PIAUI', 1050.00, 3, 500.00, 150.00, 1500.00, '2025-09-01', '2025-09-06', 'PENDENTE', 'JOANA', 450.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('10', 'MARIA DE FATIMA DE PAIVA BRASIL', '70592721353', 'PI', 'GOVERNO DO PIAUI', 525.00, 3, 250.00, 75.00, 750.00, '2025-09-01', '2025-08-11', 'PENDENTE', 'PELTSON', 225.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('11', 'ELIZABETH GOMES VIEIRA SANTOS', '18213448391', 'PI', 'GOVERNO DO PIAUI', 630.00, 3, 300.00, 90.00, 900.00, '2025-09-01', '2025-08-15', 'PENDENTE', 'FERNANDA BB', 270.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('13', 'ELIESER DOS SANTOS SILVE', '22720081353', 'PI', 'GOVERNO DO PIAUI', 1050.00, 3, 500.00, 150.00, 1500.00, '2025-09-01', '2025-08-18', 'PENDENTE', 'PELTSON', 450.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('14', 'JOSE RODRIGUES DOS SANTOS FILHO', '00000000000', 'PI', 'GOVERNO DO PIAUI', 273.00, 3, 130.00, 39.00, 390.00, '2025-09-01', '2025-08-18', 'PENDENTE', 'PELTSON', 117.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('15', 'JOSE ELTON DE OLIVEIRA', '00000000000', 'PI', 'GOVERNO DO PIAUI', 735.00, 3, 350.00, 105.00, 1050.00, '2025-09-01', '2025-08-18', 'PENDENTE', 'PELTSON', 315.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('2', 'VALDINAR DA SILVA OLIVEIRA FILHO', '36808920206', 'PI', 'GOVERNO DO PIAUI', 1050.00, 3, 500.00, 150.00, 1500.00, '2025-09-01', '2025-08-08', 'PENDENTE', 'PELTSON', 450.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('3', 'JUSTINO DA SILVA LEAL', '45125260304', 'PI', 'GOVERNO DO PIAUI', 735.00, 3, 350.00, 105.00, 1050.00, '2025-09-01', '2025-08-11', 'PENDENTE', 'PELTSON', 315.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('4', 'IRIS MARIA AMARO', '13833154349', 'PI', 'GOVERNO DO PIAUI', 840.00, 3, 400.00, 120.00, 1200.00, '2025-09-01', '2025-08-08', 'PENDENTE', 'PELTSON', 360.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('5', 'DJALMA RODRIGUES DA SILVA', '22720928372', 'PI', 'GOVERNO DO PIAUI', 630.00, 3, 300.00, 90.00, 900.00, '2025-09-01', '2025-08-11', 'PENDENTE', 'GILMAR', 270.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('6', 'ANISIA OLIVEIRA SILVA NEGREIROS', '00443554838', 'PI', 'GOVERNO DO PIAUI', 840.00, 3, 400.00, 120.00, 1200.00, '2025-09-01', '2025-08-11', 'PENDENTE', 'PELTSON', 360.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('7', 'MARIA JOSE MAZULLO SANTIAGO', '04366689391', 'PI', 'GOVERNO DO PIAUI', 945.00, 3, 450.00, 135.00, 1350.00, '2025-09-01', '2025-08-08', 'PENDENTE', 'PELTSON', 405.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('8', 'MARINALVA TEIXEIRA ROCHA DOS PASSOS', '32800100397', 'PI', 'GOVERNO DO PIAUI', 247.80, 3, 118.00, 35.40, 354.00, '2025-09-01', '2025-08-11', 'PENDENTE', 'PELTSON', 106.20, '2025-08-19 13:10:20', '2025-08-19 13:10:20'),
('9', 'LENA MARIA RODRIGUES CORDEIRO', '09144692315', 'PI', 'GOVERNO DO PIAUI', 672.00, 3, 320.00, 96.00, 960.00, '2025-09-01', '2025-08-13', 'PENDENTE', 'PELTSON', 288.00, '2025-08-19 13:10:20', '2025-08-19 13:10:20');

-- --------------------------------------------------------

--
-- Estrutura para tabela `contrato_antecipacao`
--

CREATE TABLE `contrato_antecipacao` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `contrato_id` bigint(20) UNSIGNED NOT NULL,
  `numero_mensalidade` int(11) DEFAULT NULL,
  `valor_auxilio` decimal(12,2) DEFAULT NULL,
  `data_envio` date DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  `observacao` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `contrato_antecipacao`
--

INSERT INTO `contrato_antecipacao` (`id`, `contrato_id`, `numero_mensalidade`, `valor_auxilio`, `data_envio`, `status`, `observacao`, `created_at`) VALUES
(1, 1, 3, 10.00, '2025-08-21', 'aprovado', NULL, '2025-08-21 13:02:20'),
(2, 2, 1, NULL, '2025-09-05', 'PENDENTE', NULL, '2025-08-21 20:37:43'),
(3, 2, 2, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-21 20:37:43'),
(4, 2, 3, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-21 20:37:43'),
(5, 3, 1, NULL, '2025-08-07', 'PENDENTE', NULL, '2025-08-21 20:53:59'),
(6, 3, 2, NULL, '2025-09-05', 'PENDENTE', NULL, '2025-08-21 20:53:59'),
(7, 3, 3, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-21 20:53:59'),
(8, 4, 1, NULL, '2025-09-05', 'PENDENTE', NULL, '2025-08-21 21:11:59'),
(9, 4, 2, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-21 21:11:59'),
(10, 4, 3, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-21 21:11:59'),
(11, 5, 1, NULL, '2025-09-05', 'PENDENTE', NULL, '2025-08-21 22:35:30'),
(12, 5, 2, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-21 22:35:30'),
(13, 5, 3, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-21 22:35:30'),
(14, 8, 0, NULL, NULL, '${item.status??\'PENDENTE\'}', '${item.observacao??\'\'}', '2025-08-22 11:51:01'),
(15, 8, 0, NULL, NULL, '${item.status??\'PENDENTE\'}', '${item.observacao??\'\'}', '2025-08-22 11:51:01'),
(16, 8, 0, NULL, NULL, '${item.status??\'PENDENTE\'}', '${item.observacao??\'\'}', '2025-08-22 11:51:01'),
(17, 9, 0, NULL, NULL, 'PENDENTE', NULL, '2025-08-22 13:08:37'),
(18, 10, 1, NULL, '2025-09-05', 'PENDENTE', NULL, '2025-08-22 13:10:55'),
(19, 10, 2, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-22 13:10:55'),
(20, 10, 3, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-22 13:10:55'),
(21, 14, 1, NULL, '2025-10-05', 'PENDENTE', NULL, '2025-08-22 18:17:53'),
(22, 14, 2, NULL, '2025-11-05', 'PENDENTE', NULL, '2025-08-22 18:17:53'),
(23, 14, 3, NULL, '2025-12-05', 'PENDENTE', NULL, '2025-08-22 18:17:53'),
(24, 16, 1, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-23 01:41:48'),
(25, 16, 2, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-23 01:41:48'),
(26, 16, 3, NULL, '2025-12-05', 'PENDENTE', NULL, '2025-08-23 01:41:48'),
(27, 17, 1, NULL, '2025-10-07', 'PENDENTE', NULL, '2025-08-23 10:04:26'),
(28, 17, 2, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-23 10:04:26'),
(29, 17, 3, NULL, '2025-12-05', 'PENDENTE', NULL, '2025-08-23 10:04:26'),
(30, 18, 1, NULL, '2025-10-05', 'PENDENTE', NULL, '2025-08-23 10:17:16'),
(31, 18, 2, NULL, '2025-11-07', 'PENDENTE', NULL, '2025-08-23 10:17:16'),
(32, 18, 3, NULL, '2025-12-05', 'PENDENTE', NULL, '2025-08-23 10:17:16'),
(33, 19, 1, 400.00, '2025-09-05', 'PENDENTE', NULL, '2025-08-23 12:10:44'),
(34, 19, 2, 400.00, '2025-10-07', 'PENDENTE', NULL, '2025-08-23 12:10:44'),
(35, 19, 3, 400.00, '2025-11-07', 'PENDENTE', NULL, '2025-08-23 12:10:44'),
(36, 20, 1, 500.00, '2025-10-07', 'PENDENTE', NULL, '2025-08-23 22:25:39'),
(37, 20, 2, 500.00, '2025-11-07', 'PENDENTE', NULL, '2025-08-23 22:25:39'),
(38, 20, 3, 500.00, '2025-12-05', 'PENDENTE', NULL, '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `contrato_auxilio_agente`
--

CREATE TABLE `contrato_auxilio_agente` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `contrato_id` bigint(20) UNSIGNED NOT NULL,
  `taxa_percent` decimal(5,2) DEFAULT NULL,
  `data_envio` date DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `contrato_auxilio_agente`
--

INSERT INTO `contrato_auxilio_agente` (`id`, `contrato_id`, `taxa_percent`, `data_envio`, `status`, `created_at`) VALUES
(1, 1, 30.00, '2025-08-21', 'aprovado', '2025-08-21 13:02:20'),
(2, 2, 10.00, '2025-08-21', 'ATIVO', '2025-08-21 20:37:43'),
(3, 3, 10.00, '2025-08-21', 'ativo', '2025-08-21 20:53:59'),
(4, 4, 20.00, '2025-08-21', 'ATIVO', '2025-08-21 21:11:59'),
(5, 8, NULL, '2025-10-05', NULL, '2025-08-22 11:51:01'),
(6, 10, 10.00, '2025-08-22', 'pendente', '2025-08-22 13:10:55'),
(7, 14, 10.00, '2025-08-22', 'pendente', '2025-08-22 18:17:53'),
(8, 16, 10.00, '2025-08-30', 'PENDENTE', '2025-08-23 01:41:48'),
(9, 17, 10.00, '2025-08-23', 'Pendente', '2025-08-23 10:04:26'),
(10, 18, 10.00, '2025-08-23', 'Pendente', '2025-08-23 10:17:16'),
(11, 19, 10.00, '1995-04-22', 'aprovado', '2025-08-23 12:10:44'),
(12, 20, 10.00, NULL, NULL, '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `convenio`
--

CREATE TABLE `convenio` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(180) NOT NULL COMMENT 'Nome do convênio',
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `convenio`
--

INSERT INTO `convenio` (`id`, `nome`, `status`, `created_at`, `updated_at`) VALUES
(1, 'GOVERNO DO PIAUÍ', 'ativo', '2025-08-18 23:45:27', '2025-08-18 23:45:27'),
(2, 'GOV SERVIÇO PRESTADO', 'ativo', '2025-08-18 23:45:27', '2025-08-18 23:45:27'),
(3, 'COMISSIONADO', 'ativo', '2025-08-18 23:45:27', '2025-08-18 23:45:27');

-- --------------------------------------------------------

--
-- Estrutura para tabela `dados_bancarios`
--

CREATE TABLE `dados_bancarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `banco_nome` varchar(120) NOT NULL,
  `agencia` varchar(20) DEFAULT NULL,
  `conta` varchar(30) DEFAULT NULL,
  `tipo_conta` enum('Corrente','Poupança') DEFAULT NULL,
  `pix_chave` varchar(140) DEFAULT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `dados_bancarios`
--

INSERT INTO `dados_bancarios` (`id`, `pessoa_id`, `banco_nome`, `agencia`, `conta`, `tipo_conta`, `pix_chave`, `principal`, `created_at`, `updated_at`) VALUES
(1, 1, 'Banco do Brasil', '1234-5', '98765-0', 'Corrente', '000.000.000-00', 1, '2025-08-18 23:39:09', '2025-08-18 23:39:09');

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_arquivo`
--

CREATE TABLE `folha_arquivo` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `entidade_codigo` varchar(16) NOT NULL,
  `entidade_nome` varchar(190) NOT NULL,
  `referencia` date NOT NULL,
  `data_geracao` date DEFAULT NULL,
  `arquivo_nome` varchar(255) DEFAULT NULL,
  `arquivo_hash` char(64) DEFAULT NULL,
  `paginas_total` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_import`
--

CREATE TABLE `folha_import` (
  `id` bigint(20) NOT NULL,
  `referencia` date NOT NULL,
  `status_code` char(1) NOT NULL,
  `status_text` varchar(160) NOT NULL,
  `matricula` varchar(32) NOT NULL,
  `cpf` char(11) NOT NULL,
  `valor` decimal(12,2) DEFAULT NULL,
  `raw_line` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `folha_import`
--

INSERT INTO `folha_import` (`id`, `referencia`, `status_code`, `status_text`, `matricula`, `cpf`, `valor`, `raw_line`, `created_at`) VALUES
(356, '2025-05-01', '1', 'Lançado e Efetivado', '0307599', '23993596315', 3000.00, '1    030759-9  MARIA DE JESUS SANTANA COSTA   -                              6580      002     999   001          30.00      002    23993596315', '2025-08-23 22:55:09'),
(357, '2025-05-01', '1', 'Lançado e Efetivado', '2140462', '77623002368', 3000.00, '1    214046-2  ACHIELDER JOSE BARROS ROCHA    AUDGOV-AUDITOR GOVERNAMENTAL   6580      009     999   001          30.00      009    77623002368', '2025-08-23 22:55:09'),
(358, '2025-05-01', '1', 'Lançado e Efetivado', '3319946', '04018631316', 3000.00, '1    3319946 MARIA LUCIA MONTEIRO DA SILVA  2-AGENTE OCUPACIONAL DE NIVEL  6580      012     999   001          30.00      012    04018631316', '2025-08-23 22:55:09'),
(359, '2025-05-01', '1', 'Lançado e Efetivado', '0189936', '34801383300', 3000.00, '1    018993-6  FRANCINEIDE NASCIMENTO SILVA   1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00      012    34801383300', '2025-08-23 22:55:09'),
(360, '2025-05-01', '1', 'Lançado e Efetivado', '0193372', '37112147115', 3000.00, '1    019337-2  JOAO FERREIRA SIMAO            1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00      012    37112147115', '2025-08-23 22:55:09'),
(361, '2025-05-01', '1', 'Lançado e Efetivado', '0194751', '13875051300', 3000.00, '1    019475-1  FRANCISCA MARIA DA SILVA       2-AGENTE OCUPACIONAL DE NIVEL  6580      012     999   001          30.00      012    13875051300', '2025-08-23 22:55:09'),
(362, '2025-05-01', '1', 'Lançado e Efetivado', '0219061', '35236370310', 3000.00, '1    021906-1  JOSE WILSON RIBEIRO            1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00      012    35236370310', '2025-08-23 22:55:09'),
(363, '2025-05-01', '1', 'Lançado e Efetivado', '0360996', '41168755387', 3000.00, '1    036099-6  JOEDI GALVAO DIAS              1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00      012    41168755387', '2025-08-23 22:55:09'),
(364, '2025-05-01', '1', 'Lançado e Efetivado', '0368393', '28740602320', 3000.00, '1    036839-3  MARIA DA GUIA MARTINS          2-AGENTE OCUPACIONAL DE NIVEL  6580      012     999   001          30.00      012    28740602320', '2025-08-23 22:55:09'),
(365, '2025-05-01', '1', 'Lançado e Efetivado', '1595610', '35112344334', 3000.00, '1    159561-0  ZILDA DE ARAUJO BARROS         2-AGENTE OCUPACIONAL DE NIVEL  6580      012     999   001          30.00      012    35112344334', '2025-08-23 22:55:09'),
(366, '2025-05-01', '1', 'Lançado e Efetivado', '2307553', '02417982307', 3000.00, '1    230755-3  ROMERO FERREIRA BASTOS         1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00      012    02417982307', '2025-08-23 22:55:09'),
(367, '2025-05-01', '1', 'Lançado e Efetivado', '0090565', '48717231787', 3000.00, '1    009056-5  MAMEDE RODRIGUES CARDOSO VIEIR DEL.POL-DELEGADO DE POLICIA    6580      027     999   001          30.00      027    48717231787', '2025-08-23 22:55:09'),
(368, '2025-05-01', '1', 'Lançado e Efetivado', '0152706', '39483029368', 3000.00, '1    015270-6  CARLOS ALBERTO DOS SANTOS CARD 12-2 SARGENTO                  6580      028     999   001          30.00      028    39483029368', '2025-08-23 22:55:09'),
(369, '2025-05-01', '1', 'Lançado e Efetivado', '0163767', '13852540330', 3000.00, '1    016376-7  LAUDECY MARIA DE MORAIS FERREI 2-ASSISTENTE / AGENTE DE TRANS 6580      030     999   001          30.00      030    13852540330', '2025-08-23 22:55:09'),
(370, '2025-05-01', '1', 'Lançado e Efetivado', '0279293', '19909454300', 3000.00, '1    027929-3  MARIA DO SOCORRO SANTOS SILVEI -                              6580      090     999   001          30.00      090    19909454300', '2025-08-23 22:55:09'),
(371, '2025-05-01', '1', 'Lançado e Efetivado', '2263041', '78217164720', 3000.00, '1    226304-1  MARIA DOS PRAZERES MACEDO DE S -                              6580      090     999   001          30.00      090    78217164720', '2025-08-23 22:55:09'),
(372, '2025-05-01', '1', 'Lançado e Efetivado', '2322200', '48205885320', 3000.00, '1    232220-0  ANTONIA MARIA DA CONCEICAO     -                              6580      090     999   001          30.00      090    48205885320', '2025-08-23 22:55:09'),
(373, '2025-05-01', '1', 'Lançado e Efetivado', '2660636', '49828401304', 3000.00, '1    266063-6  TENORIO BARBOSA DE FREITAS     -                              6580      090     999   001          30.00      090    49828401304', '2025-08-23 22:55:09'),
(374, '2025-05-01', '1', 'Lançado e Efetivado', '0243108', '10529560330', 3000.00, '1    024310-8  JOSE FRANCISCO RIBEIRO DE SOUS 1-POLICIAL PENAL               6580      095     999   001          30.00      095    10529560330', '2025-08-23 22:55:09'),
(375, '2025-05-01', '1', 'Lançado e Efetivado', '0132764', '35108010320', 3000.00, '1    013276-4  GILBERTO SOUSA                 -3o. SARGENTO                  6580      097     999   001          30.00      097    35108010320', '2025-08-23 22:55:09'),
(376, '2025-05-01', '1', 'Lançado e Efetivado', '0147729', '15221245353', 3000.00, '1    014772-9  RITA MARIA MENDES DA SILVA     -AGENTE OCUPACIONAL DE NIVEL A 6580      097     999   001          30.00      097    15221245353', '2025-08-23 22:55:09'),
(377, '2025-05-01', '1', 'Lançado e Efetivado', '0149306', '37269542368', 3000.00, '1    014930-6  MARCOS ANTONIO VAZ DE BARROS   -3o. SARGENTO                  6580      097     999   001          30.00      097    37269542368', '2025-08-23 22:55:09'),
(378, '2025-05-01', '1', 'Lançado e Efetivado', '0182958', '13028430363', 3000.00, '1    018295-8  VERA LUCIA DE FATIMA LOPES     -AGENTE TECNICO DE SERVICO     6580      097     999   001          30.00      097    13028430363', '2025-08-23 22:55:09'),
(379, '2025-05-01', '1', 'Lançado e Efetivado', '0218332', '10616985304', 3000.00, '1    021833-2  FRANCISCA DAS CHAGAS DE OLIVEI -                              6580      097     999   001          30.00      097    10616985304', '2025-08-23 22:55:09'),
(380, '2025-05-01', '1', 'Lançado e Efetivado', '0358444', '15639754320', 3000.00, '1    035844-4  SONIA MARIA COSTA LIMA DE FREI -AGENTE OPERACIONAL DE SERVICO 6580      097     999   001          30.00      097    15639754320', '2025-08-23 22:55:09'),
(381, '2025-05-01', '1', 'Lançado e Efetivado', '0842290', '45396647353', 3000.00, '1    084229-0  JOSE RIBAMAR SILVEIRA SOBRINHO -3o. SARGENTO                  6580      097     999   001          30.00      097    45396647353', '2025-08-23 22:55:09'),
(382, '2025-05-01', '1', 'Lançado e Efetivado', '0485748', '15146820368', 3000.00, '1    048574-8  MARIA SALOME RABELO            -                              6580      911     999   001          30.00      911    15146820368', '2025-08-23 22:55:09'),
(383, '2025-05-01', '1', 'Lançado e Efetivado', '0506826', '93574177453', 3000.00, '1    050682-6  VIRGINIA MARIA LIMA MATOS DE C -PROFESSOR-40HS                6580      911     999   001          30.00      911    93574177453', '2025-08-23 22:55:09'),
(384, '2025-05-01', '1', 'Lançado e Efetivado', '0512699', '07883684353', 3000.00, '1    051269-9  EDVALDO DA CUNHA COSTA         -PROFESSOR-40HS                6580      911     999   001          30.00      911    07883684353', '2025-08-23 22:55:09'),
(385, '2025-05-01', '1', 'Lançado e Efetivado', '0525618', '88451216315', 3000.00, '1    052561-8  MARILHA FREITAS DE OLIVEIRA    -PROFESSOR-40HS                6580      911     999   001          30.00      911    88451216315', '2025-08-23 22:55:09'),
(386, '2025-05-01', '1', 'Lançado e Efetivado', '0527475', '06541062315', 3000.00, '1    052747-5  MARIA LUIZA MUNIZ GUIMARAES    -                              6580      911     999   001          30.00      911    06541062315', '2025-08-23 22:55:09'),
(387, '2025-05-01', '1', 'Lançado e Efetivado', '0533629', '03028801353', 3000.00, '1    053362-9  MARIA DAS GRACAS PORTELA VELOS -                              6580      911     999   001          30.00      911    03028801353', '2025-08-23 22:55:09'),
(388, '2025-05-01', '1', 'Lançado e Efetivado', '0573078', '74333437334', 3000.00, '1    057307-8  FRANCISCA MARIA DE SOUSA NETA  -PROFESSOR-40HS                6580      911     999   001          30.00      911    74333437334', '2025-08-23 22:55:09'),
(389, '2025-05-01', '1', 'Lançado e Efetivado', '0575828', '18444806315', 3000.00, '1    057582-8  ANA ROSALVA DO CARMO FERREIRA  -PROFESSOR-40HS                6580      911     999   001          30.00      911    18444806315', '2025-08-23 22:55:09'),
(390, '2025-05-01', '1', 'Lançado e Efetivado', '0583618', '22686240300', 3000.00, '1    058361-8  FRANCISCA DAS CHAGAS MELO ANDR -PROFESSOR-40HS                6580      911     999   001          30.00      911    22686240300', '2025-08-23 22:55:09'),
(391, '2025-05-01', '1', 'Lançado e Efetivado', '0583669', '19942087320', 3000.00, '1    058366-9  TANIA MARY ROSA CAVALCANTE     -PROFESSOR-40HS                6580      911     999   001          30.00      911    19942087320', '2025-08-23 22:55:09'),
(392, '2025-05-01', '1', 'Lançado e Efetivado', '0586552', '28672100387', 3000.00, '1    058655-2  LUIZA MARIA BATISTA            -PROFESSOR-40HS                6580      911     999   001          30.00      911    28672100387', '2025-08-23 22:55:09'),
(393, '2025-05-01', '1', 'Lançado e Efetivado', '0590819', '13054783391', 3000.00, '1    059081-9  MARIA DOLORES FERREIRA BONFIM  -PROFESSOR-40HS                6580      911     999   001          30.00      911    13054783391', '2025-08-23 22:55:09'),
(394, '2025-05-01', '1', 'Lançado e Efetivado', '0610313', '14552655353', 3000.00, '1    061031-3  JANE MARY OLIVEIRA  CRUZ       -PROFESSOR-40HS                6580      911     999   001          30.00      911    14552655353', '2025-08-23 22:55:09'),
(395, '2025-05-01', '1', 'Lançado e Efetivado', '0647179', '06670490372', 3000.00, '1    064717-9  LIEDA LINO DE CARVALHO         -PROFESSOR-40HS                6580      911     999   001          30.00      911    06670490372', '2025-08-23 22:55:09'),
(396, '2025-05-01', '1', 'Lançado e Efetivado', '0668427', '07936672320', 3000.00, '1    066842-7  MARIA ESTER DA SILVA           -                              6580      911     999   001          30.00      911    07936672320', '2025-08-23 22:55:09'),
(397, '2025-05-01', '1', 'Lançado e Efetivado', '0684783', '19906358300', 3000.00, '1    068478-3  FRANCISCA ARAUJO DA ANUNCIACAO -                              6580      911     999   001          30.00      911    19906358300', '2025-08-23 22:55:09'),
(398, '2025-05-01', '1', 'Lançado e Efetivado', '0736970', '31507310382', 3000.00, '1    073697-0  MARIA DE LOURDES SOUSA         -PROFESSOR-40HS                6580      911     999   001          30.00      911    31507310382', '2025-08-23 22:55:09'),
(399, '2025-05-01', '1', 'Lançado e Efetivado', '0740616', '24011886300', 3000.00, '1    074061-6  MARIA DO SOCORRO DE SA FREITAS -PROFESSOR-40HS                6580      911     999   001          30.00      911    24011886300', '2025-08-23 22:55:09'),
(400, '2025-05-01', '1', 'Lançado e Efetivado', '0750514', '13258354391', 3000.00, '1    075051-4  LUZIA PEREIRA DA SILVA         -PROFESSOR-40HS                6580      911     999   001          30.00      911    13258354391', '2025-08-23 22:55:09'),
(401, '2025-05-01', '1', 'Lançado e Efetivado', '0759325', '21712069349', 3000.00, '1    075932-5  NESTOR NERES DA SILVA          -PROFESSOR-40HS                6580      911     999   001          30.00      911    21712069349', '2025-08-23 22:55:09'),
(402, '2025-05-01', '1', 'Lançado e Efetivado', '0761222', '22776486391', 3000.00, '1    076122-2  MARIA DA CONCEICAO SILVA DAMIA -PROFESSOR-40HS                6580      911     999   001          30.00      911    22776486391', '2025-08-23 22:55:09'),
(403, '2025-05-01', '1', 'Lançado e Efetivado', '098638X', '06646824304', 3000.00, '1    098638-X  RAIMUNDO RAMOS NERES           -PROFESSOR-40HS                6580      911     999   001          30.00      911    06646824304', '2025-08-23 22:55:09'),
(404, '2025-05-01', '1', 'Lançado e Efetivado', '0613410', '22629165353', 3000.00, '1    061341-0  IVALDO DANIEL DA SILVA         1-AGENTE OPERACIONAL DE SERVIC 6580      914     999   001          30.00      914    22629165353', '2025-08-23 22:55:09'),
(405, '2025-05-01', '1', 'Lançado e Efetivado', '0732206', '32785488334', 3000.00, '1    073220-6  MARIA DE JESUS LEITE DE SOUSA  -                              6580      914     999   001          30.00      914    32785488334', '2025-08-23 22:55:09'),
(406, '2025-05-01', '1', 'Lançado e Efetivado', '0769452', '04707052304', 3000.00, '1    076945-2  JOSE RIBAMAR SILVA             1-AGENTE OPERACIONAL DE SERVIC 6580      914     999   001          30.00      914    04707052304', '2025-08-23 22:55:09'),
(407, '2025-05-01', '1', 'Lançado e Efetivado', '1043382', '22629149315', 3000.00, '1    104338-2  JOAO ROSA PAES LANDIM NETO     1-PROFESSOR 40H                6580      914     999   001          30.00      914    22629149315', '2025-08-23 22:55:09'),
(408, '2025-05-01', '1', 'Lançado e Efetivado', '1160311', '62220632334', 3000.00, '1    116031-1  PAULO CESAR DO NASCIMENTO REGO 1-PROFESSOR 40H                6580      914     999   001          30.00      914    62220632334', '2025-08-23 22:55:09'),
(409, '2025-05-01', '1', 'Lançado e Efetivado', '2267420', '99753880359', 3000.00, '1    226742-0  CARLA SUYANNE TORRES SANTANA   1-AGENTE OPERACIONAL DE SERVIC 6580      914     999   001          30.00      914    99753880359', '2025-08-23 22:55:09'),
(410, '2025-05-01', '2', 'Não Lançado por Falta de Margem Temporariamente', '0190616', '21819424391', 3000.00, '2    019061-6  FRANCISCO CRISOSTOMO BATISTA   2-AGENTE TECNICO DE SERVICO    6580      012     999   001          30.00      012    21819424391', '2025-08-23 22:55:09'),
(411, '2025-05-01', '2', 'Não Lançado por Falta de Margem Temporariamente', '0307408', '04737989304', 3000.00, '2    030740-8  VALTEMBERG DE BRITO FIRMEZA    -                              6580      097     999   001          30.00      097    04737989304', '2025-08-23 22:55:09'),
(412, '2025-05-01', '2', 'Não Lançado por Falta de Margem Temporariamente', '1668676', '18220860359', 3000.00, '2    166867-6  JUNIVAL DA SILVA RIBEIRO       -SOLDADO                       6580      097     999   001          30.00      097    18220860359', '2025-08-23 22:55:09'),
(413, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0191353', '34945466300', 3000.00, '3    019135-3  JAQUELINA DA SILVA SOARES      1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00             34945466300', '2025-08-23 22:55:09'),
(414, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0212938', '18084974300', 3000.00, '3    021293-8  MIGUEL ALVES DO NASCIMENTO     1-AGENTE OPERACIONAL DE SERVIC 6580      012     999   001          30.00             18084974300', '2025-08-23 22:55:09'),
(415, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0264458', '06841350359', 3000.00, '3    026445-8  AURELIO DE JESUS NOLETO        2-NIVEL FUNCIONAL TECNICO      6580      016     999   001          30.00             06841350359', '2025-08-23 22:55:09'),
(416, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0368130', '28719956304', 3000.00, '3    036813-0  MARIA DA CONCEICAO FERNANDES G                                6580      012     999   001          30.00             28719956304', '2025-08-23 22:55:09'),
(417, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0472158', '39752437320', 3000.00, '3    047215-8  AILLEY DE MOURA PASSOS         Agente de Polícia              6580      027     999   001          30.00             39752437320', '2025-08-23 22:55:09'),
(418, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0640328', '27373185304', 3000.00, '3    064032-8  ILMA MAIA DOS SANTOS BATISTA   -AGENTE OPERACIONAL DE SERVICO 6580      911     999   001          30.00             27373185304', '2025-08-23 22:55:09'),
(419, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0652997', '67556906353', 3000.00, '3    065299-7  ALCEANIRA BOAVENTURA E SILVA   ZELADOR (A)                    6580      911     999   001          30.00             67556906353', '2025-08-23 22:55:09'),
(420, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '0800503', '45065209391', 3000.00, '3    080050-3  GENIVAL PEREIRA DE ARAUJO      12-CABO                        6580      028     999   001          30.00             45065209391', '2025-08-23 22:55:09'),
(421, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '092161X', '67556906353', 3000.00, '3    092161-X  ALCEANIRA BOAVENTURA E SILVA   SERVENTE - A                   6580      090     999   001          30.00             67556906353', '2025-08-23 22:55:09'),
(422, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '211908X', '00455709300', 3000.00, '3    211908-X  ROMULO LINHARES MOURA          -                              6580      156     999   001          30.00             00455709300', '2025-08-23 22:55:09'),
(423, '2025-05-01', '3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)', '2917971', '15222748391', 3000.00, '3    291797-1  GONCALO PEREIRA DA SILVA       2SG-1o. SARGENTO               6580      028     999   001          30.00             15222748391', '2025-08-23 22:55:09'),
(424, '2025-05-01', '4', 'Lançado com Valor Diferente', '1089935', '48204773315', 3000.00, '4    108993-5  MARIA DE JESUS ARAUJO GONCALVE -                              6580      090     999   001          30.00      090    48204773315', '2025-08-23 22:55:09'),
(425, '2025-05-01', '4', 'Lançado com Valor Diferente', '0543314', '18349960310', 3000.00, '4    054331-4  LUCINEIDE DE SA CARVALHO COELH -PROFESSOR-40HS                6580      911     999   001          30.00      911    18349960310', '2025-08-23 22:55:09'),
(426, '2025-05-01', '4', 'Lançado com Valor Diferente', '0599387', '15224643368', 3000.00, '4    059938-7  MARIA CACILDA SOUZA VIEIRA     -AGENTE TECNICO DE SERVICO     6580      911     999   001          30.00      911    15224643368', '2025-08-23 22:55:09');

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_lancamento`
--

CREATE TABLE `folha_lancamento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `arquivo_id` bigint(20) UNSIGNED NOT NULL,
  `status_code` char(1) NOT NULL,
  `matricula_raw` varchar(20) NOT NULL,
  `matricula_norm` varchar(20) GENERATED ALWAYS AS (ucase(replace(replace(replace(`matricula_raw`,'-',''),'.',''),' ',''))) VIRTUAL,
  `nome` varchar(150) NOT NULL,
  `cargo` varchar(190) NOT NULL,
  `fin_codigo` char(4) NOT NULL,
  `orgao_codigo` char(3) NOT NULL,
  `lanc_codigo` char(3) NOT NULL,
  `total_pago_qtd` smallint(5) UNSIGNED DEFAULT NULL,
  `valor` decimal(12,2) DEFAULT NULL,
  `orgao_pagto_codigo` char(3) NOT NULL,
  `cpf` char(11) NOT NULL,
  `raw_line` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_lancamento_simples`
--

CREATE TABLE `folha_lancamento_simples` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `status` char(1) NOT NULL,
  `matricula` varchar(20) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `cargo` varchar(190) NOT NULL,
  `fin` char(4) NOT NULL,
  `orgao` char(3) NOT NULL,
  `lanc` char(3) NOT NULL,
  `total_pago` smallint(5) UNSIGNED DEFAULT NULL,
  `valor` decimal(12,2) DEFAULT NULL,
  `orgao_pagto` char(3) NOT NULL,
  `cpf` char(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `contato_retorno` varchar(500) DEFAULT NULL,
  `contato_operador` varchar(100) DEFAULT NULL,
  `contato_status` varchar(30) DEFAULT NULL,
  `contato_atualizado_em` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `folha_lancamento_simples`
--

INSERT INTO `folha_lancamento_simples` (`id`, `status`, `matricula`, `nome`, `cargo`, `fin`, `orgao`, `lanc`, `total_pago`, `valor`, `orgao_pagto`, `cpf`, `created_at`, `contato_retorno`, `contato_operador`, `contato_status`, `contato_atualizado_em`) VALUES
(835, '1', '161578-5', 'JOSE HENRY CAVALCANTE', '3-AGENTE SUPERIOR DE SERVICO', '0580', '0', '01', 1, 100.35, '001', '09592547300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(836, '1', '002612-3', 'WERNECK NUNES DE OLIVEIRA', '3-AGENTE DE TRIBUTOS DA FAZEND', '0580', '0', '09', 9, 395.83, '009', '15099253334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(837, '1', '002750-2', 'CLAUDIA MARIA SILVA DANTAS AVE', '3-AGENTE DE TRIBUTOS DA FAZEND', '0580', '0', '09', 9, 179.69, '009', '24056944334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(838, '1', '003251-4', 'FRANCISCO DE FREITAS TELES FIL', '3-AGENTE DE TRIBUTOS DA FAZEND', '0580', '0', '09', 9, 767.05, '009', '16082710304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(839, '1', '221719-8', 'IVONETE DA MOTA DIAS RAMOS', '1-PROFESSOR 40H', '0580', '0', '11', 11, 74.00, '011', '45364613372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(840, '1', '001282-3', 'MARIA AUXILIADORA DE JESUS CAB', '3-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 334.00, '012', '13303813353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(841, '1', '004217-0', 'FRANCISCA INACIA NETA SILVA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 190.23, '012', '65417550353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(842, '1', '019022-5', 'MARIA DE FATIMA CARVALHO', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '0', '12', 12, 136.49, '012', '35102365304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(843, '1', '019234-1', 'KATIA MARIA PEREIRA', '3-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 84.32, '012', '18254586349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(844, '1', '021084-6', 'FRANCISCO DE ASSIS BATISTA DOS', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '0', '12', 12, 79.60, '012', '33827710391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(845, '1', '026485-7', 'FRANCINEIDE LOPES DE OLIVEIRA', '2-AGENTE TECNICO DE SERVICO', '0580', '0', '12', 12, 83.40, '012', '39395480300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(846, '1', '041244-9', 'MARIA DA SOLIDADE SANTOS VIEIR', '2-AGENTE TECNICO DE SERVICO', '0580', '0', '12', 12, 110.00, '012', '19989369372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(847, '1', '043149-4', 'MARIA DE FATIMA ROCHA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 104.35, '012', '18433367315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(848, '1', '044422-7', 'OTAVIO GONZAGA FERREIRA', '-AGENTE OPERACIONAL DE SERVICO', '0580', '0', '12', 12, 79.02, '012', '00446110809', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(849, '1', '159600-4', 'URSIMAR FERREIRA DE OLIVEIRA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 82.00, '012', '30718643372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(850, '1', '159623-3', 'MARIA DOS REMEDIOS FERREIRA SA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 118.12, '012', '32223579353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(851, '1', '170421-4', 'VERALUCIA MACEDO BAIA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 301.00, '012', '39656730330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(852, '1', '197586-2', 'MARGARONI ARAUJO RIPARDO', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 77.21, '012', '07427677790', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(853, '1', '197906-0', 'FRANCISCA RODRIGUES DE MOURA F', '2-MEDICO - PLANTO PRESENCIAL -', '0580', '0', '12', 12, 880.00, '012', '33796955304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(854, '1', '209886-5', 'PAULINA MARIA NETA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 78.52, '012', '73203270315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(855, '1', '218790-6', 'FRANCISCA MARIA OLIVEIRA BORGE', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 140.95, '012', '53489373391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(856, '1', '228778-1', 'RAIMUNDA DE JESUS SILVA OLIVEI', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 300.11, '012', '66167574391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(857, '1', '280209-X', 'FELISMINA MARIA PEREIRA', '2-AGENTE OCUPACIONAL DE NIVEL', '0580', '0', '12', 12, 88.00, '012', '76661857315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(858, '1', '287058-4', 'VIRGINIAN CHRISTIANI LIMA VALE', '2-MEDICO - PLANTO PRESENCIAL -', '0580', '0', '12', 12, 326.00, '012', '38231573291', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(859, '1', '013548-8', 'JOSIAS ALMEIDA DA PAIXAO', 'CC017-TECNICO NIVEL SUPERIOR', '0580', '0', '15', 15, 152.88, '015', '28698908349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(860, '1', '026457-1', 'FRANCISCO DAS CHAGAS NETO', '1-NIVEL AUXILIAR', '0580', '0', '16', 16, 190.00, '016', '30662206304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(861, '1', '006932-9', 'FRANCISCO FERNANDO DA ROCHA', '1-AGENTE OPERACIONAL DE SERVIO', '0580', '0', '21', 21, 83.19, '021', '28664701334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(862, '1', '009036-X', 'ANA LUCIA DE OLIVEIRA LOPES AP', 'ESC.POL-ESCRIVAO DE POLICIA', '0580', '0', '27', 27, 422.23, '027', '20070934304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(863, '1', '009121-9', 'JUAREZ DE SOUSA PEREIRA', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 245.00, '027', '06689370330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(864, '1', '009213-4', 'ELSA DIAS GUIMARAES', 'ESC.POL-ESCRIVAO DE POLICIA', '0580', '0', '27', 27, 250.00, '027', '20803303300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(865, '1', '009425-X', 'VALDEZ SILVA VIEIRA', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 236.87, '027', '34795464391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(866, '1', '009566-4', 'LOURIVAL ESTEVES SANTIAGO', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 425.55, '027', '30636167372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(867, '1', '010014-5', 'ROSA ALVES DE ALMEIDA', 'AGTESE-AGENTE TECNICO DE SERVI', '0580', '0', '27', 27, 101.95, '027', '10566228300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(868, '1', '024276-4', 'FRANCISCO DE ASSIS VIEIRA', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 199.69, '027', '16112504391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(869, '1', '047218-2', 'JOSE RIBAMAR DE SOUSA BARROS', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 265.00, '027', '15224406315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(870, '1', '079130-0', 'VALDINEIA LEMOS DE SOUSA', 'AGTESE-AGENTE TECNICO DE SERVI', '0580', '0', '27', 27, 71.46, '027', '35289554300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(871, '1', '086702-X', 'ETEVALDO DE ANDRADE FILHO', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 347.00, '027', '44606362391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(872, '1', '108338-4', 'GILMAR NUNES DA SILVA', 'ESC.POL-ESCRIVAO DE POLICIA', '0580', '0', '27', 27, 375.31, '027', '36163163320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(873, '1', '108524-7', 'ERNANI MOURA LIMA', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 191.00, '027', '21867811820', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(874, '1', '166855-2', 'MARCUS ANTONIO PINHEIRO DE VAS', 'PER.CRIM-PERITO CRIMINAL', '0580', '0', '27', 27, 583.96, '027', '18605168315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(875, '1', '199309-7', 'HIGGO MARTINS MOURA', 'DEL.POL-DELEGADO DE POLICIA', '0580', '0', '27', 27, 646.00, '027', '84536195300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(876, '1', '245978-7', 'VALERIA CRISTINA DA SILVA CUNH', 'DEL.POL-DELEGADO DE POLICIA', '0580', '0', '27', 27, 160.85, '027', '01843564319', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(877, '1', '258570-7', 'PAULO HENRIQUE PINHEIRO DE VAS', 'PER.CRIM-PERITO CRIMINAL', '0580', '0', '27', 27, 322.45, '027', '28745647372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(878, '1', '299123-3', 'ANA CAROLINA TOBLER GOMES', 'ESC.POL-ESCRIVAO DE POLICIA', '0580', '0', '27', 27, 196.00, '027', '60027996301', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(879, '1', '311262-4', 'ROBERSON ALVES DOS SANTOS', 'AG.POL-AGENTE DE POLICIA', '0580', '0', '27', 27, 430.00, '027', '02177009340', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(880, '1', '357719-8', 'SAMMYA VANESSA DE ALMEIDA MACI', 'PER.CRIM-PERITO CRIMINAL', '0580', '0', '27', 27, 276.20, '027', '00419653376', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(881, '1', '012672-1', 'LUIZ CLAUDIO DE SOUSA MEDEIROS', '11-SUBTENENTE', '0580', '0', '28', 28, 135.98, '028', '30602033349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(882, '1', '013282-9', 'JOSE DA SILVA MATOS', '11-SUBTENENTE', '0580', '0', '28', 28, 500.00, '028', '33746826349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(883, '1', '013365-5', 'WASHINGTON CHAVES GOMES', 'CC017-TECNICO NIVEL SUPERIOR', '0580', '0', '28', 28, 139.80, '028', '35108339372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(884, '1', '013445-7', 'SALMERON DA SILVA', 'CC007-DIRETOR', '0580', '0', '28', 28, 173.30, '028', '28735307315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(885, '1', '013570-4', 'CARLOS CESAR VIEIRA', '13-CABO', '0580', '0', '28', 28, 91.00, '028', '47439491300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(886, '1', '013749-9', 'VLADIMIR PEREIRA LOPES', '8-2 TENENTE', '0580', '0', '28', 28, 343.19, '028', '30637759320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(887, '1', '014660-9', 'FRANCISCO ELISMARIO VIEIRA DO', '11-1 SARGENTO', '0580', '0', '28', 28, 86.00, '028', '41194420397', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(888, '1', '014800-8', 'ELIZEU GOMES VIEIRA', '5-CAPITAO', '0580', '0', '28', 28, 155.65, '028', '43972705387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(889, '1', '015168-8', 'JOAO PEDRO RODRIGUES FERREIRA', 'CC007-DIRETOR', '0580', '0', '28', 28, 110.00, '028', '39571009334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(890, '1', '015962-0', 'MARCOS JOSE DE MOURA', '12-3 SARGENTO', '0580', '0', '28', 28, 134.43, '028', '45140162334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(891, '1', '016042-3', 'MARCOS ANTONIO HORTENCIO SANTO', '3-TENENTE-CORONEL', '0580', '0', '28', 28, 242.50, '028', '34801278353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(892, '1', '079635-2', 'JOAO DE DEUS SOARES BEZERRA', '12-3 SARGENTO', '0580', '0', '28', 28, 266.11, '028', '32820640397', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(893, '1', '079675-1', 'RENATO RODRIGUES DA SILVA', '12-3 SARGENTO', '0580', '0', '28', 28, 184.00, '028', '48205125368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(894, '1', '079993-9', 'HILTON RIBEIRO CASTELO BRANCO', '12-3 SARGENTO', '0580', '0', '28', 28, 84.58, '028', '48185051372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(895, '1', '080255-7', 'ODVALY SOARES DA SILVA', '12-3 SARGENTO', '0580', '0', '28', 28, 125.00, '028', '53753186368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(896, '1', '080737-X', 'NEWMARCOS PESSOA BASILIO', '3-CORONEL', '0580', '0', '28', 28, 256.70, '028', '42873037334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(897, '1', '082532-8', 'ANTONIO SOARES NASCIMENTO', '12-3 SARGENTO', '0580', '0', '28', 28, 153.00, '028', '46295739334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(898, '1', '082561-1', 'MAURO JOSE DE SOUSA', '12-3 SARGENTO', '0580', '0', '28', 28, 117.00, '028', '39459594387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(899, '1', '082649-9', 'DEUZACI RODRIGUES DA ROCHA', 'CC007-DIRETOR', '0580', '0', '28', 28, 84.10, '028', '39371972300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(900, '1', '084190-X', 'ANTONIO DE PADUA PEREIRA DE AR', '12-3 SARGENTO', '0580', '0', '28', 28, 99.00, '028', '56654642368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(901, '1', '084240-X', 'RAIMUNDO NONATO BORGES DO NASC', '12-3 SARGENTO', '0580', '0', '28', 28, 120.09, '028', '47909730349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(902, '1', '084379-2', 'CLEITON LUIS SERAINE CUSTODIO', '12-SUBTENENTE', '0580', '0', '28', 28, 95.04, '028', '02052187766', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(903, '1', '084389-0', 'FELIX BISPO DOS SANTOS FILHO', '12-CABO', '0580', '0', '28', 28, 82.78, '028', '35060727300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(904, '1', '084709-7', 'ADRIANA LIMA DA SILVA', '12-3 SARGENTO', '0580', '0', '28', 28, 105.00, '028', '47902051349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(905, '1', '084759-3', 'REGIA SAMARA CRUZ RAMOS RODRIG', '4-CAPITAO', '0580', '0', '28', 28, 195.00, '028', '70486360334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(906, '1', '085379-8', 'PEDRO MOREIRA DA SILVA', '4-CAPITAO', '0580', '0', '28', 28, 133.50, '028', '52671917368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(907, '1', '085675-4', 'JOSE ETEYLSON MENDES PESSOA', '13-CABO', '0580', '0', '28', 28, 200.00, '028', '45055335300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(908, '1', '085893-5', 'ROGERIO FARIAS DOS SANTOS', '12-3 SARGENTO', '0580', '0', '28', 28, 120.00, '028', '53698827387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(909, '1', '087974-6', 'HENRY JONY SAMPAIO MENESES', '5-CAPITAO', '0580', '0', '28', 28, 170.00, '028', '47050896349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(910, '1', '092352-4', 'ALVARO DOS SANTOS LEBRE', '3-MAJOR', '0580', '0', '28', 28, 139.00, '028', '77035305300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(911, '1', '107681-7', 'RAIMUNDO QUARESMA VIEIRA E SIL', '12-3 SARGENTO', '0580', '0', '28', 28, 71.66, '028', '71431330353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(912, '1', '107697-3', 'ISAUMIR IRINEU DE SOUSA', '12-3 SARGENTO', '0580', '0', '28', 28, 136.33, '028', '77028406334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(913, '1', '107760-X', 'CARLOS EUGENIO E SILVA', '12-CABO', '0580', '0', '28', 28, 78.44, '028', '85533858334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(914, '1', '107784-8', 'LINDOMAR JARDIM LOPES JUNIOR', '12-3 SARGENTO', '0580', '0', '28', 28, 70.92, '028', '76930653349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(915, '1', '107828-3', 'JOUBER DELANO FONSECA DE AMORI', '11-1 SARGENTO', '0580', '0', '28', 28, 77.15, '028', '79758371304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(916, '1', '107835-6', 'ANTONIO GALVAO DA COSTA', '12-3 SARGENTO', '0580', '0', '28', 28, 464.26, '028', '71463739320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(917, '1', '160311-6', 'KLEITON PEREIRA DOS SANTOS', '12-3 SARGENTO', '0580', '0', '28', 28, 170.95, '028', '62400460353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(918, '1', '160314-X', 'MARCELO BACELAR AMANCIO', '12-3 SARGENTO', '0580', '0', '28', 28, 72.58, '028', '99240327304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(919, '1', '179465-5', 'RAPHAEL CARVALHO DA SILVA', '12-CABO', '0580', '0', '28', 28, 98.43, '028', '01443900354', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(920, '1', '206333-6', 'JOSE ANTONIO DE MORAIS LIMA', '13-CABO', '0580', '0', '28', 28, 82.61, '028', '00244431310', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(921, '1', '244038-5', 'RENAN MAMEDE FONTENELE', '12-3 SARGENTO', '0580', '0', '28', 28, 117.08, '028', '00754441350', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(922, '1', '288536-X', 'ARTHUR MENDES DE SOUSA', '13-CABO', '0580', '0', '28', 28, 74.48, '028', '00661025373', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(923, '1', '288573-5', 'FLAVIO TORRES DE CARVALHO', '13-CABO', '0580', '0', '28', 28, 81.93, '028', '00821091506', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(924, '1', '288882-3', 'JOSIVALDO SOUSA DO NASCIMENTO', '13-CABO', '0580', '0', '28', 28, 163.66, '028', '02272110304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(925, '1', '289020-8', 'ANTONIO COSTA NASCIMENTO', '13-CABO', '0580', '0', '28', 28, 1180.00, '028', '04630654330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(926, '1', '289069-X', 'ARINALDO PEREIRA DOS SANTOS', '13-CABO', '0580', '0', '28', 28, 148.21, '028', '03110505304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(927, '1', '297688-9', 'RAFAEL MAX SOARES MARINHO', '13-CABO', '0580', '0', '28', 28, 83.17, '028', '03735326366', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(928, '1', '309943-1', 'ARTUR GOMES FERREIRA', '13-CABO', '0580', '0', '28', 28, 82.11, '028', '05241822569', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(929, '1', '309946-6', 'CLEIDSON ALVES PEREIRA', '13-CABO', '0580', '0', '28', 28, 81.89, '028', '01613835485', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(930, '1', '310026-0', 'GABRIEL LINCON DA SILVA DIAS', '13-CABO', '0580', '0', '28', 28, 110.60, '028', '04683158370', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(931, '1', '310132-X', 'GERSON PABLO ALVES DA SILVA', '13-CABO', '0580', '0', '28', 28, 94.89, '028', '04413883373', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(932, '1', '310172-0', 'FERNANDO RODRIGUES DA MOTA', '13-CABO', '0580', '0', '28', 28, 100.00, '028', '02736528344', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(933, '1', '310191-6', 'PEDRO ROGERIO LIMA DE OLIVEIRA', '13-CABO', '0580', '0', '28', 28, 110.65, '028', '04227837308', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(934, '1', '310205-0', 'JULIO CESAR ALVES FEITOSA', '13-CABO', '0580', '0', '28', 28, 72.00, '028', '00362954348', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(935, '1', '331493-6', 'MITALY TUANY OLIVEIRA MACEDO M', '13-CABO', '0580', '0', '28', 28, 75.00, '028', '04984249366', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(936, '1', '382343-1', 'FELIPE DOS SANTOS', '13-SOLDADO', '0580', '0', '28', 28, 79.00, '028', '05668356302', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(937, '1', '382374-1', 'ROMERITO PEREIRA DE CARVALHO', '13-SOLDADO', '0580', '0', '28', 28, 116.61, '028', '01988914310', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(938, '1', '382428-4', 'FLAVIANO RODRIGUES MEDEIROS', '13-SOLDADO', '0580', '0', '28', 28, 78.00, '028', '02472858540', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(939, '1', '385720-4', 'ADALBERTO SANTOS ANDRADE', '13-SOLDADO', '0580', '0', '28', 28, 80.00, '028', '06387360307', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(940, '1', '385728-0', 'LUIZ FERREIRA CALACO FILHO', '13-SOLDADO', '0580', '0', '28', 28, 376.00, '028', '44871711803', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(941, '1', '386087-6', 'MATEUS YAN DE ALENCAR FREITAS', '-SOLDADO', '0580', '0', '28', 28, 97.40, '028', '07060512381', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(942, '1', '404840-7', 'RODRIGO DE OLIVEIRA FRANCA', '-SOLDADO', '0580', '0', '28', 28, 80.72, '028', '06203745359', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(943, '1', '404855-5', 'CARLOS AUGUSTO NASCIMENTO MACE', '13-SOLDADO', '0580', '0', '28', 28, 164.27, '028', '61668883333', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(944, '1', '425488-X', 'GERMANO HOLANDA DE OLIVEIRA', '7-2 TENENTE', '0580', '0', '28', 28, 630.00, '028', '06670642300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(945, '1', '431448-4', 'ANTONIO JOSE VITALINO DA SILVA', '-', '0580', '0', '28', 28, 324.46, '028', '05797061333', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(946, '1', '431624-0', 'GEISSA DUARTE DE AGUIAR', '-', '0580', '0', '28', 28, 758.46, '028', '05712626357', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(947, '1', '431669-0', 'IGO RAFAEL DE ANDRADE DOS SANT', '-', '0580', '0', '28', 28, 758.46, '028', '09452205458', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(948, '1', '431717-3', 'JOAO LUIZ ALVES JUCA', '-', '0580', '0', '28', 28, 311.50, '028', '05666699350', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(949, '1', '431751-3', 'JULIO CANDIDO DA SILVA NETO', '-', '0580', '0', '28', 28, 447.00, '028', '04640880383', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(950, '1', '431987-7', 'THAYSON WALLACE WAQUIM OLIVEIR', '-', '0580', '0', '28', 28, 300.00, '028', '01110173350', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(951, '1', '016625-1', 'MARIA DO ROSARIO DE FATIMA PIM', '2-ASSISTENTE / AGENTE DE TRANS', '0580', '0', '30', 30, 141.25, '030', '18398855304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(952, '1', '268393-8', 'DOMINGOS SAVIO JACINTO E SILVA', '8-PROFESSOR ASSISTENTE DEDICAC', '0580', '0', '89', 89, 127.70, '089', '13238019368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(953, '1', '280259-7', 'ANNETH CARDOSO BASILIO DA SILV', '11-PROFESSOR ADJUNTO 40HS', '0580', '0', '89', 89, 150.37, '089', '35313510363', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(954, '1', '280714-9', 'JAYRON VIANA DOS SANTOS', '5-PROFESSOR AUXILIAR 40HS', '0580', '0', '89', 89, 200.00, '089', '01834995302', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(955, '1', '001830-9', 'REGINA LUCIA DA SILVA CRUZ', '-', '0580', '0', '90', 90, 183.70, '090', '15139123304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(956, '1', '009371-8', 'MARIA AMELIA SANTOS ARAUJO', '-', '0580', '0', '90', 90, 143.26, '090', '34001310325', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(957, '1', '011085-0', 'MARIA DOS SANTOS LEITE FERREIR', '-', '0580', '0', '90', 90, 87.00, '090', '13250728349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(958, '1', '028852-7', 'MARIA DE JESUS DO BONFIM DO NA', '-', '0580', '0', '90', 90, 77.00, '090', '13319183320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(959, '1', '029340-7', 'MARIA DO SOCORRO SILVA BRITO', '-', '0580', '0', '90', 90, 153.27, '090', '64488225349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(960, '1', '029447-X', 'LAELIA CHAVES DE SOUSA LIMA', '-', '0580', '0', '90', 90, 95.00, '090', '47897082334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(961, '1', '040201-0', 'MARIA JOSE OLIVEIRA MOTA', '-', '0580', '0', '90', 90, 123.23, '090', '73429490359', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(962, '1', '107194-7', 'WALERIA URQUIZIA DE CASTRO MOT', '-', '0580', '0', '90', 90, 185.23, '090', '01080191364', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(963, '1', '114155-4', 'JOAO NILSON PEREIRA LIMA', '-', '0580', '0', '90', 90, 167.95, '090', '43306519391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(964, '1', '129118-1', 'ORLENE MARTINS DO NASCIMENTO', '-', '0580', '0', '90', 90, 129.96, '090', '06668011349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(965, '1', '131463-7', 'ANTONIO DANILO DE PINHO TEIXEI', '-', '0580', '0', '90', 90, 253.00, '090', '09994033387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(966, '1', '168979-7', 'MARIA DE JESUS BORGES DA SILVA', '-', '0580', '0', '90', 90, 71.40, '090', '02712846338', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(967, '1', '170525-3', 'ANTONIA MARIA ARAUJO COUTINHO', '-', '0580', '0', '90', 90, 91.97, '090', '00513517308', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(968, '1', '196005-9', 'MARIA JOSE DE CASTRO BARBOSA', '-', '0580', '0', '90', 90, 258.91, '090', '34305874334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(969, '1', '211813-X', 'FRANCISCO DAS CHAGAS ROBERTO D', '-', '0580', '0', '90', 90, 86.00, '090', '22719016349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(970, '1', '224275-3', 'MARIA DE JESUS M MONTEIRO', '-', '0580', '0', '90', 90, 214.56, '090', '01114781380', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(971, '1', '245299-5', 'CARLOS ALBERTO BATISTA DA COST', '-PENSAO CIVIL', '0580', '0', '90', 90, 178.51, '090', '07851090300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(972, '1', '268758-5', 'HERDEN DINIZ BRASILEIRO', '-PENSAO CIVIL', '0580', '0', '90', 90, 199.03, '090', '41227840349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(973, '1', '269053-5', 'MARIA DAS MERCES RIBEIRO DE MA', '-', '0580', '0', '90', 90, 190.00, '090', '39792714391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(974, '1', '272406-5', 'FRANCISCA MARIA MONTE SILVA', '-', '0580', '0', '90', 90, 243.60, '090', '30547458304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(975, '1', '281427-7', 'CICERA ALVES DO NASCIMENTO', '-', '0580', '0', '90', 90, 97.00, '090', '13862812391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(976, '1', '308821-9', 'LUCIA DE FATIMA M BARBOSA', '-', '0580', '0', '90', 90, 250.80, '090', '35367903304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(977, '1', '315630-3', 'MARIA LUIZA DA SILVA', '-PENSAO CIVIL', '0580', '0', '90', 90, 100.00, '090', '06631185300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(978, '1', '329970-8', 'FATIMA BASTOS DE VASCONCELOS', '-PENSAO CIVIL', '0580', '0', '90', 90, 251.38, '090', '87885123391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(979, '1', '333994-7', 'MARIA DO ROSARIO DE MIRANDA BE', '-PENSAO CIVIL', '0580', '0', '90', 90, 160.22, '090', '47439378334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(980, '1', '342162-7', 'FRANCISCA DAS CHAGAS FERREIRA', '-PENSAO CIVIL', '0580', '0', '90', 90, 432.05, '090', '64715590387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(981, '1', '349483-7', 'HELENA LIMA DE CASTRO ARAUJO', '-PENSAO CIVIL', '0580', '0', '90', 90, 93.36, '090', '27515680334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(982, '1', '352711-5', 'MA DAS GRACAS SILVA MAIA', '-PENSAO CIVIL', '0580', '0', '90', 90, 91.80, '090', '53707397300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(983, '1', '356308-1', 'GLAUCIA IBIAPINA BRITO DE OLIV', '-PENSAO CIVIL', '0580', '0', '90', 90, 115.28, '090', '23929901315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(984, '1', '357372-9', 'HEITOR HENRIQUE RODRIGUES COST', '-PENSAO CIVIL', '0580', '0', '90', 90, 136.84, '090', '05411851360', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(985, '1', '364092-2', 'YSLEY PEREIRA DE LIMA', '-PENSAO CIVIL', '0580', '0', '90', 90, 71.45, '090', '02298308381', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(986, '1', '369456-9', 'MARIA ALVARENGA CAVALCANTE PES', '-PENSAO CIVIL', '0580', '0', '90', 90, 103.00, '090', '18125000330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(987, '1', '419398-9', 'MARIA JOSE DA LUZ', '-PENSAO CIVIL', '0580', '0', '90', 90, 276.64, '090', '32767439300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(988, '1', '419430-6', 'MEIRE MAGNA SOUSA BARBOSA', '-PENSAO CIVIL', '0580', '0', '90', 90, 71.00, '090', '74197932391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(989, '1', '427149-1', 'LUCILENE MENDES VIEIRA', '-PENSAO CIVIL', '0580', '0', '90', 90, 632.00, '090', '86387057191', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(990, '1', '430084-0', 'GERALDINA CARVALHO NOBRE', '-PENSAO CIVIL', '0580', '0', '90', 90, 1810.00, '090', '13834118320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(991, '1', '433943-6', 'SANDRA REGINA LEMOS DE SOUSA', '-PENSAO CIVIL', '0580', '0', '90', 90, 303.60, '090', '39775917387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(992, '1', '024348-5', 'MAURICIO BARBOSA DOS SANTOS', '1-POLICIAL PENAL', '0580', '0', '95', 95, 222.00, '095', '22630210359', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(993, '1', '024585-2', 'VANDERLENE GOMES BACELAR DE CA', '1-POLICIAL PENAL', '0580', '0', '95', 95, 113.56, '095', '27471306300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(994, '1', '030551-X', 'FRANCISCO DAS CHAGAS RAMOS DE', '1-POLICIAL PENAL', '0580', '0', '95', 95, 242.00, '095', '01458666883', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(995, '1', '113878-2', 'CESAR CARLOS CARVALHO OLIVEIRA', '1-POLICIAL PENAL', '0580', '0', '95', 95, 137.83, '095', '56662246387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(996, '1', '113891-0', 'TIAGO RODRIGUES NOGUEIRA JUNIO', '1-POLICIAL PENAL', '0580', '0', '95', 95, 156.15, '095', '65785479320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(997, '1', '113895-2', 'ANA LUISA BORGES BATISTA', '1-POLICIAL PENAL', '0580', '0', '95', 95, 440.00, '095', '42870704372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(998, '1', '207215-7', 'MARCOS PAULO VIANA FURTADO', '1-POLICIAL PENAL', '0580', '0', '95', 95, 390.00, '095', '00182716341', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(999, '1', '282829-4', 'GLEIDSON DA SILVA FIGUEIREDO', '1-POLICIAL PENAL', '0580', '0', '95', 95, 130.15, '095', '66766168315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1000, '1', '354285-8', 'JOSE VITOR LEITE BORGES', '9-POLICIAL PENAL', '0580', '0', '95', 95, 115.11, '095', '03403856348', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1001, '1', '006272-3', 'ANA LUCIA DE FREITAS MELO AZEV', '-ASSISTENTE DE PESQUISA', '0580', '0', '97', 97, 193.88, '097', '13287877372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1002, '1', '006354-1', 'ABIMAEL LEITE CAMINHA', '-ASSISTENTE DE PESQUISA', '0580', '0', '97', 97, 84.03, '097', '13007866391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1003, '1', '008963-0', 'ANTONIO LISBOA DE MIRANDA', '-', '0580', '0', '97', 97, 219.00, '097', '09996230368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1004, '1', '008983-4', 'FRANCISCO VITORINO PEREIRA DE', '-', '0580', '0', '97', 97, 179.83, '097', '09947116387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1005, '1', '009427-7', 'LUCIA MARIA DAS GRACAS ALMEIDA', '-AGENTE DE POLICIA', '0580', '0', '97', 97, 152.26, '097', '34291792387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1006, '1', '009656-3', 'CACILDA SANTOS BARBOSA', '-ESCRIVAO DE POLICIA', '0580', '0', '97', 97, 240.00, '097', '35326808315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1007, '1', '010061-7', 'FRANCISCO JOSE DO CARMO NETO', '-CORONEL', '0580', '0', '97', 97, 1362.36, '097', '90726910830', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1008, '1', '010224-5', 'JOAO ALVES DE ARAUJO', '-1o. SARGENTO', '0580', '0', '97', 97, 139.38, '097', '13852957320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1009, '1', '010376-4', 'JOSE DOS SANTOS SOBRINHO', '-', '0580', '0', '97', 97, 86.00, '097', '10622675320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1010, '1', '010556-2', 'FRANCISCO JOSE DA SILVA', '-', '0580', '0', '97', 97, 112.80, '097', '15139280310', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1011, '1', '010760-3', 'MARIA AUXILIADORA BRAZIL GAMA', '-', '0580', '0', '97', 97, 90.58, '097', '09649000330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1012, '1', '010765-4', 'MARIA DO PERPETUO DO SOCORRO M', '-', '0580', '0', '97', 97, 97.97, '097', '04193490300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1013, '1', '010836-7', 'PEDRO GRACIANO DE ALMEIDA', '-MAJOR', '0580', '0', '97', 97, 220.00, '097', '06523110320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1014, '1', '011499-5', 'ETIVALDO DE SOUSA BRITO', '-3o. SARGENTO', '0580', '0', '97', 97, 228.99, '097', '13142267387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1015, '1', '011816-8', 'CICERO ALBINO DE SANTANA', '-SOLDADO', '0580', '0', '97', 97, 134.40, '097', '16033132300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1016, '1', '011985-7', 'DELFINO DE ALMADA', '-2o. TENENTE', '0580', '0', '97', 97, 146.51, '097', '18206034315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1017, '1', '012072-3', 'JOSE FRANCISCO CHAVES FIRMINO', '-GERENTE DE FINANCAS E CONTABI', '0580', '0', '97', 97, 100.00, '097', '23759313353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1018, '1', '012075-8', 'ANTONIO LUIS BATISTA DE OLIVEI', '-', '0580', '0', '97', 97, 73.44, '097', '15056880353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1019, '1', '012169-0', 'ANTONIO FERNANDES DA COSTA', '-CAPITAO', '0580', '0', '97', 97, 134.00, '097', '34765956334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1020, '1', '012334-0', 'RAIMUNDO NONATO DO NASCIMENTO', '-GERENTE DE FINANCAS E CONTABI', '0580', '0', '97', 97, 235.90, '097', '20815786387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1021, '1', '012456-7', 'JOSE LEAO SALES LIMA', '-', '0580', '0', '97', 97, 294.00, '097', '05201020372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1022, '1', '012617-9', 'RAIMUNDO NONATO DOS SANTOS', '-3o. SARGENTO', '0580', '0', '97', 97, 84.40, '097', '18426166334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1023, '1', '012638-1', 'JOSE MARIA FEITOSA DE ARAUJO', '-3o. SARGENTO', '0580', '0', '97', 97, 88.04, '097', '41192451368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1024, '1', '012640-3', 'MANOEL BATISTA NETO', '-SOLDADO', '0580', '0', '97', 97, 138.00, '097', '33794618300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1025, '1', '012869-4', 'WILDSON LAGES', '-SUBTENENTE', '0580', '0', '97', 97, 189.00, '097', '64461106772', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1026, '1', '012870-8', 'JOSE DE RIBAMAR DE SOUSA', '-CAPITAO', '0580', '0', '97', 97, 167.85, '097', '43935702353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1027, '1', '013369-8', 'JOSE GONCALVES DE CARVALHO', '-', '0580', '0', '97', 97, 78.52, '097', '29876613391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1028, '1', '013762-6', 'JOSE DOMINGOS SILVA COSTA', '-3o. SARGENTO', '0580', '0', '97', 97, 76.60, '097', '21819009300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1029, '1', '014142-9', 'JOAO DA CRUZ SILVA DOS SANTOS', '-1o. SARGENTO', '0580', '0', '97', 97, 95.93, '097', '30638186315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1030, '1', '014624-2', 'CARLOS CESAR DE CARVALHO', '-3o. SARGENTO', '0580', '0', '97', 97, 130.42, '097', '34070982353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1031, '1', '021317-9', 'MARIA EUDA MACHADO MELO', '-AGENTE TECNICO DE SERVICO', '0580', '0', '97', 97, 97.93, '097', '34962000306', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1032, '1', '032061-7', 'LOURIVAL DE SENA ROSA', '-SOLDADO', '0580', '0', '97', 97, 161.00, '097', '15284603320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1033, '1', '032097-8', 'JORGE DE FATIMA FERREIRA MOTA', '-3o. SARGENTO', '0580', '0', '97', 97, 111.50, '097', '13164457391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1034, '1', '044139-2', 'NEUSA MARIA DE SOUSA', '-POLICIAL PENAL', '0580', '0', '97', 97, 114.80, '097', '45363447304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1035, '1', '078884-8', 'RAIMUNDO NONATO CAVALCANTE VIA', '-SOLDADO', '0580', '0', '97', 97, 81.63, '097', '34941576349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1036, '1', '082875-X', 'WILSON FERREIRA MAXIMO', '-3o. SARGENTO', '0580', '0', '97', 97, 104.54, '097', '57843880372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1037, '1', '085427-1', 'VALDEMI RIBEIRO SOARES', '-GERENTE DE FINANCAS E CONTABI', '0580', '0', '97', 97, 79.52, '097', '57853703368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1038, '1', '124137-X', 'JOFRAN SANTOS MOURA', '-POLICIAL PENAL', '0580', '0', '97', 97, 182.05, '097', '84693525391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1039, '1', '178803-5', 'JEANEY DOS SANTOS SEBA CORTEZ', '-AGENTE OCUPACIONAL DE NIVEL S', '0580', '0', '97', 97, 108.00, '097', '39567001391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1040, '1', '363864-2', 'IRISMAR DO NASCIMENTO LACERDA', '-AUXILIAR DE CONTROLE EXTERNO', '0580', '0', '97', 97, 103.06, '097', '37376322353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1041, '1', '369873-4', 'JANDIRA OLIVEIRA DE ALMEIDA PE', '-', '0580', '0', '97', 97, 104.48, '097', '18283888315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1042, '1', '369874-2', 'JOSE FERNANDES DA SILVA FILHO', '-', '0580', '0', '97', 97, 251.00, '097', '15187276387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1043, '1', '006033-0', 'JOSE CARVALHO DA SILVA NETO', '3-ANALISTA DE PESQUISA', '0580', '1', '30', 30, 175.00, '130', '14541009315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1044, '1', '014638-2', 'FRANCISCO CARLOS CARVALHO PERE', '1SG-SUBTENENTE', '0580', '3', '21', 21, 77.30, '321', '35283440320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1045, '1', '085392-5', 'RICARDO JOSE DOS SANTOS FILHO', 'STE-1o. TENENTE', '0580', '3', '21', 21, 122.75, '321', '74428063334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1046, '1', '416873-9', 'RICARDO ALEXANDER VIANA SILVA', '-SOLDADO', '0580', '3', '21', 21, 72.33, '321', '05492908340', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1047, '1', '027451-8', 'FELIZARDO FERREIRA CALACO FILH', '2-AGENTE TECNICO DE SERVICO', '0580', '3', '22', 22, 99.54, '322', '33727260300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1048, '1', '033150-3', 'ANTONIO MARTINS DE SOUSA', '-AGENTE OPERACIONAL DE SERVICO', '0580', '9', '11', 11, 501.00, '911', '18605451300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1049, '1', '047697-8', 'MARIA DO ROSARIO COSTA DE SOUZ', '-', '0580', '9', '11', 11, 130.31, '911', '22672222304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1050, '1', '048631-X', 'MARIA DE FATIMA PEREIRA BESSA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 83.00, '911', '11235063372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1051, '1', '049401-1', 'ANTONIA ALVES BEZERRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 120.05, '911', '15191206304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1052, '1', '049915-3', 'PAULO HENRIQUE DE VASCONCELOS', '-PROFESSOR-40HS', '0580', '9', '11', 11, 122.39, '911', '13204785300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1053, '1', '050484-0', 'BELISARIA DE JESUS PIAUILINO Q', '-PROFESSOR-40HS', '0580', '9', '11', 11, 127.81, '911', '89860900310', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1054, '1', '050806-3', 'FRANCISCA MARLUCE DA ROCHA E S', '-', '0580', '9', '11', 11, 120.51, '911', '18447244334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1055, '1', '051303-2', 'EDILZA MARIA DE CARVALHO BRAUL', '-PROFESSOR-40HS', '0580', '9', '11', 11, 126.00, '911', '18226345391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1056, '1', '051453-5', 'MARGARIDA MARIA MENEZES DOS SA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 119.00, '911', '16027442387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1057, '1', '051454-3', 'MARIA DA PAIXAO LUZ LEAL', '-', '0580', '9', '11', 11, 120.35, '911', '16121236353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1058, '1', '052290-2', 'MARIA ETELNISE DE OLIVEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 78.06, '911', '47312645100', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1059, '1', '052310-X', 'MARIA ENI DE SOUSA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 130.00, '911', '21690537353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1060, '1', '053857-4', 'MARIA DO SOCORRO SOUZA LEAL', '-PROFESSOR-40HS', '0580', '9', '11', 11, 115.00, '911', '09927298315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1061, '1', '054463-9', 'FRANCISCA LUSTOSA BORGES DANTA', '-', '0580', '9', '11', 11, 158.97, '911', '30678684391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1062, '1', '055765-0', 'MARIA DE FATIMA SOARES FERREIR', '-PROFESSOR-40HS', '0580', '9', '11', 11, 135.90, '911', '84206918368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1063, '1', '056104-5', 'MARIA APARECIDA RIBEIRO NUNES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 124.75, '911', '18167780368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1064, '1', '056598-9', 'MARIA APARECIDA SILVA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 166.45, '911', '37340697349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1065, '1', '056760-4', 'BERNADETE MACHADO TEIXEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 134.30, '911', '24059706353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1066, '1', '056882-1', 'MARIA DO SOCORRO ALVES COSTA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 129.79, '911', '23106638320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1067, '1', '057675-1', 'PLACIDO LUIZ DE OLIVEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 155.01, '911', '18110860397', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1068, '1', '057726-0', 'FRANCISCA TEIXEIRA BARBOSA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 196.67, '911', '13081578353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1069, '1', '057855-0', 'ROBERVAL RAMOS DE OLIVEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 949.00, '911', '10389334391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1070, '1', '058843-1', 'LIDIA MARIA OLIVEIRA', '-', '0580', '9', '11', 11, 357.35, '911', '09593772391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1071, '1', '059538-1', 'MARIA DO CARMO QUARESMA DE MEL', '-PROFESSOR-40HS', '0580', '9', '11', 11, 83.22, '911', '09617213320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1072, '1', '059721-0', 'MARIA DAS MERCES RIBEIRO LIMA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 133.00, '911', '13208470304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1073, '1', '059948-4', 'JOSE PEREIRA SOBRINHO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 228.00, '911', '09656979320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1074, '1', '060299-0', 'MARIA DO CARMO SILVA DO NASCIM', '-PROFESSOR-40HS', '0580', '9', '11', 11, 121.25, '911', '15641899372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1075, '1', '060612-0', 'MARIA ROSALIA SOARES PEDROSA A', '-PROFESSOR-40HS', '0580', '9', '11', 11, 84.46, '911', '18319874300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1076, '1', '060677-4', 'ALICE LOPES DE ANDRADE E SILVA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 169.51, '911', '18118895300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1077, '1', '060918-8', 'TIAGO ROBERTO DOS SANTOS', '-PROFESSOR-40HS', '0580', '9', '11', 11, 100.00, '911', '13033468349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1078, '1', '062564-7', 'DOMINGOS DIAS ANSELMO BRITO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 102.00, '911', '13327356300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1079, '1', '063800-5', 'ROSALIA MARIA SANTOS SOUSA SIL', '-PROFESSOR-40HS', '0580', '9', '11', 11, 85.08, '911', '37248928372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1080, '1', '064086-7', 'ROSILENE COSTA MASCARENHAS', '-PROFESSOR-40HS', '0580', '9', '11', 11, 153.99, '911', '07788487368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1081, '1', '065423-0', 'DEUSUITE ALVES DE CARVALHO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 128.00, '911', '07807554304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1082, '1', '065636-4', 'MARIA ALDENIS DAS GRACAS ARAUJ', '-PROFESSOR-40HS', '0580', '9', '11', 11, 140.20, '911', '07796226349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1083, '1', '066182-1', 'MARIA LUCIA FERNANDES LIARTH', '-PROFESSOR-40HS', '0580', '9', '11', 11, 117.13, '911', '09742859353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1084, '1', '066679-3', 'MARIA FRANCISCA DE SOUSA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 80.00, '911', '04837231349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1085, '1', '067483-4', 'LUIS CASTRO REGO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 147.05, '911', '21932905391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1086, '1', '068149-X', 'SANDRA MARIA DA SILVA', '-PROFESSOR-20HS', '0580', '9', '11', 11, 93.61, '911', '39596940325', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1087, '1', '068388-4', 'MARIA DO PERPETUO SOCORRO ALVE', '-PROFESSOR-40HS', '0580', '9', '11', 11, 181.00, '911', '13249096334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1088, '1', '068672-7', 'CLAUDETE MARIA SOARES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 309.00, '911', '29636701334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1089, '1', '069207-7', 'LUCIA MARIA LIMA MARQUES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 90.00, '911', '15041280363', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1090, '1', '069480-X', 'CELINA MARIA CALDAS DE SOUZA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 113.82, '911', '23993960300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1091, '1', '069766-4', 'FRANCISCO CARLOS LOPES DA ROCH', '-PROFESSOR-40HS', '0580', '9', '14', 14, 257.10, '911', '18172490372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1092, '1', '071577-8', 'ELMA MARIA ALMEIDA PIRES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 240.00, '911', '67803270344', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1093, '1', '072003-8', 'MARIA RAIMUNDA PEREIRA DA SILV', '-PROFESSOR-20HS', '0580', '9', '11', 11, 75.57, '911', '22765611300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1094, '1', '072505-6', 'LAIDES BASTOS', '-TECNICO EM GESTAO EDUCACIONAL', '0580', '9', '11', 11, 289.00, '911', '13065882353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1095, '1', '072969-8', 'CECILANDIA MENDES LIMA DE CARV', '-', '0580', '9', '11', 11, 257.00, '911', '07766408368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1096, '1', '073657-X', 'EDUVIRGENS GOMES DO NASCIMENTO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 109.45, '911', '22636390391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1097, '1', '074203-1', 'MARIA ASSUNCAO INACIO DE OLIVE', '-PROFESSOR-40HS', '0580', '9', '11', 11, 197.17, '911', '27494020349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1098, '1', '074338-X', 'ADELVANI OLIVEIRA NUNES VIANA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 195.00, '911', '15651541349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1099, '1', '075049-2', 'MARIA RITA DE SOUSA RIBEIRO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 173.95, '911', '22626140325', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1100, '1', '076058-7', 'MARLETE RIBEIRO DE ARAUJO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 377.25, '911', '30476887372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1101, '1', '076633-0', 'MARIA ARLENE SOARES CRUZ', '-PROFESSOR-40HS', '0580', '9', '11', 11, 152.40, '911', '37324179304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1102, '1', '077348-4', 'FLORENTINO INACIO DE OLIVEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 71.70, '911', '22693297320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1103, '1', '077866-4', 'MARIA DA CONCEICAO NARCISA SOU', '-PROFESSOR-40HS', '0580', '9', '11', 11, 120.00, '911', '13289926320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1104, '1', '078292-X', 'DORACION AGUIAR CRUZ', '-PROFESSOR-40HS', '0580', '9', '11', 11, 82.10, '911', '21726612368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1105, '1', '079608-5', 'MARIA JURACEMA SILVA FERREIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 169.46, '911', '30304962368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1106, '1', '081368-X', 'TOMAZ DOS SANTOS LOPES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 71.35, '911', '14549166304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1107, '1', '082819-0', 'REGINA COELI SOUSA CASTRO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 130.00, '911', '57896100304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1108, '1', '083997-3', 'SUELY BARROS SALES', '-PROFESSOR-40HS', '0580', '9', '11', 11, 159.87, '911', '35022485320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1109, '1', '084580-9', 'EDINALVA SOBREIRA DA SILVA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 174.69, '911', '36219177304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1110, '1', '085144-2', 'MARIA JOSINA LOPES DA SILVA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 107.21, '911', '37281577320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1111, '1', '086309-2', 'MARIA AURI DOS SANTOS RIBEIRO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 80.44, '911', '55440517391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1112, '1', '086322-0', 'FRANCISCA MARIA DA SILVA FARIA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 218.56, '911', '56658222304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1113, '1', '101017-4', 'SANDRA MARIA FERREIRA MACHADO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 134.34, '911', '39546721387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1114, '1', '110524-8', 'RAIMUNDA NONATA LIMA DOS SANTO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 161.42, '911', '45359474300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1115, '1', '115607-1', 'LUCIA HELENA DOS SANTOS', '-PROFESSOR-40HS', '0580', '9', '11', 11, 85.30, '911', '80374638349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1116, '1', '059614-X', 'FELINTO ELISIO RIBEIRO FILHO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 163.00, '914', '22478060310', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1117, '1', '059782-1', 'MARIA DO LIVRAMENTO DE ALMEIDA', '-PROFESSOR 40H', '0580', '9', '14', 14, 108.83, '914', '34950516353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1118, '1', '062279-6', 'MARIA GIZONHA LIMA DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 80.00, '914', '23374608353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1119, '1', '071438-X', 'DALVA LUCIA DA SILVA LOPES', '2-AGENTE TECNICO DE SERVICO', '0580', '9', '14', 14, 175.37, '914', '34974660349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1120, '1', '073399-7', 'NEIDE MOURA CARDOSO DE CARVALH', '5-PROFESSOR-20H', '0580', '9', '14', 14, 82.24, '914', '38633078368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1121, '1', '073719-4', 'MARIA DO ROSARIO DE MIRANDA BE', '2-AGENTE TECNICO DE SERVICO', '0580', '9', '14', 14, 200.00, '914', '47439378334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1122, '1', '073807-7', 'MARIA DO ROSARIO GOMES ALMEIDA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 130.18, '914', '20063962349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1123, '1', '077131-7', 'JOAO GIL BARBOSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 123.65, '914', '15192326320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1124, '1', '081099-1', 'JOSE AFONSO DE ARAUJO SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 93.18, '914', '27492419368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1125, '1', '081146-7', 'UYLDA MAYHAME FERNANDES DE SOU', '1-PROFESSOR 40H', '0580', '9', '14', 14, 125.59, '914', '53596617391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL);
INSERT INTO `folha_lancamento_simples` (`id`, `status`, `matricula`, `nome`, `cargo`, `fin`, `orgao`, `lanc`, `total_pago`, `valor`, `orgao_pagto`, `cpf`, `created_at`, `contato_retorno`, `contato_operador`, `contato_status`, `contato_atualizado_em`) VALUES
(1126, '1', '083901-9', 'FRANCISCO DE ASSIS DA COSTA OT', '1-PROFESSOR 40H', '0580', '9', '14', 14, 129.00, '914', '22772456315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1127, '1', '084607-4', 'ANA CELIA DE JESUS VERAS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 141.00, '914', '22160043320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1128, '1', '086312-2', 'LUZIMAR DEODATO PARAGUAI', '1-PROFESSOR 40H', '0580', '9', '14', 14, 106.02, '914', '49475029168', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1129, '1', '093911-X', 'EVREE JANNE MENDES GONCALVES D', '1-PROFESSOR 40H', '0580', '9', '14', 14, 174.02, '914', '76916189304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1130, '1', '095762-3', 'ANTONIA DE SOUSA ANDRADE', '5-PROFESSOR-20H', '0580', '9', '14', 14, 80.61, '914', '30692784349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1131, '1', '096623-1', 'MARIA VERONICA DIAS MELO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 118.00, '914', '42864224372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1132, '1', '097171-5', 'MARLY CIPRIANO FEITOSA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 171.61, '914', '43962513353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1133, '1', '098128-1', 'RONALDO COSTA SALES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 92.80, '914', '51513692372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1134, '1', '098214-8', 'DIANA DE SOUSA COSTA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 93.84, '914', '62772511391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1135, '1', '100842-X', 'ANTONIO LUIS DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 118.00, '914', '71981306315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1136, '1', '101160-0', 'ALINE BARROS GIRAO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 151.00, '914', '85453498315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1137, '1', '101162-6', 'MARIA DE JESUS DOS SANTOS ARAU', '1-PROFESSOR 40H', '0580', '9', '14', 14, 1510.20, '914', '47019522300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1138, '1', '103266-6', 'FLORISA SOARES TAVARES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 201.00, '914', '82737843391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1139, '1', '103505-3', 'SELMA MARIA ALVES DE JESUS', '5-PROFESSOR-20H', '0580', '9', '14', 14, 97.33, '914', '49797930378', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1140, '1', '104090-1', 'MARIA ELITA ARAGAO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 247.00, '914', '69423385320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1141, '1', '105188-1', 'MONICA CARDOSO SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 162.30, '914', '81146086334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1142, '1', '105891-6', 'RAIMUNDA HILSA ALMEIDA PORTEL', '1-PROFESSOR 40H', '0580', '9', '14', 14, 75.95, '914', '92122094320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1143, '1', '106312-0', 'TANIA MARCIA PEREIRA DE CARVAL', '1-PROFESSOR 40H', '0580', '9', '14', 14, 162.00, '914', '62262831300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1144, '1', '106357-0', 'TISCIANE CASTRO LUZ VIEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 156.11, '914', '89471695368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1145, '1', '106507-6', 'MILLENA OLIVEIRA BEZERRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 116.25, '914', '88318435320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1146, '1', '106675-7', 'FRANCISCA DE ASSIS DOS SANTOS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 141.10, '914', '90023161353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1147, '1', '106713-3', 'SUELE NOGUEIRA DE SOUSA RIBEIR', '1-PROFESSOR 40H', '0580', '9', '14', 14, 104.00, '914', '79070213320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1148, '1', '106866-X', 'JOAO LUIS DOS SANTOS OLIVEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 140.54, '914', '04106174820', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1149, '1', '107441-5', 'CLEIDINALVA ANTONIA DA CONCEIC', '5-PROFESSOR-20H', '0580', '9', '14', 14, 99.00, '914', '93870620315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1150, '1', '107901-8', 'LIA MARCIA AMORIM BARROS', '5-PROFESSOR-20H', '0580', '9', '14', 14, 122.16, '914', '37500724349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1151, '1', '107906-9', 'EDMAR DA SILVA BASTOS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 213.00, '914', '72165430763', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1152, '1', '109308-8', 'ANA PAULA SOUSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 139.17, '914', '71712089315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1153, '1', '109591-9', 'DEUSELINA CARVALHO SANTOS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 150.00, '914', '95771387304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1154, '1', '109596-0', 'CLAUDIA DE CARVALHO SOUSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 132.26, '914', '85745375353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1155, '1', '109639-7', 'RAIMUNDO RIBEIRO DE CARVALHO F', '1-PROFESSOR 40H', '0580', '9', '14', 14, 148.28, '914', '53490983300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1156, '1', '109645-1', 'REGINALDO BRANDAO DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 1063.03, '914', '25528129885', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1157, '1', '109979-5', 'LAERCIO DO NASCIMENTO ALMEIDA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 189.00, '914', '75770563320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1158, '1', '110523-0', 'IRANILDA ROCHA DE OLIVEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 140.00, '914', '76256766334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1159, '1', '110616-3', 'MARIA DA CRUZ DE SOUSA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 93.38, '914', '76052281391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1160, '1', '111038-1', 'SANDRA RODRIGUES DE SOUSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 120.00, '914', '74373250391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1161, '1', '112858-2', 'LUZANIR CARVALHO DE OLIVEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 132.65, '914', '78037190315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1162, '1', '114483-9', 'JANICE DE FATIMA NASCIMENTO', '5-PROFESSOR-20H', '0580', '9', '14', 14, 99.00, '914', '48981605300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1163, '1', '114575-4', 'MARIA IRAIDE DA SILVA MELO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 73.00, '914', '81483708349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1164, '1', '124404-3', 'LUIZ JOSE DO NASCIMENTO FILHO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 156.00, '914', '71083456334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1165, '1', '131578-1', 'DIANA GOMES SOUSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 89.85, '914', '90767845315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1166, '1', '142103-4', 'NILVAN BARBOSA MIRANDA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 147.06, '914', '49867334353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1167, '1', '143422-5', 'IVANISIO BOTELHO IGREJA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 106.09, '914', '78241391315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1168, '1', '171134-2', 'RODRIGO CELIO FERREIRA MOURA S', '1-PROFESSOR 40H', '0580', '9', '14', 14, 317.91, '914', '88018806349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1169, '1', '171525-9', 'NILSON RODRIGUES DOS SANTOS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 179.90, '914', '85866326353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1170, '1', '171538-X', 'JOSE DE SOUSA NETO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 103.47, '914', '91299136320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1171, '1', '171557-7', 'TANIA DE JESUS BENVINDO DA FON', '1-PROFESSOR 40H', '0580', '9', '14', 14, 113.68, '914', '84878142391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1172, '1', '171632-8', 'EDINALDA MARIA DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 104.50, '914', '77867831304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1173, '1', '179039-X', 'ANTONIO CARLOS ARAUJO OLIVEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 155.26, '914', '49837230304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1174, '1', '179060-9', 'LENA MARIA RODRIGUES CORDEIRO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 107.76, '914', '09144692315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1175, '1', '179068-4', 'EDNA TEIXEIRA FERNANDES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 79.90, '914', '87627299349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1176, '1', '179178-8', 'MARCIA BEATRIZ BARROS CAMINHA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 158.96, '914', '89543505349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1177, '1', '179408-6', 'DOMINGOS SALES DO NASCIMENTO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 149.07, '914', '91081777320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1178, '1', '199494-8', 'JOSE AIRTON DO NASCIMENTO COST', '1-PROFESSOR 40H', '0580', '9', '14', 14, 114.56, '914', '63823829300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1179, '1', '199516-2', 'VANIO DIAS RODRIGUES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 121.88, '914', '47927615300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1180, '1', '199539-1', 'JOSE MILTON NEVES BORGES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 82.27, '914', '23947381387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1181, '1', '199547-2', 'ANDERSON NEY BELIZARIO MOTA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 115.21, '914', '70757720315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1182, '1', '199976-1', 'ANA MARCIA LEAL VIEIRA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 81.00, '914', '97600490315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1183, '1', '200017-2', 'LIVIA RODRIGUES CHAVES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 85.30, '914', '00380795345', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1184, '1', '205651-8', 'SILVIO DOS SANTOS CARVALHO', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 74.64, '914', '13626846865', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1185, '1', '205733-6', 'ABINAEUDES REIS SANTOS', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 502.60, '914', '02530755302', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1186, '1', '219122-9', 'ANTONIO FRANCISCO SILVA DE MEL', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 73.40, '914', '65120051391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1187, '1', '221747-3', 'PAULO SERGIO COSTA DOS SANTOS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 360.40, '914', '35285710391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1188, '1', '222740-1', 'LAYSE RAFAELA CUNHA DE SOUSA', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 89.88, '914', '02462166386', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1189, '1', '222755-0', 'DESDEMONA TELES DE OLIVEIRA E', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 176.71, '914', '03687249301', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1190, '1', '223000-3', 'THIAGO DOUGLAS PEREIRA SILVA', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 101.00, '914', '01259239373', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1191, '1', '226781-X', 'FRANCISCO ANDAILSON DA SILVA R', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 102.00, '914', '00751682357', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1192, '1', '230362-X', 'SUELY RAMOS CARVALHO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 92.93, '914', '70751412368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1193, '1', '231011-2', 'ELYNEIDE TAVARES DE ARAUJO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 78.50, '914', '98761633372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1194, '1', '231032-5', 'JOAO BATISTA RODRIGUES DE OLIV', '1-PROFESSOR 40H', '0580', '9', '14', 14, 128.28, '914', '36220299353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1195, '1', '231223-9', 'NIVALBER SOUSA ROCHA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 99.77, '914', '94018790368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1196, '1', '232840-2', 'JOSSIE LEITAO RODRIGUES DA SIL', '1-PROFESSOR 40H', '0580', '9', '14', 14, 100.32, '914', '72142537391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1197, '1', '232873-9', 'LUIZ RAIMUNDO DE ABREU NETO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 100.02, '914', '00350390355', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1198, '1', '233043-1', 'VANDEMARE DA CONCEICAO SOUSA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 178.61, '914', '92278272349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1199, '1', '233749-5', 'JOSE ERISVALDO RODRIGUES DA CO', '2-SUPERVISOR PEDAGOGICO-40H', '0580', '9', '14', 14, 128.51, '914', '82385114372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1200, '1', '233763-X', 'RUBENASER COSTA BORGES', '1-PROFESSOR 40H', '0580', '9', '14', 14, 121.92, '914', '01139944355', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1201, '1', '260624-X', 'DAYARA JOVANA CAVALCANTE BARRO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 200.00, '914', '99420686353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1202, '1', '263943-2', 'TATIANA PACHECO ARAUJO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 99.16, '914', '65849990330', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1203, '1', '292970-8', 'CARLOS JOSE PEREIRA DA SILVA A', '1-PROFESSOR 40H', '0580', '9', '14', 14, 625.65, '914', '38737973304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1204, '1', '293007-2', 'SERGIO KENNEDY VIEIRA DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 73.69, '914', '68617798220', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1205, '1', '293112-5', 'ALCEBIADES DE ARAUJO SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 84.00, '914', '80283470372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1206, '1', '293166-4', 'KEILE MIRANDA SOARES', '5-PROFESSOR-20H', '0580', '9', '14', 14, 101.10, '914', '69980454172', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1207, '1', '317014-4', 'MARIA DE LOURDES SILVA BORGES', '5-PROFESSOR-20H', '0580', '9', '14', 14, 420.00, '914', '48989754372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1208, '1', '320919-9', 'LUIZ VALMOR DE SOUSA BARROS', '1-PROFESSOR 40H', '0580', '9', '14', 14, 116.99, '914', '01930594364', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1209, '1', '321028-6', 'VIRNA PEREIRA TEIXEIRA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 280.37, '914', '79997163320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1210, '1', '327656-2', 'WILSON RIBEIRO PAES', '5-PROFESSOR-20H', '0580', '9', '14', 14, 79.33, '914', '23906650120', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1211, '1', '330737-9', 'ANDERSON NUNES COSTA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 80.54, '914', '02873197331', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1212, '1', '330763-8', 'AIRAM ANICLE LOPES DE OLIVEIRA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 71.00, '914', '02359516337', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1213, '1', '331809-5', 'LUCIANO JORGE MOURA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 881.61, '914', '74590464349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1214, '2', '044544-4', 'ADERSON EVELYN SOARES FILHO', '3-AGENTE DE TRIBUTOS DA FAZEND', '0580', '0', '09', 9, 363.00, '009', '09702458315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1215, '2', '083991-4', 'VILMAR BARBOSA DE SOUSA', '-PROFESSOR 40H', '0580', '9', '14', 14, 150.00, '011', '30659043300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1216, '2', '103338-7', 'KARLA PATRICIA SANTOS GOMES', '5-PROFESSOR-20H', '0580', '0', '11', 11, 177.00, '011', '83793186334', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1217, '2', '004943-3', 'FRANCISCA ELISEU ARAUJO DOS SA', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '0', '12', 12, 81.69, '012', '28784332387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1218, '2', '006768-7', 'EDMAR SANTANA DE AQUINO', '2-AGENTE TECNICO DE SERVIO ARE', '0580', '0', '21', 21, 163.44, '021', '34990291387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1219, '2', '245238-3', 'JUCIAN SOUSA SANTOS', '13-CABO', '0580', '0', '28', 28, 173.00, '028', '00626410347', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1220, '2', '022894-0', 'NORMA LUCIA SILVA RIBEIRO LAGO', '2-AGENTE TECNICO DE SERVICO', '0580', '0', '40', 40, 163.60, '040', '36140422353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1221, '2', '331070-1', 'HERAN RODRIGUES BASTOS DE SOUS', '-PENSAO CIVIL', '0580', '0', '90', 90, 154.00, '090', '14519216320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1222, '2', '004274-9', 'JOAO VICENTE AYRES', '-AGENTE OPERACIONAL DE SERVICO', '0580', '0', '97', 97, 172.00, '097', '09943919353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1223, '2', '010728-0', 'MARIA DA CONCEICAO DAS GRACAS', '-SUBTENENTE', '0580', '0', '97', 97, 134.52, '097', '06634494304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1224, '2', '010746-8', 'GERALDO QUEIROZ DE SOUSA', '-3o. SARGENTO', '0580', '0', '97', 97, 129.08, '097', '04718828368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1225, '2', '013014-1', 'FRANCISCO XAVIER SALES', '-GERENTE DE FINANCAS E CONTABI', '0580', '0', '97', 97, 73.00, '097', '15243745391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1226, '2', '013547-0', 'RICARDO GOMES DOURADO FILHO', '-3o. SARGENTO', '0580', '0', '97', 97, 113.20, '097', '30673305368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1227, '2', '014879-2', 'ADILSON CESAR DA CRUZ SILVA', '-3o. SARGENTO', '0580', '0', '97', 97, 71.24, '097', '35403179372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1228, '2', '015703-1', 'ANISIO RODRIGUES DA SILVA', '-3o. SARGENTO', '0580', '0', '97', 97, 121.50, '097', '42882729391', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1229, '2', '020876-X', 'MARIA DAS GRACAS DO REGO PEREI', '-AGENTE TECNICO DE SERVICO', '0580', '0', '97', 97, 88.00, '097', '10528024353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1230, '2', '039669-9', 'DESTERRO PONTES BARROS BEZERRA', '-AGENTE OCUPACIONAL DE NIVEL S', '0580', '0', '97', 97, 177.48, '097', '31687369372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1231, '2', '025524-6', 'MARIA DE FATIMA SOUSA', '6-ASSIST.ADMINISTRATIVO', '0580', '1', '22', 22, 238.00, '120', '06637663387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1232, '2', '049345-7', 'VACENIR DE ALMEIDA CARDOSO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 442.58, '911', '15060284387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1233, '2', '053235-5', 'ANA ANTONIA SOARES VIANA SANTO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 134.41, '911', '37436082353', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1234, '2', '055931-8', 'VANIA RODRIGUES DE FIGUEIREDO', '-', '0580', '9', '11', 11, 183.00, '911', '31503799387', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1235, '2', '055956-3', 'SANIA DIAS DE CARVALHO', '-PROFESSOR-40HS', '0580', '9', '11', 11, 125.00, '911', '50426567315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1236, '2', '066777-3', 'ZELIA MARIA JORGE DE OLIVEIRA', '-PROFESSOR-40HS', '0580', '9', '11', 11, 97.00, '911', '06590896372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1237, '2', '071702-9', 'ALZAIDE SANTOS RIBEIRO', '-AGENTE TECNICO DE SERVICO', '0580', '9', '11', 11, 107.75, '911', '34951806304', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1238, '2', '072593-5', 'MARIA VITORIA SENA DA SILVA LE', '-PROFESSOR-40HS', '0580', '9', '11', 11, 88.00, '911', '15984869349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1239, '2', '077029-9', 'ELENICE PINHEIRO BARROS', '-PROFESSOR-40HS', '0580', '9', '11', 11, 287.20, '911', '33055904320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1240, '2', '027584-X', 'MARIA DO SOCORRO ALVES PEREIRA', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 77.00, '914', '37316869372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1241, '2', '070901-8', 'MARIA DE FATIMA DA SILVA DE JE', '2-AGENTE TECNICO DE SERVICO', '0580', '9', '14', 14, 128.20, '914', '18336787372', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1242, '2', '078166-5', 'MARIA JOSE PEREIRA DA SILVA', '1-PROFESSOR 40H', '0580', '9', '14', 14, 219.30, '914', '37374060300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1243, '2', '078343-9', 'VALDELICE DA SILVA FREITAS', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 74.42, '914', '36138746368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1244, '2', '107528-4', 'NORBERTO DA SILVA NORONHA NETO', '1-PROFESSOR 40H', '0580', '9', '14', 14, 78.85, '914', '33823243349', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1245, '2', '109172-7', 'VALDONIO LOPES ROCHA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 103.67, '914', '88024784300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1246, '2', '112663-6', 'GERSON PEREIRA DO NASCIMENTO', '5-PROFESSOR-20H', '0580', '9', '14', 14, 154.64, '914', '35072520315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1247, '2', '112862-X', 'JANETE PIMENTEL DE SOUSA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 154.39, '914', '21720282315', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1248, '2', '114775-7', 'ANA ILDA DE MELO LIMA SILVA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 84.85, '914', '24120910300', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1249, '2', '143244-3', 'GILMAR NUNES DA SILVA', '5-PROFESSOR-20H', '0580', '9', '14', 14, 157.21, '914', '36163163320', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1250, '2', '222339-2', 'ANTONIA CRISTINA MOURAO E SILV', '1-AGENTE OPERACIONAL DE SERVIC', '0580', '9', '14', 14, 97.00, '914', '75708515368', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL),
(1251, '2', '343678-X', 'RAPHAEL GERARDO MORAIS DE OLIV', '5-PROFESSOR-20H', '0580', '9', '14', 14, 167.82, '914', '00098831348', '2025-08-29 23:46:45', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_orgao_resumo`
--

CREATE TABLE `folha_orgao_resumo` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `arquivo_id` bigint(20) UNSIGNED NOT NULL,
  `status_code` char(1) NOT NULL,
  `orgao_pagto_codigo` char(3) NOT NULL,
  `orgao_pagto_nome` varchar(190) NOT NULL,
  `lancamentos_qtd` int(10) UNSIGNED NOT NULL,
  `total_valor` decimal(14,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_status`
--

CREATE TABLE `folha_status` (
  `code` char(1) NOT NULL,
  `descricao` varchar(160) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `folha_status`
--

INSERT INTO `folha_status` (`code`, `descricao`) VALUES
('1', 'Lançado e Efetivado'),
('2', 'Não Lançado por Falta de Margem Temporariamente'),
('3', 'Não Lançado por Outros Motivos(Ex.Matricula não encontrada; Mudança de órgão)'),
('4', 'Lançado com Valor Diferente'),
('5', 'Não Lançado por Problemas Técnicos'),
('6', 'Lançamento com Erros'),
('S', 'Não Lançado: Compra de Dívida ou Suspensão SEAD');

-- --------------------------------------------------------

--
-- Estrutura para tabela `loja`
--

CREATE TABLE `loja` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(120) NOT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `loja`
--

INSERT INTO `loja` (`id`, `nome`, `status`, `created_at`, `updated_at`) VALUES
(1, 'ABASEPI', 'ativo', '2025-08-18 23:51:39', '2025-08-18 23:51:39'),
(5, 'FILIAL TERESINA', 'ativo', '2025-08-18 23:55:04', '2025-08-18 23:55:04'),
(6, 'FILIAL PARNAÍBA', 'ativo', '2025-08-18 23:55:04', '2025-08-18 23:55:04');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa`
--

CREATE TABLE `pessoa` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tipo_documento` enum('CPF','CNPJ') NOT NULL DEFAULT 'CPF',
  `documento` varchar(20) NOT NULL,
  `data_nascimento` date DEFAULT NULL,
  `nome_razao_social` varchar(180) NOT NULL,
  `estado_civil` enum('Solteiro(a)','Casado(a)','Divorciado(a)','Viúvo(a)','União Estável','Separado(a)','Outro') DEFAULT NULL,
  `rg` varchar(20) DEFAULT NULL,
  `profissao` varchar(100) DEFAULT NULL,
  `cep` varchar(9) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  `endereco` varchar(180) DEFAULT NULL,
  `bairro` varchar(120) DEFAULT NULL,
  `cidade` varchar(120) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `matricula` varchar(60) DEFAULT NULL,
  `beneficio` varchar(120) DEFAULT NULL,
  `salario_liquido` decimal(12,2) DEFAULT 0.00,
  `antecipacao` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `criado` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `pessoa`
--

INSERT INTO `pessoa` (`id`, `tipo_documento`, `documento`, `data_nascimento`, `nome_razao_social`, `estado_civil`, `rg`, `profissao`, `cep`, `complemento`, `uf`, `endereco`, `bairro`, `cidade`, `telefone`, `celular`, `matricula`, `beneficio`, `salario_liquido`, `antecipacao`, `created_at`, `updated_at`, `criado`, `email`) VALUES
(1, 'CPF', '000.000.000-00', '1990-05-14', 'João da Silva', 'Solteiro(a)', '12.345.678-9', 'Analista de Sistemas', '64000-000', 'Apto 302', 'PI', 'Av. Principal, 123', 'Centro', 'Teresina', '(86) 3232-0000', '(86) 99999-0000', 'MAT-001', 'Auxílio Saúde', 4500.00, 0.00, '2025-08-18 23:39:09', '2025-08-18 23:39:09', NULL, ''),
(2, 'CPF', '06161599350', '1996-03-24', 'helcio', 'Solteiro(a)', '3502418', 'aut', '88075-310', 'Portao Branco Pequeno Muro Cinza', 'SC', 'Rua Raul Antônio da Silva', 'Balneário', 'Florianópolis', '(48) 9996-1324', '(48) 99961-3249', '131', '12', 11111.11, 111111.11, '2025-08-19 17:22:43', '2025-08-21 19:01:54', NULL, ''),
(3, 'CPF', '06161514646', '0000-00-00', 'Fabiano', 'Solteiro(a)', '5464864', 'AUt', '64077-830', '11', 'PI', 'Rua São José, 600', 'Balneário', 'Florianópolis', '(48) 9996-1324', '(48) 99961-3249', '454646', '4646', 50000.00, 50.00, '2025-08-19 18:00:09', '2025-08-19 18:00:09', NULL, ''),
(4, 'CPF', '06724762316', '1995-04-22', 'hashinshin', 'Solteiro(a)', '3071239', 'dev', '64007-600', '11', 'PI', 'Rua Batalha', 'Aeroporto', 'Teresina', NULL, '(86) 98134-3777', NULL, NULL, 1200.00, 0.00, '2025-08-20 13:09:43', '2025-08-23 12:10:44', 'helciovenanciopi@gmail.com', 'a@gmail.com'),
(6, 'CPF', '00763819357', '1995-04-22', 'fernando gomes silva de oliveira', 'Solteiro(a)', '10710711', 'aposentado', '64077-830', '11', 'PI', 'Rua Poncion Caldas', 'Parque Ideal', 'Teresina', '(86) 9813-4377', '8698134377', '131314', 'aa123', 10000.00, 850.00, '2025-08-20 18:50:37', '2025-08-20 18:50:37', NULL, ''),
(7, 'CPF', '06161533950', '1996-03-24', 'RAIMUNDO GOMES DE OLYVEIRA PINTO', 'Casado(a)', '354168', 'Empresario', '64077-360', 'Apto 1128', 'PI', 'Residencial Vila Verona II', 'Balneário', 'PALHOCA', '(48) 9996-1324', '(48) 99961-3249', '6464', 'qwwq', 1200.00, 200.00, '2025-08-20 20:21:39', '2025-08-20 20:21:39', NULL, ''),
(8, 'CPF', '00686694376', '1986-01-12', 'PELTSON SOUSA RIBEIRO', 'Casado(a)', '2336805', 'EMPRESARIO', '64000-090', '(Zona Norte)', 'PI', 'Rua Rui Barbosa', 'Centro', 'Teresina', NULL, '(86) 99902-3302', NULL, '01222000200', 10000.00, 10000.00, '2025-08-20 20:50:45', '2025-08-23 01:41:48', NULL, 'PELTSON@HOTMAIL.COM'),
(12, 'CPF', '00763819352', '1965-05-26', 'maria jose silva de oliveira', 'Casado(a)', '31166612', 'auditora fiscal', '64077-830', '11', 'PI', 'Rua Poncion Caldas', 'Parque Ideal', 'Teresina', NULL, '(86) 98134-3777', '06724762316', NULL, 12000.00, 0.00, '2025-08-21 21:11:59', '2025-08-22 16:10:41', NULL, 'leideguns@gmail.com'),
(13, 'CPF', '12345678945', '1993-04-30', 'Bart Simpson', 'Solteiro(a)', '123456787', 'programador', '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-21 22:35:30', '2025-08-22 13:08:37', 'lisa@teste.com', 'abasepiaui@gmail.com'),
(14, 'CPF', '32165498754', '1993-04-30', 'Marge Simpson', 'Casado(a)', '32165484', 'programadora', '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-21 23:08:38', '2025-08-21 23:17:52', NULL, 'abasepiaui@gmail.com'),
(15, 'CPF', '45678912345', '0000-00-00', 'Mag Simpson', 'Solteiro(a)', '45612315', 'programadora', '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-21 23:21:55', '2025-08-21 23:21:55', 'lisa@teste.com', 'abasepiaui@gmail.com'),
(19, 'CPF', '12345678978', '1993-04-30', 'Hélcio Venâncio', 'Solteiro(a)', '213456784', NULL, '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-22 13:16:47', '2025-08-22 13:16:47', 'lisa@teste.com', 'abasepiaui@gmail.com'),
(20, 'CPF', '12345689455', '1993-04-30', 'Hélcio Venâncio Teste', 'Casado(a)', '123654987', 'designer', '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-22 13:22:47', '2025-08-22 13:22:47', 'helciohelcio@gmail.com', 'abasepiaui@gmail.com'),
(21, 'CPF', '32165498745', '1993-04-30', 'Hélcio Venâncio Teste2', 'Casado(a)', '326549874', 'Designer', '88075-310', NULL, 'SC', 'rua são josé 600', 'Balneário', 'Florianopolis', NULL, '(48) 99961-3249', NULL, NULL, 0.00, 0.00, '2025-08-22 13:27:02', '2025-08-22 13:27:02', 'helciohelcio@gmail.com', 'abasepiaui@gmail.com'),
(22, 'CPF', '04018631316', '1987-05-27', 'LEIDE PEREIRA DE SOUSA', 'Viúvo(a)', '2040803', 'pensionista', '65000-000', '17', 'MA', 'rua projetada 2', 'traqueira', 'timon', NULL, '(86) 99591-9219', NULL, NULL, 4353.23, 0.00, '2025-08-22 18:17:53', '2025-08-22 18:17:53', 'abase@abase.com', 'leidemaria@gmail.com'),
(25, 'CPF', '64135646886', '1980-09-12', 'ONOMATOPEIA ARLINDO', 'Casado(a)', '3502418', 'sERVIDOR', '88075-310', 'Portao Branco Pequeno Muro Cinza', 'SC', 'Rua São José, 600', 'Balneário', 'Florianópolis', NULL, '(48) 99961-3249', NULL, NULL, 2320.00, 0.00, '2025-08-23 10:04:26', '2025-08-23 10:04:26', NULL, 'helciovenancio10@gmail.com'),
(26, 'CPF', '46464234676', '2025-08-23', 'Olinda Jenesio', 'Solteiro(a)', '2112313', 'ss', '64069-430', 'apto 308', 'PI', 'Residencial Vila Verona II', 'Vale do Gavião', 'Teresina', NULL, '(48) 99961-3249', NULL, NULL, 2500.00, 0.00, '2025-08-23 10:17:16', '2025-08-23 10:17:16', NULL, 'helciovenancio10@gmail.com'),
(28, 'CPF', '11111111111', '2025-08-23', 'Teste Sab', 'Solteiro(a)', '1111111111', 'TEste', '88075-310', 'Portao Branco Pequeno Muro Cinza', 'SC', 'Rua São José, 600', 'Balneário', 'Florianópolis', NULL, '(48) 99961-3249', NULL, NULL, 10000.00, 0.00, '2025-08-23 22:25:39', '2025-08-23 22:25:39', NULL, 'helciovenancio10@gmail.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_bancario`
--

CREATE TABLE `pessoa_bancario` (
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `banco_codigo` varchar(10) DEFAULT NULL,
  `banco_nome` varchar(120) DEFAULT NULL,
  `agencia` varchar(20) DEFAULT NULL,
  `conta` varchar(30) DEFAULT NULL,
  `tipo_conta` enum('corrente','poupanca') DEFAULT NULL,
  `pix_chave` varchar(120) DEFAULT NULL,
  `salario_liquido` decimal(12,2) DEFAULT NULL,
  `antecipacao` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_bancario`
--

INSERT INTO `pessoa_bancario` (`pessoa_id`, `banco_codigo`, `banco_nome`, `agencia`, `conta`, `tipo_conta`, `pix_chave`, `salario_liquido`, `antecipacao`, `created_at`, `updated_at`) VALUES
(2, NULL, 'Hélcio Venâncio Santos de Carvalho', '12', '12', 'corrente', 'helciovenancio10@gmail.com', 11111.11, 111111.11, '2025-08-20 16:50:54', '2025-08-20 18:46:27'),
(3, NULL, '', '', '', NULL, NULL, NULL, NULL, '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(4, NULL, 'inter', '1234', '12345-9', 'corrente', '12456123456', 1200.00, 0.00, '2025-08-20 13:09:43', '2025-08-23 12:10:44'),
(6, NULL, 'inter', '1234', '14145-9', 'corrente', NULL, 10000.00, NULL, '2025-08-20 18:50:37', '2025-08-20 18:51:18'),
(7, NULL, 'Helcio Venancio', '164', '6464', 'corrente', NULL, 1200.00, NULL, '2025-08-20 20:21:39', '2025-08-20 20:33:42'),
(8, NULL, '001', '00442', '52741-6', 'corrente', 'PELTSON@HOTMAIL.COM', 10000.00, 0.00, '2025-08-20 20:50:45', '2025-08-23 01:41:48'),
(12, NULL, 'pag bank', '12345', '131314-9', 'poupanca', '123e4567-e89b-12d3-a456-426655440000', 12000.00, 0.00, '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(13, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, '2025-08-21 22:35:30', '2025-08-22 13:08:37'),
(14, NULL, 'nu bank', NULL, NULL, NULL, NULL, 0.00, 0.00, '2025-08-21 23:08:38', '2025-08-21 23:08:38'),
(15, NULL, 'nu pay', '4000', '131314-9', 'poupanca', '123e4567-e89b-12d3-a456-426655440000', 10000.00, 3000.00, '2025-08-21 23:21:55', '2025-08-22 02:54:12'),
(19, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, '2025-08-22 13:16:47', '2025-08-22 13:16:47'),
(20, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, '2025-08-22 13:22:47', '2025-08-22 13:22:47'),
(21, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, '2025-08-22 13:27:02', '2025-08-22 13:27:02'),
(22, NULL, 'BB', '1428-1', '29134-x', 'corrente', '(86) 99591-9219', 4353.23, 0.00, '2025-08-22 18:17:53', '2025-08-22 18:17:53'),
(25, NULL, 'EFI', '1346', '4641349', 'corrente', '46467316497', 2320.00, 0.00, '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(26, NULL, '1', '1', '1', 'corrente', '113121212', 2500.00, 0.00, '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(28, NULL, 'BB', '4710', '123456', 'corrente', 'helciovenancio@gmail.com', 10000.00, 0.00, '2025-08-23 22:25:39', '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_contrato`
--

CREATE TABLE `pessoa_contrato` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(64) NOT NULL,
  `parcela_valor` decimal(12,2) DEFAULT NULL,
  `prazo` int(11) DEFAULT NULL,
  `taxa_percent` decimal(8,2) DEFAULT NULL,
  `custo` decimal(12,2) DEFAULT NULL,
  `valor_liberado` decimal(12,2) DEFAULT NULL,
  `data_aprov` date DEFAULT NULL,
  `nb_matricula` varchar(80) DEFAULT NULL,
  `produto` enum('GOVERNO DO PIAUI','INSS','SIAPE','OUTRO') DEFAULT NULL,
  `total_financiado` decimal(12,2) DEFAULT NULL,
  `status_contrato` enum('EM ABERTO','APROVADO','PAGO','CANCELADO') DEFAULT 'EM ABERTO',
  `mes_averb` char(7) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_contrato`
--

INSERT INTO `pessoa_contrato` (`id`, `pessoa_id`, `codigo`, `parcela_valor`, `prazo`, `taxa_percent`, `custo`, `valor_liberado`, `data_aprov`, `nb_matricula`, `produto`, `total_financiado`, `status_contrato`, `mes_averb`, `created_at`, `updated_at`) VALUES
(1, 3, '3', 114.00, 3, 30.00, 0.00, 239.40, '2025-08-20', NULL, 'GOVERNO DO PIAUI', 342.00, 'EM ABERTO', '11/2025', '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(2, 6, '6', 250.00, 3, 30.00, 0.00, 525.00, '2025-08-20', NULL, 'GOVERNO DO PIAUI', 750.00, 'EM ABERTO', '11/2025', '2025-08-20 18:51:18', '2025-08-20 18:54:48'),
(5, 7, '7', 250.00, 3, 30.00, 0.00, 525.00, '2025-08-20', NULL, 'GOVERNO DO PIAUI', 750.00, 'EM ABERTO', '11/2025', '2025-08-20 20:33:43', '2025-08-20 20:33:43'),
(6, 4, '4', 400.00, 3, 30.00, 0.00, 840.00, '2025-08-23', NULL, 'OUTRO', 1200.00, 'EM ABERTO', '09/2025', '2025-08-21 20:53:59', '2025-08-23 12:10:44'),
(7, 12, '12', 500.00, 3, 30.00, 0.00, 1050.00, '2025-08-21', '133125', 'OUTRO', 1500.00, 'EM ABERTO', '09/2025', '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(8, 13, '13', NULL, 3, 30.00, 0.00, 0.00, NULL, NULL, 'OUTRO', 0.00, 'EM ABERTO', '03/2025', '2025-08-21 22:35:30', '2025-08-22 13:08:37'),
(9, 14, '14', NULL, 3, 30.00, 0.00, 0.00, NULL, NULL, 'OUTRO', 0.00, 'EM ABERTO', '07/2025', '2025-08-21 23:08:38', '2025-08-21 23:08:38'),
(10, 15, '15', 4000.00, 3, 30.00, 0.00, 0.00, '2025-08-21', '133125', 'GOVERNO DO PIAUI', 12000.00, 'EM ABERTO', '07/2025', '2025-08-21 23:21:55', '2025-08-22 02:52:41'),
(14, 19, '19', NULL, 3, 30.00, 0.00, 0.00, NULL, NULL, 'OUTRO', 0.00, 'EM ABERTO', NULL, '2025-08-22 13:16:47', '2025-08-22 13:16:47'),
(15, 20, '20', NULL, 3, 30.00, 0.00, 0.00, NULL, NULL, 'OUTRO', 0.00, 'EM ABERTO', NULL, '2025-08-22 13:22:47', '2025-08-22 13:22:47'),
(16, 21, '21', NULL, 3, 30.00, 0.00, 0.00, NULL, NULL, 'OUTRO', 0.00, 'EM ABERTO', NULL, '2025-08-22 13:27:02', '2025-08-22 13:27:02'),
(17, 22, '22', 1050.00, 3, 30.00, 0.00, 735.00, '2025-08-22', '3319946', 'GOVERNO DO PIAUI', 1050.00, 'EM ABERTO', '09/2025', '2025-08-22 18:17:54', '2025-08-29 17:08:15'),
(19, 8, '8', 400.05, 3, 30.00, 0.00, 840.11, '2025-08-20', NULL, 'OUTRO', 1200.15, 'EM ABERTO', '09/2025', '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(20, 25, '25', 400.00, 3, 30.00, 0.00, 840.00, '2025-08-23', NULL, 'OUTRO', 1200.00, 'EM ABERTO', '09/2025', '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(21, 26, '26', 500.00, 3, 30.00, 0.00, 1050.00, '2025-08-23', NULL, 'OUTRO', 1500.00, 'EM ABERTO', '09/2025', '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(23, 28, '28', 500.00, 3, 30.00, 0.00, 1050.00, '2025-08-23', NULL, 'OUTRO', 1500.00, 'EM ABERTO', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_contrato_parcela`
--

CREATE TABLE `pessoa_contrato_parcela` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `contrato_id` bigint(20) UNSIGNED NOT NULL,
  `num_parcela` int(11) DEFAULT NULL,
  `tipo_receita` varchar(100) DEFAULT NULL,
  `valor_parcela` decimal(12,2) DEFAULT NULL,
  `vencimento` date DEFAULT NULL,
  `dias_atraso` int(11) DEFAULT NULL,
  `juros_percent` decimal(8,2) DEFAULT NULL,
  `valor_juros` decimal(12,2) DEFAULT NULL,
  `valor_pago` decimal(12,2) DEFAULT NULL,
  `data_pagamento` date DEFAULT NULL,
  `status_parcela` enum('PAGO','PENDENTE','EM ATRASO') DEFAULT 'PENDENTE',
  `observacao` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_contrato_parcela`
--

INSERT INTO `pessoa_contrato_parcela` (`id`, `contrato_id`, `num_parcela`, `tipo_receita`, `valor_parcela`, `vencimento`, `dias_atraso`, `juros_percent`, `valor_juros`, `valor_pago`, `data_pagamento`, `status_parcela`, `observacao`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '1 Débito em Conta', 114.00, '2025-09-05', 15, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(2, 1, 2, '1 Débito em Conta', 114.00, '2025-10-07', 47, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(3, 1, 3, '1 Débito em Conta', 114.00, '2025-11-07', 78, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(7, 2, 1, '1 Débito em Conta', 250.00, '2025-09-05', 15, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 18:54:48', '2025-08-20 18:54:48'),
(8, 2, 2, '1 Débito em Conta', 250.00, '2025-10-07', 47, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 18:54:48', '2025-08-20 18:54:48'),
(9, 2, 3, '1 Débito em Conta', 250.00, '2025-11-07', 78, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 18:54:48', '2025-08-20 18:54:48'),
(10, 5, 1, '1 Débito em Conta', 250.00, '2025-09-05', 15, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 20:33:43', '2025-08-20 20:33:43'),
(11, 5, 2, '1 Débito em Conta', 250.00, '2025-10-07', 47, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 20:33:43', '2025-08-20 20:33:43'),
(12, 5, 3, '1 Débito em Conta', 250.00, '2025-11-07', 78, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-20 20:33:43', '2025-08-20 20:33:43'),
(16, 7, 1, '1 Débito em Conta', 500.00, '2025-09-05', 0, 0.00, 0.00, 500.00, '2025-05-01', 'PAGO', 'Folha 05/2025 CPF 00763819352 Mat 06724762316 Status 1', '2025-08-21 21:11:59', '2025-08-29 04:03:55'),
(17, 7, 2, '1 Débito em Conta', 500.00, '2025-10-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(18, 7, 3, '1 Débito em Conta', 500.00, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(25, 8, NULL, '1 Débito em Conta', NULL, NULL, 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-22 13:08:37', '2025-08-22 13:08:37'),
(29, 17, 1, '1 Débito em Conta', 350.00, '2025-10-05', 0, 0.00, 0.00, 350.00, '2025-08-13', 'PAGO', 'Folha 05/2025 CPF 04018631316 Mat 3319946 Status 1', '2025-08-22 18:17:54', '2025-08-29 17:10:15'),
(30, 17, 2, '1 Débito em Conta', 350.00, '2025-11-05', 0, 0.00, 0.00, 350.00, '2025-09-05', 'PAGO', 'Folha 05/2025 CPF 04018631316 Mat 3319946 Status 1', '2025-08-22 18:17:54', '2025-08-29 17:10:36'),
(31, 17, 3, '1 Débito em Conta', 350.00, '2025-12-05', 0, 0.00, 0.00, 350.00, '2025-10-06', 'PAGO', 'Folha 05/2025 CPF 04018631316 Mat 3319946 Status 1', '2025-08-22 18:17:54', '2025-08-29 17:10:51'),
(32, 19, 1, '1 Débito em Conta', 400.05, '2025-10-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(33, 19, 2, '1 Débito em Conta', 400.05, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(34, 19, 3, '1 Débito em Conta', 400.05, '2025-12-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(35, 20, 1, '1 Débito em Conta', 400.00, '2025-10-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(36, 20, 2, '1 Débito em Conta', 400.00, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(37, 20, 3, '1 Débito em Conta', 400.00, '2025-12-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(38, 21, 1, '1 Débito em Conta', 500.00, '2025-10-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(39, 21, 2, '1 Débito em Conta', 500.00, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(40, 21, 3, '1 Débito em Conta', 500.00, '2025-12-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(41, 6, 1, '1 Débito em Conta', 400.00, '2025-09-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 12:10:44', '2025-08-23 12:10:44'),
(42, 6, 2, '1 Débito em Conta', 400.00, '2025-10-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 12:10:44', '2025-08-23 12:10:44'),
(43, 6, 3, '1 Débito em Conta', 400.00, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 12:10:44', '2025-08-23 12:10:44'),
(44, 23, 1, '1 Débito em Conta', 500.00, '2025-10-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39'),
(45, 23, 2, '1 Débito em Conta', 500.00, '2025-11-07', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39'),
(46, 23, 3, '1 Débito em Conta', 500.00, '2025-12-05', 0, 0.00, 0.00, 0.00, NULL, 'PENDENTE', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_detalhe`
--

CREATE TABLE `pessoa_detalhe` (
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `orgao_expedidor` varchar(80) DEFAULT NULL,
  `orgao_publico` varchar(120) DEFAULT NULL,
  `situacao_servidor` varchar(60) DEFAULT NULL,
  `matricula_servidor_publico` varchar(60) DEFAULT NULL,
  `numero_endereco` varchar(20) DEFAULT NULL,
  `observacoes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_detalhe`
--

INSERT INTO `pessoa_detalhe` (`pessoa_id`, `orgao_expedidor`, `orgao_publico`, `situacao_servidor`, `matricula_servidor_publico`, `numero_endereco`, `observacoes`, `created_at`, `updated_at`) VALUES
(4, 'ssp', 'pm pi', 'Ativo', '123456', '111', NULL, '2025-08-21 13:02:20', '2025-08-23 12:10:44'),
(8, 'SSPPI', 'GOVERNO PIAUI', 'Ativo', '0101010110', '68', NULL, '2025-08-23 01:41:48', '2025-08-23 01:41:48'),
(12, 'ssp', 'teresina MPU', 'Ativo', '131314', '11', 'antecipara todas as parcelas em um unico mês.', '2025-08-21 21:11:59', '2025-08-21 21:11:59'),
(13, 'ssp', NULL, NULL, NULL, '1245', NULL, '2025-08-21 22:35:30', '2025-08-22 13:08:37'),
(14, 'ssp', NULL, 'Ativo', NULL, '5225', NULL, '2025-08-21 23:08:38', '2025-08-21 23:08:38'),
(15, 'ssp', 'TRE', 'Ativo', '2025111BEMCCCAS12', '1212', 'qualquer coisa', '2025-08-21 23:21:55', '2025-08-22 02:53:10'),
(19, 'ssp', NULL, NULL, NULL, '1245', NULL, '2025-08-22 13:16:47', '2025-08-22 13:16:47'),
(20, 'ssp', NULL, NULL, NULL, '6666', NULL, '2025-08-22 13:22:47', '2025-08-22 13:22:47'),
(21, 'ssp', NULL, NULL, NULL, '6541', NULL, '2025-08-22 13:27:02', '2025-08-22 13:27:02'),
(22, 'ssp', 'PM PI', 'Ativo', '3319946', '17', NULL, '2025-08-22 18:17:53', '2025-08-22 18:17:53'),
(25, 'SSP', 'PM', 'Aposentado', '13215648', '1', 'Nada', '2025-08-23 10:04:26', '2025-08-23 10:04:26'),
(26, 'ssp', 's', 'Ativo', '122121', '1', 'ss', '2025-08-23 10:17:16', '2025-08-23 10:17:16'),
(28, 's', 'Pref', 'Ativo', '123456', '1', NULL, '2025-08-23 22:25:39', '2025-08-23 22:25:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_documento`
--

CREATE TABLE `pessoa_documento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `contrato_id` bigint(20) UNSIGNED DEFAULT NULL,
  `original_name` varchar(255) NOT NULL,
  `stored_name` varchar(255) NOT NULL,
  `mime` varchar(80) NOT NULL,
  `size_bytes` int(10) UNSIGNED NOT NULL,
  `relative_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_documento`
--

INSERT INTO `pessoa_documento` (`id`, `pessoa_id`, `contrato_id`, `original_name`, `stored_name`, `mime`, `size_bytes`, `relative_path`, `uploaded_at`) VALUES
(1, 4, 1, 'logo.png', '20250821_130220_5cc9391b.png', 'image/png', 855843, 'uploads/associados/4/20250821_130220_5cc9391b.png', '2025-08-21 13:02:20'),
(2, 12, 4, 'mercado-livre-logo-vertical-2 1.png', '20250821_211159_bc69a02f.png', 'image/png', 25054, 'uploads/associados/12/20250821_211159_bc69a02f.png', '2025-08-21 21:11:59'),
(3, 12, 4, 'gmail.png', '20250821_211159_524da472.png', 'image/png', 7267, 'uploads/associados/12/20250821_211159_524da472.png', '2025-08-21 21:11:59'),
(4, 13, 5, 'comprovante.png', '20250821_223530_410bb7ab.png', 'image/png', 16687, 'uploads/associados/13/20250821_223530_410bb7ab.png', '2025-08-21 22:35:30'),
(5, 14, 6, 'comprovante.png', '20250821_230838_2f506127.png', 'image/png', 16687, 'uploads/associados/14/20250821_230838_2f506127.png', '2025-08-21 23:08:38'),
(6, 15, 7, 'comprovante.png', '20250821_232155_f3051485.png', 'image/png', 16687, 'uploads/associados/15/20250821_232155_f3051485.png', '2025-08-21 23:21:55'),
(7, 4, 8, 'terra prometida.pdf', '20250822_115101_6ac463d5.pdf', 'application/pdf', 46410, 'uploads/associados/4/20250822_115101_6ac463d5.pdf', '2025-08-22 11:51:01'),
(8, 4, 8, 'Group 3.png', '20250822_115101_1ef2a498.png', 'image/png', 9712169, 'uploads/associados/4/20250822_115101_1ef2a498.png', '2025-08-22 11:51:01'),
(9, 4, 8, 'testing.pdf', '20250822_115101_0ffc6799.pdf', 'application/pdf', 44043, 'uploads/associados/4/20250822_115101_0ffc6799.pdf', '2025-08-22 11:51:01'),
(10, 4, 8, 'fr.png', '20250822_115101_7ff07a02.png', 'image/png', 9330, 'uploads/associados/4/20250822_115101_7ff07a02.png', '2025-08-22 11:51:01'),
(11, 4, 8, 'image.png', '20250822_115101_97157a13.png', 'image/png', 58867, 'uploads/associados/4/20250822_115101_97157a13.png', '2025-08-22 11:51:01'),
(12, 13, 9, 'comprovante.png', '20250822_130837_e2841e76.png', 'image/png', 16687, 'uploads/associados/13/20250822_130837_e2841e76.png', '2025-08-22 13:08:37'),
(13, 19, 11, 'comprovante.png', '20250822_131647_4f1f80f5.png', 'image/png', 16687, 'uploads/associados/19/20250822_131647_4f1f80f5.png', '2025-08-22 13:16:47'),
(14, 20, 12, 'comprovante.png', '20250822_132247_dc578e69.png', 'image/png', 16687, 'uploads/associados/20/20250822_132247_dc578e69.png', '2025-08-22 13:22:47'),
(15, 21, 13, 'comprovante.png', '20250822_132702_ef2b1bfa.png', 'image/png', 16687, 'uploads/associados/21/20250822_132702_ef2b1bfa.png', '2025-08-22 13:27:02'),
(16, 22, 14, 'abase.png', '20250822_181753_57add563.png', 'image/png', 5104, 'uploads/associados/22/20250822_181753_57add563.png', '2025-08-22 18:17:53'),
(17, 4, 15, 'abase.png', '20250822_210154_1e582c0e.png', 'image/png', 5104, 'uploads/associados/4/20250822_210154_1e582c0e.png', '2025-08-22 21:01:54'),
(18, 25, 17, 'freepik_br_df5f836b-e6ef-4871-a75c-e7d4fb405f95.png', '20250823_100426_3fc1f9a1.png', 'image/png', 722849, 'uploads/associados/25/20250823_100426_3fc1f9a1.png', '2025-08-23 10:04:26'),
(19, 25, 17, 'freepik_br_ebbcdeba-37d3-4b4e-9db7-b783ba77da42.png', '20250823_100426_aa322121.png', 'image/png', 1470276, 'uploads/associados/25/20250823_100426_aa322121.png', '2025-08-23 10:04:26'),
(20, 25, 17, 'medal.png', '20250823_100426_a0f8acc5.png', 'image/png', 36734, 'uploads/associados/25/20250823_100426_a0f8acc5.png', '2025-08-23 10:04:26'),
(21, 25, 17, 'woman_abase.jpg', '20250823_100426_1a737787.jpg', 'image/jpeg', 1264835, 'uploads/associados/25/20250823_100426_1a737787.jpg', '2025-08-23 10:04:26'),
(22, 26, 18, '751915f57e85f8be363c3d5833e6718f-b76770de856ebb830417552814410738-1024-1024.jpg', '20250823_101716_85cb5936.jpg', 'image/jpeg', 223066, 'uploads/associados/26/20250823_101716_85cb5936.jpg', '2025-08-23 10:17:16'),
(23, 4, 19, 'terra prometida.pdf', '20250823_121044_f2c74eab.pdf', 'application/pdf', 46410, 'uploads/associados/4/20250823_121044_f2c74eab.pdf', '2025-08-23 12:10:44');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_extra`
--

CREATE TABLE `pessoa_extra` (
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `dados_bancarios` mediumtext DEFAULT NULL,
  `contrato` mediumtext DEFAULT NULL,
  `antecipacao` mediumtext DEFAULT NULL,
  `pagamentos` mediumtext DEFAULT NULL,
  `observacoes` mediumtext DEFAULT NULL,
  `repasse` mediumtext DEFAULT NULL,
  `assinatura` varchar(120) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_extra`
--

INSERT INTO `pessoa_extra` (`pessoa_id`, `dados_bancarios`, `contrato`, `antecipacao`, `pagamentos`, `observacoes`, `repasse`, `assinatura`, `updated_at`) VALUES
(2, '[{\"conta\":\"001\",\"agencia\":\"8817-1\",\"banco\":\"inter\",\"valor\":\"15000\",\"tipo\":\"corrente\",\"saldo_devedor\":\"\"},{\"conta\":\"\",\"agencia\":\"\",\"banco\":\"\",\"valor\":\"\",\"tipo\":\"\",\"saldo_devedor\":\"\"}]', '{\"parcela\":\"R$ 400,00\",\"prazo\":3,\"taxa\":\"30,00\",\"custo\":\"R$ 0,00\",\"valor_liberado\":\"R$ 840,00\",\"data_aprov\":\"2025-08-20\",\"nb\":\"\",\"produto\":\"GOVERNO DO PIAUI\",\"total_financ\":\"R$ 1.200,00\",\"status\":\"EM ABERTO\",\"mes_averb\":\"11\\/2025\",\"codigo\":\"\"}', '[{\"cod_processo\":\"2\",\"parcela\":\"1\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-09-05\",\"dias_atraso\":\"15\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"2\",\"parcela\":\"2\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-10-07\",\"dias_atraso\":\"47\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"2\",\"parcela\":\"3\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-11-07\",\"dias_atraso\":\"78\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"}]', '[{\"cod\":\"\",\"tipo\":\"Débito Conta\",\"valor\":\"\",\"vencimento\":\"\",\"obs\":\"\",\"doacao\":\"\",\"pagamento\":\"\",\"status\":\"PENDENTE\",\"observ\":\"\"}]', '', '{\"comissao\":\"30,00\",\"data_comissao\":\"2025-08-20\",\"status\":\"PENDENTE\"}', '', '2025-08-20 16:50:54'),
(3, '[{\"conta\":\"\",\"agencia\":\"\",\"banco\":\"\",\"valor\":\"\",\"tipo\":\"\",\"saldo_devedor\":\"\"}]', '{\"parcela\":\"R$ 114,00\",\"prazo\":3,\"taxa\":\"30,00\",\"custo\":\"R$ 0,00\",\"valor_liberado\":\"R$ 239,40\",\"data_aprov\":\"2025-08-20\",\"nb\":\"\",\"produto\":\"GOVERNO DO PIAUI\",\"total_financ\":\"R$ 342,00\",\"status\":\"EM ABERTO\",\"mes_averb\":\"11\\/2025\",\"codigo\":\"3\"}', '[{\"cod_processo\":\"3\",\"parcela\":\"1\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 114,00\",\"vencimento\":\"2025-09-05\",\"dias_atraso\":\"15\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"3\",\"parcela\":\"2\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 114,00\",\"vencimento\":\"2025-10-07\",\"dias_atraso\":\"47\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"3\",\"parcela\":\"3\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 114,00\",\"vencimento\":\"2025-11-07\",\"dias_atraso\":\"78\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"}]', '[{\"cod\":\"\",\"tipo\":\"Débito Conta\",\"valor\":\"\",\"vencimento\":\"\",\"obs\":\"\",\"doacao\":\"\",\"pagamento\":\"\",\"status\":\"PENDENTE\",\"observ\":\"\"}]', '', '{\"comissao\":\"30,00\",\"data_comissao\":\"2025-08-20\",\"status\":\"PENDENTE\"}', '', '2025-08-20 17:30:33'),
(4, '[{\"conta\":\"27806437-4\",\"agencia\":\"0722\",\"banco\":\"Santander\",\"valor\":\"6.000,00\",\"tipo\":\"Poupanca\",\"saldo_devedor\":\"\"}]', '{\"parcela\":\"400\",\"prazo\":3,\"taxa\":\"30,00\",\"custo\":\"R$ 0,00\",\"valor_liberado\":\"R$ 840,00\",\"data_aprov\":\"2025-08-20\",\"nb\":\"131314\",\"produto\":\"GOVERNO DO PIAUI\",\"total_financ\":\"R$ 1.200,00\",\"status\":\"EM ABERTO\",\"mes_averb\":\"11\\/2025\",\"codigo\":\"\"}', '[{\"cod_processo\":\"4\",\"parcela\":\"1\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-09-05\",\"dias_atraso\":\"16\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"4\",\"parcela\":\"2\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-10-07\",\"dias_atraso\":\"48\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"4\",\"parcela\":\"3\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 400,00\",\"vencimento\":\"2025-11-07\",\"dias_atraso\":\"79\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"}]', '[{\"cod\":\"\",\"tipo\":\"Débito Conta\",\"valor\":\"\",\"vencimento\":\"\",\"obs\":\"\",\"doacao\":\"\",\"pagamento\":\"\",\"status\":\"PENDENTE\",\"observ\":\"\"}]', '', '{\"comissao\":\"10,00\",\"data_comissao\":\"2025-08-20\",\"status\":\"PENDENTE\"}', '', '2025-08-20 13:15:48'),
(6, '[{\"conta\":\"14145-9\",\"agencia\":\"1234\",\"banco\":\"inter\",\"valor\":\"10.000,00\",\"tipo\":\"Corrente\",\"saldo_devedor\":\"\"}]', '{\"parcela\":\"R$ 250,00\",\"prazo\":3,\"taxa\":\"30,00\",\"custo\":\"R$ 0,00\",\"valor_liberado\":\"R$ 525,00\",\"data_aprov\":\"2025-08-20\",\"nb\":\"\",\"produto\":\"GOVERNO DO PIAUI\",\"total_financ\":\"R$ 750,00\",\"status\":\"EM ABERTO\",\"mes_averb\":\"11\\/2025\",\"codigo\":\"6\"}', '[{\"cod_processo\":\"6\",\"parcela\":\"1\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-09-05\",\"dias_atraso\":\"15\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"6\",\"parcela\":\"2\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-10-07\",\"dias_atraso\":\"47\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"6\",\"parcela\":\"3\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-11-07\",\"dias_atraso\":\"78\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"}]', '[{\"cod\":\"\",\"tipo\":\"Débito Conta\",\"valor\":\"\",\"vencimento\":\"\",\"obs\":\"\",\"doacao\":\"\",\"pagamento\":\"\",\"status\":\"PENDENTE\",\"observ\":\"\"}]', '', '{\"comissao\":\"10,00\",\"data_comissao\":\"2025-08-20\",\"status\":\"PENDENTE\"}', 'Peltson', '2025-08-20 18:54:48'),
(7, '[{\"conta\":\"6464\",\"agencia\":\"164\",\"banco\":\"Helcio Venancio\",\"valor\":\"1.200,00\",\"tipo\":\"Corrente\",\"saldo_devedor\":\"\"}]', '{\"parcela\":\"250\",\"prazo\":3,\"taxa\":\"30,00\",\"custo\":\"R$ 0,00\",\"valor_liberado\":\"R$ 525,00\",\"data_aprov\":\"2025-08-20\",\"nb\":\"\",\"produto\":\"GOVERNO DO PIAUI\",\"total_financ\":\"R$ 750,00\",\"status\":\"EM ABERTO\",\"mes_averb\":\"11\\/2025\",\"codigo\":\"7\"}', '[{\"cod_processo\":\"7\",\"parcela\":\"1\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-09-05\",\"dias_atraso\":\"15\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"7\",\"parcela\":\"2\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-10-07\",\"dias_atraso\":\"47\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"},{\"cod_processo\":\"7\",\"parcela\":\"3\",\"tipo\":\"1 Débito em Conta\",\"valor\":\"R$ 250,00\",\"vencimento\":\"2025-11-07\",\"dias_atraso\":\"78\",\"juros\":\"0,00\",\"valor_juros\":\"R$ 0,00\",\"valor_pago\":\"R$ 0,00\",\"data_pagamento\":\"\",\"status\":\"PENDENTE\",\"obs\":\"\"}]', '[{\"cod\":\"\",\"tipo\":\"Débito Conta\",\"valor\":\"\",\"vencimento\":\"\",\"obs\":\"\",\"doacao\":\"\",\"pagamento\":\"\",\"status\":\"PENDENTE\",\"observ\":\"\"}]', '', '{\"comissao\":\"10,00\",\"data_comissao\":\"2025-08-20\",\"status\":\"PENDENTE\"}', 'Peltson', '2025-08-20 20:33:42');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pessoa_mensalidade`
--

CREATE TABLE `pessoa_mensalidade` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pessoa_id` bigint(20) UNSIGNED NOT NULL,
  `cod_mensalidade` varchar(30) DEFAULT NULL,
  `tipo` varchar(60) DEFAULT NULL,
  `valor` decimal(12,2) DEFAULT NULL,
  `vencimento` date DEFAULT NULL,
  `obs` text DEFAULT NULL,
  `doacao_enviada` date DEFAULT NULL,
  `pagamento` date DEFAULT NULL,
  `status` enum('PENDENTE','PAGO','EM ATRASO') DEFAULT 'PENDENTE',
  `observ` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pessoa_mensalidade`
--

INSERT INTO `pessoa_mensalidade` (`id`, `pessoa_id`, `cod_mensalidade`, `tipo`, `valor`, `vencimento`, `obs`, `doacao_enviada`, `pagamento`, `status`, `observ`, `created_at`, `updated_at`) VALUES
(1, 4, '', 'Débito Conta', NULL, NULL, '', NULL, NULL, 'PENDENTE', '', '2025-08-20 13:15:48', '2025-08-20 13:15:48'),
(2, 2, '', 'Débito Conta', NULL, NULL, '', NULL, NULL, 'PENDENTE', '', '2025-08-20 16:50:54', '2025-08-20 16:50:54'),
(3, 3, '', 'Débito Conta', NULL, NULL, '', NULL, NULL, 'PENDENTE', '', '2025-08-20 17:30:33', '2025-08-20 17:30:33'),
(6, 6, '', 'Débito Conta', NULL, NULL, '', NULL, NULL, 'PENDENTE', '', '2025-08-20 18:54:48', '2025-08-20 18:54:48'),
(7, 7, '', 'Débito Conta', NULL, NULL, '', NULL, NULL, 'PENDENTE', '', '2025-08-20 20:33:43', '2025-08-20 20:33:43');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(160) NOT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`id`, `nome`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Crédito Consignado', 'ativo', '2025-08-18 23:48:44', '2025-08-18 23:48:44'),
(2, 'Antecipação Salarial', 'ativo', '2025-08-18 23:48:44', '2025-08-18 23:48:44'),
(3, 'Cartão Benefício', 'ativo', '2025-08-18 23:48:44', '2025-08-18 23:48:44'),
(4, 'Serviço Terceirizado', 'ativo', '2025-08-18 23:48:44', '2025-08-18 23:48:44'),
(5, 'Convênio Administração', 'ativo', '2025-08-18 23:48:44', '2025-08-18 23:48:44');

-- --------------------------------------------------------

--
-- Estrutura para tabela `recebimento`
--

CREATE TABLE `recebimento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `numero_contrato` varchar(40) NOT NULL,
  `loja_id` bigint(20) UNSIGNED DEFAULT NULL,
  `agente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `produto_id` bigint(20) UNSIGNED DEFAULT NULL,
  `cliente_id` bigint(20) UNSIGNED DEFAULT NULL,
  `agente_nome` varchar(180) DEFAULT NULL,
  `cliente_nome` varchar(180) DEFAULT NULL,
  `cpf_cnpj` varchar(20) DEFAULT NULL,
  `data_vencimento` date DEFAULT NULL,
  `data_pagamento` date DEFAULT NULL,
  `data_aprovacao` date DEFAULT NULL,
  `data_repasse` date DEFAULT NULL,
  `mes_averbacao` date DEFAULT NULL,
  `status_contrato` enum('ATIVO','INATIVO','CANCELADO','EM_ANALISE','APROVADO','REPROVADO') NOT NULL DEFAULT 'ATIVO',
  `status_mensalidade` enum('PAGO','PAGO_PARCIAL','PENDENTE') NOT NULL DEFAULT 'PENDENTE',
  `status_repasse` enum('AGUARDANDO','REPASSADO','PENDENTE','CANCELADO') NOT NULL DEFAULT 'PENDENTE',
  `valor_parcela` decimal(12,2) DEFAULT 0.00,
  `valor_pago` decimal(12,2) DEFAULT 0.00,
  `valor_repasse` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `recebimento`
--

INSERT INTO `recebimento` (`id`, `numero_contrato`, `loja_id`, `agente_id`, `produto_id`, `cliente_id`, `agente_nome`, `cliente_nome`, `cpf_cnpj`, `data_vencimento`, `data_pagamento`, `data_aprovacao`, `data_repasse`, `mes_averbacao`, `status_contrato`, `status_mensalidade`, `status_repasse`, `valor_parcela`, `valor_pago`, `valor_repasse`, `created_at`, `updated_at`) VALUES
(9, 'CT-2025-001', 1, 1, 1, 1, 'Maria Santos Silva', 'João Silva Santos', '***.***.***-12', '2025-08-10', '2025-08-12', '2025-08-12', '2025-08-15', '2025-08-01', 'APROVADO', 'PAGO', 'REPASSADO', 1500.00, 1500.00, 1200.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(10, 'CT-2025-002', 1, 2, 2, 2, 'João Pereira Costa', 'Maria Oliveira Costa', '***.***.***-34', '2025-08-15', NULL, '2025-08-14', NULL, '2025-08-01', 'EM_ANALISE', 'PENDENTE', 'AGUARDANDO', 800.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(11, 'CT-2025-003', 1, 3, 3, 3, 'Ana Costa Lima', 'Pedro Almeida Lima', '***.***.***-56', '2025-08-20', '2025-08-21', '2025-08-21', '2025-08-23', '2025-08-01', 'ATIVO', 'PAGO_PARCIAL', 'PENDENTE', 2000.00, 1000.00, 700.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(12, 'CT-2025-004', 1, 4, 1, 4, 'Carlos Silva Rocha', 'Ana Carolina Ferreira', '***.***.***-78', '2025-08-25', NULL, NULL, NULL, '2025-08-01', 'ATIVO', 'PENDENTE', 'AGUARDANDO', 1200.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(13, 'CT-2025-005', 5, 1, 4, 5, 'Maria Santos Silva', 'Carlos Eduardo Sousa', '***.***.***-90', '2025-08-12', '2025-08-12', '2025-08-12', '2025-08-14', '2025-08-01', 'APROVADO', 'PAGO', 'REPASSADO', 950.00, 950.00, 760.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(14, 'CT-2025-006', 5, 2, 3, 6, 'João Pereira Costa', 'Francisca Santos Rocha', '***.***.***-01', '2025-08-18', '2025-08-18', '2025-08-18', NULL, '2025-08-01', 'ATIVO', 'PAGO', 'PENDENTE', 680.00, 680.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(15, 'CT-2025-007', 5, 3, 2, 7, 'Ana Costa Lima', 'Roberto Lima Nascimento', '***.***.***-23', '2025-08-22', NULL, '2025-08-20', NULL, '2025-08-01', 'EM_ANALISE', 'PENDENTE', 'AGUARDANDO', 1100.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(16, 'CT-2025-008', 5, 4, 1, 8, 'Carlos Silva Rocha', 'Luciana Pereira Dias', '***.***.***-45', '2025-08-28', NULL, NULL, NULL, '2025-08-01', 'ATIVO', 'PENDENTE', 'AGUARDANDO', 730.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(17, 'CT-2025-009', 6, 1, 2, 9, 'Maria Santos Silva', 'Antonio José Barbosa', '***.***.***-67', '2025-08-09', '2025-08-10', '2025-08-10', '2025-08-12', '2025-08-01', 'APROVADO', 'PAGO', 'REPASSADO', 1400.00, 1400.00, 1120.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(18, 'CT-2025-010', 6, 2, 1, 10, 'João Pereira Costa', 'Silvia Regina Moura', '***.***.***-89', '2025-08-14', '2025-08-16', '2025-08-16', '2025-08-19', '2025-08-01', 'APROVADO', 'PAGO', 'REPASSADO', 620.00, 620.00, 500.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(19, 'CT-2025-011', 6, 3, 3, 11, 'Ana Costa Lima', 'Fernando Costa Lima', '***.***.***-11', '2025-08-19', NULL, '2025-08-18', NULL, '2025-08-01', 'EM_ANALISE', 'PENDENTE', 'AGUARDANDO', 880.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09'),
(20, 'CT-2025-012', 6, 4, 4, 12, 'Carlos Silva Rocha', 'Mariana Santos Silva', '***.***.***-22', '2025-08-26', NULL, NULL, NULL, '2025-08-01', 'ATIVO', 'PENDENTE', 'AGUARDANDO', 1050.00, 0.00, 0.00, '2025-08-19 00:17:09', '2025-08-19 00:17:09');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `perfil` enum('admin','agente','associado') NOT NULL DEFAULT 'associado',
  `status` enum('Ativo','Inativo') NOT NULL DEFAULT 'Ativo',
  `dois_fatores` tinyint(1) NOT NULL DEFAULT 0,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha_hash`, `perfil`, `status`, `dois_fatores`, `criado_em`) VALUES
(6, 'lisa', 'lisa@teste.com', '$2y$10$zQwPIWUw3Dn4CRGQsmRnEuF.XJM3y.CJaZGFsyN29gsAg09pzaVS.', 'admin', 'Ativo', 0, '2025-08-21 20:07:53'),
(7, 'fabiano gomes', 'fabiano.goommes@gmail.com', '$2y$10$WbZtxMhYIMh0kzK517ZcVeXwUJkeQ0r4xpjbGE8V9FIFlgesW2BL6', 'associado', 'Ativo', 0, '2025-08-21 20:36:11'),
(8, 'eistein', 'eistein@teste.com', '$2y$10$zYbqXtMxZ/SIGwj3mEyAY.gFGifNAfkLh80Q1izMrT.XWtiPIVDjq', 'associado', 'Ativo', 0, '2025-08-21 20:48:56'),
(9, 'Administrador', 'abase@abase.com', '$2y$10$qXsMlb1WsooScXt4c0iZ5e40FNI7j2QFQdpoUSUJdShMOAalmjaEq', 'admin', 'Ativo', 0, '2025-08-21 20:56:21'),
(10, 'Helcio Piripiri', 'helciovenanciopi@gmail.com', '$2y$10$dBPrvJf/9Vg3e43XEQUh7uGue0n4PB5PRJyieJuln34rk1WqeiQzC', 'associado', 'Ativo', 0, '2025-08-22 12:46:28'),
(11, 'Helcio Helcio', 'helciohelcio@gmail.com', '$2y$10$1GXASRK1RHxLBjzhm1V3hOECpA3znk.aKxbsGf.l/bMWsseDXR2Xy', 'agente', 'Ativo', 0, '2025-08-22 13:20:47'),
(12, 'fabiano', 'fabiano1@gmail.com', '$2y$10$hDoJfrLd0cGT24LDcCbT6eens/JNrcIspzxZ53jdkaEvfVtiQMlUW', 'admin', 'Ativo', 0, '2025-08-22 20:32:30');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_folha_lancamentos`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_folha_lancamentos` (
`id` bigint(20) unsigned
,`arquivo_id` bigint(20) unsigned
,`entidade_codigo` varchar(16)
,`entidade_nome` varchar(190)
,`referencia` date
,`data_geracao` date
,`status_code` char(1)
,`status_descricao` varchar(160)
,`matricula_raw` varchar(20)
,`matricula_norm` varchar(20)
,`nome` varchar(150)
,`cargo` varchar(190)
,`fin_codigo` char(4)
,`orgao_codigo` char(3)
,`lanc_codigo` char(3)
,`total_pago_qtd` smallint(5) unsigned
,`valor` decimal(12,2)
,`orgao_pagto_codigo` char(3)
,`cpf` char(11)
,`created_at` timestamp
,`raw_line` text
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_folha_resumo_orgao`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_folha_resumo_orgao` (
`referencia` date
,`status_code` char(1)
,`status_descricao` varchar(160)
,`orgao_pagto_codigo` char(3)
,`lancamentos_qtd` bigint(21)
,`total_valor` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_folha_resumo_status`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vw_folha_resumo_status` (
`referencia` date
,`status_code` char(1)
,`status_descricao` varchar(160)
,`lancamentos_qtd` bigint(21)
,`total_valor` decimal(34,2)
);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agente`
--
ALTER TABLE `agente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_agente_codigo` (`codigo`),
  ADD UNIQUE KEY `uq_agente_nome_loja` (`nome`,`loja_id`),
  ADD KEY `idx_agente_nome` (`nome`),
  ADD KEY `idx_agente_loja` (`loja`),
  ADD KEY `idx_agente_loja_id` (`loja_id`);

--
-- Índices de tabela `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ts` (`ts`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_object` (`object_type`,`object_id`),
  ADD KEY `idx_actor` (`actor_pessoa_id`);

--
-- Índices de tabela `cadastro`
--
ALTER TABLE `cadastro`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_documento` (`documento`),
  ADD KEY `idx_cadastro_nome` (`nome_razao_social`),
  ADD KEY `idx_cadastro_celular` (`celular`),
  ADD KEY `idx_cadastro_cidade` (`cidade`,`uf`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cliente_codigo` (`codigo`),
  ADD UNIQUE KEY `uq_cliente_cpf` (`cpf`),
  ADD KEY `idx_cliente_nome` (`nome`),
  ADD KEY `idx_cliente_status` (`status_contrato`,`status_antecipacao`);

--
-- Índices de tabela `cliente_extra`
--
ALTER TABLE `cliente_extra`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `fk_extra_cliente` (`codigo`);

--
-- Índices de tabela `contrato`
--
ALTER TABLE `contrato`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pessoa_id` (`pessoa_id`);

--
-- Índices de tabela `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`contrato`),
  ADD KEY `idx_contratos_cpf` (`cpf`),
  ADD KEY `idx_contratos_data_aprov` (`data_aprov`),
  ADD KEY `idx_contratos_mes_averb` (`mes_averb`);

--
-- Índices de tabela `contrato_antecipacao`
--
ALTER TABLE `contrato_antecipacao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contrato_id` (`contrato_id`);

--
-- Índices de tabela `contrato_auxilio_agente`
--
ALTER TABLE `contrato_auxilio_agente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contrato_id` (`contrato_id`);

--
-- Índices de tabela `convenio`
--
ALTER TABLE `convenio`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_convenio_nome` (`nome`);

--
-- Índices de tabela `dados_bancarios`
--
ALTER TABLE `dados_bancarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_dados_bancarios_pessoa` (`pessoa_id`);

--
-- Índices de tabela `folha_arquivo`
--
ALTER TABLE `folha_arquivo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_ref_ent_hash` (`referencia`,`entidade_codigo`,`arquivo_hash`),
  ADD KEY `idx_ref` (`referencia`),
  ADD KEY `idx_entidade` (`entidade_codigo`);

--
-- Índices de tabela `folha_import`
--
ALTER TABLE `folha_import`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ref` (`referencia`),
  ADD KEY `idx_cpf` (`cpf`),
  ADD KEY `idx_matricula` (`matricula`);

--
-- Índices de tabela `folha_lancamento`
--
ALTER TABLE `folha_lancamento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_arq` (`arquivo_id`),
  ADD KEY `idx_status` (`status_code`),
  ADD KEY `idx_cpf` (`cpf`),
  ADD KEY `idx_matnorm` (`matricula_norm`),
  ADD KEY `idx_fin` (`fin_codigo`),
  ADD KEY `idx_orgao` (`orgao_codigo`),
  ADD KEY `idx_orgao_pagto` (`orgao_pagto_codigo`);

--
-- Índices de tabela `folha_lancamento_simples`
--
ALTER TABLE `folha_lancamento_simples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpf` (`cpf`),
  ADD KEY `idx_matricula` (`matricula`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_orgao_pagto` (`orgao_pagto`),
  ADD KEY `idx_contato_status` (`contato_status`),
  ADD KEY `idx_contato_atualizado` (`contato_atualizado_em`);

--
-- Índices de tabela `folha_orgao_resumo`
--
ALTER TABLE `folha_orgao_resumo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_resumo` (`arquivo_id`,`status_code`,`orgao_pagto_codigo`),
  ADD KEY `idx_resumo_arq` (`arquivo_id`),
  ADD KEY `fk_resumo_status` (`status_code`);

--
-- Índices de tabela `folha_status`
--
ALTER TABLE `folha_status`
  ADD PRIMARY KEY (`code`);

--
-- Índices de tabela `loja`
--
ALTER TABLE `loja`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_loja_nome` (`nome`);

--
-- Índices de tabela `pessoa`
--
ALTER TABLE `pessoa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pessoa_documento` (`documento`),
  ADD KEY `idx_pessoa_nome` (`nome_razao_social`),
  ADD KEY `idx_pessoa_celular` (`celular`),
  ADD KEY `idx_pessoa_cidade` (`cidade`,`uf`);

--
-- Índices de tabela `pessoa_bancario`
--
ALTER TABLE `pessoa_bancario`
  ADD PRIMARY KEY (`pessoa_id`),
  ADD KEY `idx_pessoa_bancario_pix` (`pix_chave`);

--
-- Índices de tabela `pessoa_contrato`
--
ALTER TABLE `pessoa_contrato`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_pc` (`pessoa_id`,`codigo`),
  ADD KEY `idx_pc_pessoa` (`pessoa_id`);

--
-- Índices de tabela `pessoa_contrato_parcela`
--
ALTER TABLE `pessoa_contrato_parcela`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pcp_contrato` (`contrato_id`,`num_parcela`);

--
-- Índices de tabela `pessoa_detalhe`
--
ALTER TABLE `pessoa_detalhe`
  ADD PRIMARY KEY (`pessoa_id`);

--
-- Índices de tabela `pessoa_documento`
--
ALTER TABLE `pessoa_documento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pessoa_id` (`pessoa_id`),
  ADD KEY `contrato_id` (`contrato_id`);

--
-- Índices de tabela `pessoa_extra`
--
ALTER TABLE `pessoa_extra`
  ADD PRIMARY KEY (`pessoa_id`);

--
-- Índices de tabela `pessoa_mensalidade`
--
ALTER TABLE `pessoa_mensalidade`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pm_pessoa` (`pessoa_id`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_produto_nome` (`nome`);

--
-- Índices de tabela `recebimento`
--
ALTER TABLE `recebimento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_rec_numero_contrato` (`numero_contrato`),
  ADD KEY `idx_rec_loja` (`loja_id`),
  ADD KEY `idx_rec_agente` (`agente_id`),
  ADD KEY `idx_rec_produto` (`produto_id`),
  ADD KEY `idx_rec_cliente` (`cliente_id`),
  ADD KEY `idx_rec_doc` (`cpf_cnpj`),
  ADD KEY `idx_rec_vencimento` (`data_vencimento`),
  ADD KEY `idx_rec_pagamento` (`data_pagamento`),
  ADD KEY `idx_rec_aprovacao` (`data_aprovacao`),
  ADD KEY `idx_rec_repasse` (`data_repasse`),
  ADD KEY `idx_rec_averbacao` (`mes_averbacao`),
  ADD KEY `idx_rec_status_all` (`status_contrato`,`status_mensalidade`,`status_repasse`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `uq_usuarios_email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agente`
--
ALTER TABLE `agente`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de tabela `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=831;

--
-- AUTO_INCREMENT de tabela `cadastro`
--
ALTER TABLE `cadastro`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `contrato`
--
ALTER TABLE `contrato`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `contrato_antecipacao`
--
ALTER TABLE `contrato_antecipacao`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de tabela `contrato_auxilio_agente`
--
ALTER TABLE `contrato_auxilio_agente`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `convenio`
--
ALTER TABLE `convenio`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `dados_bancarios`
--
ALTER TABLE `dados_bancarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `folha_arquivo`
--
ALTER TABLE `folha_arquivo`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `folha_import`
--
ALTER TABLE `folha_import`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=427;

--
-- AUTO_INCREMENT de tabela `folha_lancamento`
--
ALTER TABLE `folha_lancamento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `folha_lancamento_simples`
--
ALTER TABLE `folha_lancamento_simples`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1252;

--
-- AUTO_INCREMENT de tabela `folha_orgao_resumo`
--
ALTER TABLE `folha_orgao_resumo`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `loja`
--
ALTER TABLE `loja`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `pessoa`
--
ALTER TABLE `pessoa`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de tabela `pessoa_contrato`
--
ALTER TABLE `pessoa_contrato`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `pessoa_contrato_parcela`
--
ALTER TABLE `pessoa_contrato_parcela`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de tabela `pessoa_documento`
--
ALTER TABLE `pessoa_documento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `pessoa_mensalidade`
--
ALTER TABLE `pessoa_mensalidade`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de tabela `recebimento`
--
ALTER TABLE `recebimento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_folha_lancamentos`
--
DROP TABLE IF EXISTS `vw_folha_lancamentos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`abasepi`@`%` SQL SECURITY DEFINER VIEW `vw_folha_lancamentos`  AS SELECT `l`.`id` AS `id`, `a`.`id` AS `arquivo_id`, `a`.`entidade_codigo` AS `entidade_codigo`, `a`.`entidade_nome` AS `entidade_nome`, `a`.`referencia` AS `referencia`, `a`.`data_geracao` AS `data_geracao`, `l`.`status_code` AS `status_code`, `s`.`descricao` AS `status_descricao`, `l`.`matricula_raw` AS `matricula_raw`, `l`.`matricula_norm` AS `matricula_norm`, `l`.`nome` AS `nome`, `l`.`cargo` AS `cargo`, `l`.`fin_codigo` AS `fin_codigo`, `l`.`orgao_codigo` AS `orgao_codigo`, `l`.`lanc_codigo` AS `lanc_codigo`, `l`.`total_pago_qtd` AS `total_pago_qtd`, `l`.`valor` AS `valor`, `l`.`orgao_pagto_codigo` AS `orgao_pagto_codigo`, `l`.`cpf` AS `cpf`, `l`.`created_at` AS `created_at`, `l`.`raw_line` AS `raw_line` FROM ((`folha_lancamento` `l` join `folha_arquivo` `a` on(`a`.`id` = `l`.`arquivo_id`)) join `folha_status` `s` on(`s`.`code` = `l`.`status_code`)) ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_folha_resumo_orgao`
--
DROP TABLE IF EXISTS `vw_folha_resumo_orgao`;

CREATE ALGORITHM=UNDEFINED DEFINER=`abasepi`@`%` SQL SECURITY DEFINER VIEW `vw_folha_resumo_orgao`  AS SELECT `a`.`referencia` AS `referencia`, `l`.`status_code` AS `status_code`, `s`.`descricao` AS `status_descricao`, `l`.`orgao_pagto_codigo` AS `orgao_pagto_codigo`, count(0) AS `lancamentos_qtd`, sum(`l`.`valor`) AS `total_valor` FROM ((`folha_lancamento` `l` join `folha_arquivo` `a` on(`a`.`id` = `l`.`arquivo_id`)) join `folha_status` `s` on(`s`.`code` = `l`.`status_code`)) GROUP BY `a`.`referencia`, `l`.`status_code`, `s`.`descricao`, `l`.`orgao_pagto_codigo` ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_folha_resumo_status`
--
DROP TABLE IF EXISTS `vw_folha_resumo_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`abasepi`@`%` SQL SECURITY DEFINER VIEW `vw_folha_resumo_status`  AS SELECT `a`.`referencia` AS `referencia`, `l`.`status_code` AS `status_code`, `s`.`descricao` AS `status_descricao`, count(0) AS `lancamentos_qtd`, sum(`l`.`valor`) AS `total_valor` FROM ((`folha_lancamento` `l` join `folha_arquivo` `a` on(`a`.`id` = `l`.`arquivo_id`)) join `folha_status` `s` on(`s`.`code` = `l`.`status_code`)) GROUP BY `a`.`referencia`, `l`.`status_code`, `s`.`descricao` ;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `agente`
--
ALTER TABLE `agente`
  ADD CONSTRAINT `fk_agente_loja` FOREIGN KEY (`loja_id`) REFERENCES `loja` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Restrições para tabelas `contrato`
--
ALTER TABLE `contrato`
  ADD CONSTRAINT `fk_ct_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `contrato_antecipacao`
--
ALTER TABLE `contrato_antecipacao`
  ADD CONSTRAINT `fk_cta_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `contrato_auxilio_agente`
--
ALTER TABLE `contrato_auxilio_agente`
  ADD CONSTRAINT `fk_caa_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `dados_bancarios`
--
ALTER TABLE `dados_bancarios`
  ADD CONSTRAINT `fk_dados_bancarios_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `folha_lancamento`
--
ALTER TABLE `folha_lancamento`
  ADD CONSTRAINT `fk_lanc_arquivo` FOREIGN KEY (`arquivo_id`) REFERENCES `folha_arquivo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_lanc_status` FOREIGN KEY (`status_code`) REFERENCES `folha_status` (`code`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `folha_orgao_resumo`
--
ALTER TABLE `folha_orgao_resumo`
  ADD CONSTRAINT `fk_resumo_arquivo` FOREIGN KEY (`arquivo_id`) REFERENCES `folha_arquivo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resumo_status` FOREIGN KEY (`status_code`) REFERENCES `folha_status` (`code`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_bancario`
--
ALTER TABLE `pessoa_bancario`
  ADD CONSTRAINT `fk_pb_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_contrato`
--
ALTER TABLE `pessoa_contrato`
  ADD CONSTRAINT `fk_pc_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_contrato_parcela`
--
ALTER TABLE `pessoa_contrato_parcela`
  ADD CONSTRAINT `fk_pcp_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `pessoa_contrato` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_detalhe`
--
ALTER TABLE `pessoa_detalhe`
  ADD CONSTRAINT `fk_pd_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_documento`
--
ALTER TABLE `pessoa_documento`
  ADD CONSTRAINT `fk_doc_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_extra`
--
ALTER TABLE `pessoa_extra`
  ADD CONSTRAINT `fk_pessoa_extra` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pessoa_mensalidade`
--
ALTER TABLE `pessoa_mensalidade`
  ADD CONSTRAINT `fk_pm_pessoa` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `recebimento`
--
ALTER TABLE `recebimento`
  ADD CONSTRAINT `fk_rec_agente` FOREIGN KEY (`agente_id`) REFERENCES `agente` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rec_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rec_loja` FOREIGN KEY (`loja_id`) REFERENCES `loja` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rec_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
