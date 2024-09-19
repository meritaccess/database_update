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
    if rc > max_lines THEN
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
    END IF;
    
    SELECT COUNT(*) INTO rc FROM Access;
    if rc > max_lines THEN
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
      end if;      
END$$
DELIMITER ;

-- add config value ivar
INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'enable_ivar', 0, '^(?:[0-9]|[1-5][0-9]|6[0-3])$', '0 not used'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'enable_ivar'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'ivar_server', 'http://10.10.10.1', '.*', 'ipadress of ivar server'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'ivar_server'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'ivar_term_name1', 'term1', '.*', 'ipadress of ivar server'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'ivar_term_name1'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'ivar_term_name2', 'term2', '.*', 'ipadress of ivar server'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'ivar_term_name2'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'swap_wiegand_pins', '0', '[0-1]+', '0 - default state, 1 - use monitor and open for reader'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'swap_wiegand_pins'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'disable_web', '0', '[0-1]+', '0 - default, 1 - disable'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'disable_web'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'disable_ssh', '0', '[0-1]+', '0 - default, 1 - disable'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'disable_ssh'
);

INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'disable_ssh_password', '0', '[0-1]+', '0 - default, 1 - disable'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'disable_ssh_password'
);


CREATE TABLE IF NOT EXISTS tempCasovePlany ( Id_CasovyPlan INT AUTO_INCREMENT PRIMARY KEY, Cislo INT NOT NULL, Nazev VARCHAR(50) NOT NULL, Popis VARCHAR(50) NULL, RezimOtevirani VARCHAR(20) NOT NULL,
    Po_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Po_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ut_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ut_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    St_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', St_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ct_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ct_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Pa_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Pa_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    So_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', So_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Ne_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Ne_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', 
    Svatky_PrvniZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_PrvniKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_DruhyZacatek VARCHAR(8) NOT NULL DEFAULT '00:00:00', Svatky_DruhyKonec VARCHAR(8) NOT NULL DEFAULT '00:00:00' );


DROP PROCEDURE IF EXISTS ActivateTempCasovePlany;
DELIMITER $$
CREATE DEFINER=`ma`@`localhost`
PROCEDURE ActivateTempCasovePlany()
BEGIN
	START TRANSACTION;
	DELETE FROM CasovePlany;
	INSERT INTO CasovePlany SELECT * FROM tempCasovePlany;
  COMMIT;
END$$
DELIMITER ;


UPDATE ConfigDU 
SET value = 'meritaccess' 
WHERE property = 'appupdate' AND value = 'meritaccess/merit_access';

-- CREATE DEFINER=`ma`@`localhost` EVENT IF NOT EXISTS `clean_event` ON SCHEDULE EVERY 1 HOUR STARTS '2024-08-15 12:23:42' ON COMPLETION NOT PRESERVE ENABLE DO CALL cleandb()
-- add lines to /etc/mzsql/mariadb.cfg [mysqld]  event_scheduler = ON

DROP PROCEDURE IF EXISTS cleandb;
DROP EVENT IF EXISTS `clean_event`;

DELIMITER $$
CREATE DEFINER=ma@localhost PROCEDURE cleandb()
BEGIN
    DECLARE rc INT;
    DECLARE max_lines INT;
    set max_lines=2000;
    SELECT COUNT(*) INTO rc FROM MeritAccessLocal.logs;
    if rc > max_lines THEN
    	set rc=rc-max_lines;
    	select rc;
    	DELETE FROM MeritAccessLocal.logs
    	WHERE id IN (
        	SELECT id FROM (
            	SELECT id FROM MeritAccessLocal.logs
            	ORDER BY ts ASC
            	LIMIT rc
        	) AS subquery
    	);
    END IF;
    
    SELECT COUNT(*) INTO rc FROM MeritAccessLocal.Access;
    if rc > max_lines THEN
	    set rc=rc-max_lines;
   	 	select rc;
    	DELETE FROM MeritAccessLocal.Access
    		WHERE Id_Access IN (
        		SELECT Id_Access FROM (
            		SELECT Id_Access FROM MeritAccessLocal.Access	
            		ORDER BY Kdy ASC
            		LIMIT rc
        		) AS subquery
    		);
      end if;      
END$$
DELIMITER ;

CREATE DEFINER=ma@localhost EVENT clean_event ON SCHEDULE EVERY 1 DAY STARTS '2024-09-19 12:01:20' ON COMPLETION NOT PRESERVE ENABLE DO CALL MeritAccessLocal.cleandb()
