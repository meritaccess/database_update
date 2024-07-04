-- add config value syslogserver
INSERT INTO `ConfigDU` (`property`, `value`, `regex`, `sample`)
SELECT 'syslogserver', '', '.*?', '192.168.10.201'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM `ConfigDU`
    WHERE `property` = 'syslogserver'
);
