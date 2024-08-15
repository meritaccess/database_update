-- add config value syslogserver
INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'syslogserver', '', '.*?', '192.168.10.201'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'syslogserver'
);

CREATE TABLE IF NOT EXISTS CasovePlany ( Id_CasovyPlan INT AUTO_INCREMENT PRIMARY KEY, Cislo INT NOT NULL, Nazev VARCHAR(50) NOT NULL, Popis VARCHAR(50) NULL, RezimOtevirani VARCHAR(20) NOT NULL,
    Po_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ut_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    St_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ct_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Pa_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    So_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ne_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Svatky_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00' );

DROP PROCEDURE IF EXISTS SetVal;
DROP PROCEDURE IF EXISTS CanAccess;

-- add config value SYSPLANREADER1
INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'SYSPLANREADER1', '0', '^(?:[0-9]|[1-5][0-9]|6[0-3])$', '0=noplan'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'SYSPLANREADER1'
);
-- add config value SYSPLANREADER2
INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'SYSPLANREADER2', '0', '^(?:[0-9]|[1-5][0-9]|6[0-3])$', '0=noplan'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'SYSPLANREADER2'
);
-- DELETE FROM running WHERE property = 'R1ReadCount';
-- DELETE FROM running WHERE property = 'R2ReadCount';
-- DELETE FROM running WHERE property = 'R1ReadError';
-- DELETE FROM running WHERE property = 'R2ReadError';

CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`ma`@`localhost` SQL SECURITY DEFINER VIEW `AccessDetails`  AS SELECT `Access`.`Kdy` AS `Kdy`, `Access`.`Karta` AS `Karta`, `Access`.`Ctecka` AS `Ctecka`, `Access`.`StavZpracovani` AS `StavZpracovani`, `Karty`.`Pozn` AS `Pozn`, `Karty`.`Povoleni` AS `Povoleni`, `Karty`.`Smazano` AS `Smazano`, `Karty`.`cardid` AS `cardid` FROM (`Access` left join `Karty` on(rtrim(`Access`.`Karta`) = rtrim(`Karty`.`Karta`))) ;
DROP PROCEDURE IF EXISTS cleandb;
DELIMITER $$
CREATE DEFINER=`ma`@`localhost` PROCEDURE `cleandb`()
BEGIN
    DECLARE rc INT;
    DECLARE max_lines INT;
    set max_lines=2000;
    SELECT COUNT(*) INTO rc FROM logs;
    set rc=rc-max_lines;
    select rc;
    DELETE FROM logs
    WHERE id IN (
        SELECT id FROM (
            SELECT id FROM logs
            ORDER BY ts ASC
            LIMIT rc
        ) AS subquery
    );

    SELECT COUNT(*) INTO rc FROM Access;
    set rc=rc-max_lines;
    select rc;
    DELETE FROM Access
    WHERE Id_Access IN (
        SELECT Id_Access FROM (
            SELECT Id_Access FROM Access
            ORDER BY Kdy ASC
            LIMIT rc
        ) AS subquery
    );        
END$$
DELIMITER ;
CREATE DEFINER=`ma`@`localhost` EVENT `clean_event` ON SCHEDULE EVERY 1 HOUR STARTS '2024-08-15 12:23:42' ON COMPLETION NOT PRESERVE ENABLE DO CALL clean()
-- add lines to /etc/mzsql/mariadb.cfg [mysqld]  event_scheduler = ON
