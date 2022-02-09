-- MariaDB 10.4.21

-- Criação do BD e suas tabelas

CREATE SCHEMA `mainuser` DEFAULT CHARACTER SET utf8mb4 ;

CREATE TABLE `mainuser`.`comodos` (
  `idComodo` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `tamanhoM2` DOUBLE NOT NULL,
  `arCondicionado` TINYINT(1) NOT NULL COMMENT '0 = NÃO\n\n1 = SIM',
  `janelas` INT NOT NULL,
  PRIMARY KEY (`idComodo`));

CREATE TABLE `mainuser`.`ar_ativacoes` (
  `idEvento` int(11) NOT NULL AUTO_INCREMENT,
  `idComodo` int(11) NOT NULL,
  `desligar-ligar` tinyint(4) NOT NULL COMMENT '0 = desligar\n1 = ligar',
  `data` date NOT NULL,
  `horario` tinyint(1) NOT NULL,
  `temperatura` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idEvento`),
  KEY `idComodo` (`idComodo`),
  CONSTRAINT `idComodo` FOREIGN KEY (`idComodo`) REFERENCES `comodos` (`idComodo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `contato_emergencia` (
  `idContato` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `endereco` varchar(300) NOT NULL,
  `telefone-primario` varchar(15) NOT NULL,
  `telefone-secundario` varchar(15) DEFAULT NULL,
  `prioridade` tinyint(1) NOT NULL COMMENT 'Quanto menor o numero, maior a prioridade de contato',
  PRIMARY KEY (`idContato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `mainuser`.`funcionarios` (
  `idFuncionario` INT NOT NULL AUTO_INCREMENT,
  `funcao` VARCHAR(45) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(300) NOT NULL,
  `telefone-primario` VARCHAR(15) NOT NULL,
  `telefone-secundario` VARCHAR(15) NULL,
  PRIMARY KEY (`idFuncionario`));

CREATE TABLE `alimentacao` (
  `idAlimentacao` int(11) NOT NULL AUTO_INCREMENT,
  `dia` varchar(7) NOT NULL COMMENT 'apenas o primeiro nome ex: "Segunda" "Sexta" "Domingo"',
  `horario` tinyint(1) NOT NULL,
  `itens` varchar(45) NOT NULL,
  `idFuncionario` int(11) DEFAULT NULL COMMENT 'funcionario que ira preparar refeicao, usar NULL se for outro',
  `idLocalPreparo` int(11) DEFAULT NULL,
  `idLocalConsumo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idAlimentacao`),
  KEY `idFuncionario` (`idFuncionario`),
  KEY `idLocalPreparo` (`idLocalPreparo`),
  KEY `idLocalConsumo` (`idLocalConsumo`),
  CONSTRAINT `idFuncionario` FOREIGN KEY (`idFuncionario`) REFERENCES `funcionarios` (`idFuncionario`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `idLocalConsumo` FOREIGN KEY (`idLocalConsumo`) REFERENCES `comodos` (`idComodo`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `idLocalPreparo` FOREIGN KEY (`idLocalPreparo`) REFERENCES `comodos` (`idComodo`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- População das Tabelas


INSERT INTO `mainuser`.`comodos` VALUES 
(null, "Quarto", 15, 1, 1), 
(null, "Sala", 30, 0, 3), 
(null, "Cozinha", 5, 0, 1);

INSERT INTO `mainuser`.`contato_emergencia` VALUES 
(null, "Victor Padilha", "Rua A, Número 25", "+5581992384565", null, 0),
(null, "José de Queiroz", "Rua B, Número 29", "+5581998322565", "+558134545765", 1), 
(null, "Marco Braz", "Rua C, Número 345", "+5581982336795", null, 2);

INSERT INTO `mainuser`.`ar_ativacoes` VALUES 
(null, 3, 1, "2021-08-21", 23, 20), 
(null, 3, 0, "2021-08-22", 7, null), 
(null, 3, 1, "2021-08-25", 20, 23);

INSERT INTO `mainuser`.`funcionarios` VALUES 
(null, "Cozinheira", "Verônica Souza", "Rua D, Número 131", "+5581994382565", null),
(null, "Faxineira", "Maria Bastos", "Rua X, Número 1231", "+5581998542543", null), 
(null, "Enfermeiro", "Felipe Mergulhão", "Rua Y, Número 2323", "+5581992384234", "+558134568400");

INSERT INTO `mainuser`.`alimentacao` VALUES 
(null, "Sábado", 8, "Maçã, Iorgute e Granola", 1, 5, 3),
(null, "Terça", 13, "Frango assado e arroz integral", 1, 5, 4), 
(null, "Quinta", 20, "Sanduiche de Atum com Suco", 3, 5, 5);

-- Consultas

-- Mostra o Nome e telefone(s) do contato com maior prioridade em caso de emergência.

SELECT `contato_emergencia`.`nome`,
    `contato_emergencia`.`telefone-primario`,
    `contato_emergencia`.`telefone-secundario`
    FROM `mainuser`.`contato_emergencia` 
    WHERE prioridade=( SELECT MIN(prioridade) FROM `mainuser`.`contato_emergencia` );


-- Mostra as datas e horários que o ar-condicionado foi ligado.

SELECT `ar_ativacoes`.`data`,
	`ar_ativacoes`.`horario`
    FROM `mainuser`.`ar_ativacoes` 
    WHERE `ar_ativacoes`.`desligar-ligar`= 1;


-- Mostra todas as temperaturas que o ar esteve ligado em horário 
-- específico(X, que será fornecido pelo usuário, no frontend). Informação será processada e utilizada 
-- para definir a temperatura automaticamente naquele horário.
SELECT `ar_ativacoes`.`temperatura`
    FROM `mainuser`.`ar_ativacoes` 
    WHERE `ar_ativacoes`.`horario`= X AND `ar_ativacoes`.`desligar-ligar` = 1;    


-- Mostra quais refeições devem ser preparadas pelo funcionário de id 1 e consumidas no local de id 4

SELECT `alimentacao`.`dia`,
	`alimentacao`.`horario`,
    `alimentacao`.`itens`
FROM `mainuser`.`alimentacao`
WHERE `alimentacao`.`idFuncionario`= 1 AND `alimentacao`.`idLocalConsumo`= 4;

