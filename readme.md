file create.sql creates a complete database structure, should be called only when creating a new image  
file update.sql contains changes in db, called when changing the version  
version.txt  
1.0.7 add table CasovePlany, drop procedure SetVal and CanAccess, add SYSPLANREADER1, SYSPLANREADER2 values
2.0 add scheduler and clead_db procedure
2.1 add ivar_enabled, ivar_term_name1, ivar_term_name2, ivar_server into ConfigDU
