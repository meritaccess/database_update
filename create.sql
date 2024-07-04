-- Rucne upravil Jara Bant
-- version 1.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Databáze: `MeritAccessLocal`

CREATE DATABASE IF NOT EXISTS `MeritAccessLocal` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `MeritAccessLocal`;

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`ma`@`localhost` PROCEDURE `ActivateTempCard` ()  BEGIN
 START TRANSACTION;
  delete from Karty;
  INSERT INTO Karty select * from tempKarty;
 COMMIT;
END$$

CREATE DEFINER=`ma`@`localhost` PROCEDURE `CanAccess` (IN `pKarta` VARCHAR(20), IN `pCtecka` INT, IN `pKdy` DATETIME, OUT `PristupPovolen` INT)  BEGIN
 select count(cardid) into PristupPovolen from Karty where (Karta like pKarta) and (Ctecka = pCtecka);
 INSERT INTO Access (Adresa, Karta, Ctecka, Tlacitko, Kdy, StavZpracovani) VALUES ('localhost', pKarta, pCtecka, 0, sysdate(3), 10);
END$$

CREATE DEFINER=`ma`@`localhost` PROCEDURE `SetVal` (IN `pTable` VARCHAR(20), IN `pProperty` VARCHAR(20), IN `pValue` VARCHAR(30))  MODIFIES SQL DATA
BEGIN
 DECLARE pRC INT;
 IF pTable like 'running' THEN
  select value from running where property like pProperty;
  SET pRC = FOUND_ROWS();
  IF pRC > 0 THEN
   update running set value = pValue where property like pProperty;
  ELSE
   insert into running (property,value) values (pProperty, pValue);
  END IF;
 ELSE
   select value from ConfigDU where property like pProperty;
  SET pRC = FOUND_ROWS();
  IF pRC > 0 THEN
   update ConfigDU set value = pValue where property like pProperty;
  ELSE
   insert into ConfigDU (property,value) values (pProperty, pValue);
  END IF;
 END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

-- Struktura tabulky `Access`
CREATE TABLE `Access` (
  `Id_Access` int(11) NOT NULL AUTO_INCREMENT,
  `Adresa` varchar(15) DEFAULT NULL,
  `Karta` varchar(20) DEFAULT NULL,
  `Ctecka` int(11) DEFAULT NULL,
  `Tlacitko` int(11) DEFAULT NULL,
  `Kdy` datetime NOT NULL,
  `StavZpracovani` int(11) NOT NULL,
  PRIMARY KEY (`Id_Access`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Struktura tabulky `ConfigDU`
CREATE TABLE `ConfigDU` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(30) NOT NULL,
  `value` varchar(50) NOT NULL,
  `regex` varchar(255) NOT NULL,
  `sample` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Konfigurace dverni jednotky';

-- Vypisuji data pro tabulku `ConfigDU`
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'mode', '1', '[0-2]+', '0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'dhcp', '1', '[0-1]+', '1');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'ip', '192.168.10.201', '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', '192.168.1.10');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'mask', '255.255.255.0', '^(255)\\.(0|128|192|224|240|248|252|254|255)\\.(0|128|192|224|240|248|252|254|255)\\.(0|128|192|224|240|248|252|254|255)', '255.255.255.0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'dg', '192.168.10.1', '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', '192.168.1.1');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'dns1', '8.8.8.8', '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', '8.8.8.8');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'ws', 'http://ws.meritaccess.cloud/Service.asmx', '^((http)|(https)|(rtp)|(rtsp)|(udp)):\\/\\/', 'http://ws.meritaccess.cloud/Service.asmx?WSDL');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'appupdate', 'meritaccess/merit_access', '.*', 'http://http://update.meritaccess.cloud');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'enablewifi', '0', '[0-1]+', '0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'ssid', 'myssid', '.*?', 'myTest');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'wifiuser', 'pepa', '.*?', 'Pepa');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'wifipass', 'pepapass', '.*?', 'pepapass');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'mqttenabled', '0', '[0-1]+', '0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'mqttserver', '192.168.10.1', '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$', '192.168.1.1');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'mqtttopic', '/ma/', '.*?', '/ma/');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'easy_add', '1', '[0-1]+', '0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'easy_remove', '1', '[0-1]+', '0');
INSERT INTO `ConfigDU` ( `property`, `value`, `regex`, `sample`) VALUES( 'update_mode', '0', '[0-2]+', '0');

-- --------------------------------------------------------

-- Struktura tabulky `Karty`
CREATE TABLE `Karty` (
  `cardid` int(11) NOT NULL AUTO_INCREMENT,
  `Karta` varchar(20) NOT NULL,
  `Ctecka` int(11) NOT NULL,
  `CasPlan` int(11) NOT NULL,
  `Povoleni` tinyint(1) NOT NULL,
  `Smazano` tinyint(1) NOT NULL,
  `Pozn` varchar(50) NOT NULL,
  PRIMARY KEY (`cardid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Struktura tabulky `logs`
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `severity` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Struktura tabulky `running`
CREATE TABLE `running` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastchange` timestamp NOT NULL DEFAULT current_timestamp(),
  `property` varchar(20) NOT NULL,
  `value` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Vypisuji data pro tabulku `running`
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2023-09-29 18:36:58', 'MyID', 'MDUD83ADD06DB00');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2023-09-29 18:52:40', 'LastStart', '2024-06-26 14:17:38.964259');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-10 16:59:44', 'Version', 'v1.0.4');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-10 16:59:44', 'MyIP', '192.168.10.201');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-10 16:59:44', 'restart', '0');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-20 08:34:35', 'R1ReadCount', '0');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-20 08:34:35', 'R1ReadError', '0');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-20 08:34:35', 'R2ReadCount', '0');
INSERT INTO `running` (`lastchange`, `property`, `value`) VALUES('2024-06-20 08:34:35', 'R2ReadError', '0');

-- --------------------------------------------------------

-- Struktura tabulky `tempKarty`
CREATE TABLE `tempKarty` (
  `cardid` int(11) NOT NULL AUTO_INCREMENT,
  `Karta` varchar(20) NOT NULL,
  `Ctecka` int(11) NOT NULL,
  `CasPlan` int(11) NOT NULL,
  `Povoleni` tinyint(1) NOT NULL,
  `Smazano` tinyint(1) NOT NULL,
  `Pozn` varchar(50) NOT NULL,
  PRIMARY KEY (`cardid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Struktura tabulky `users`
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `LogonName` varchar(20) NOT NULL,
  `MD5` varchar(50) NOT NULL,
  `rights` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Vypisuji data pro tabulku `users`
INSERT INTO `users` (`LogonName`, `MD5`, `rights`) VALUES('admin', '9df3b01c60df20d13843841ff0d4482c', 255);
INSERT INTO `users` (`LogonName`, `MD5`, `rights`) VALUES('bantj', '779af759f5e5847ade9f49d6edf757b5', 255);

-- --------------------------------------------------------
CREATE ALGORITHM=UNDEFINED DEFINER=`ma`@`localhost` SQL SECURITY DEFINER VIEW `AccessDetails`  AS SELECT `Access`.`Kdy` AS `Kdy`, `Access`.`Karta` AS `Karta`, `Access`.`Ctecka` AS `Ctecka`, `Access`.`StavZpracovani` AS `StavZpracovani`, `Karty`.`Pozn` AS `Pozn`, `Karty`.`Povoleni` AS `Povoleni`, `Karty`.`Smazano` AS `Smazano`, `Karty`.`cardid` AS `cardid` FROM (`Access` left join `Karty` on(rtrim(`Access`.`Karta`) = rtrim(`Karty`.`Karta`))) ;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
