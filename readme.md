file create.sql creates a complete database structure, should be called only when creating a new image  
file update.sql contains changes in db, called when changing the version  
version.txt  
1.0.7 add table CasovePlany, drop procedure SetVal and CanAccess, add SYSPLANREADER1, SYSPLANREADER2 values

2.0 add scheduler and clead_db procedure

2.1 add ivar_enabled, ivar_term_name1, ivar_term_name2, ivar_server into ConfigDU

2.2 add swap_wiegand_pins into ConfigDU

2.3 add disable_web, disable_ssh, disable_ssh_password into ConfigDU

2.4 add table tempCasovePlany, add procedure ActivateTempCasovePlany

2.5 change default appupdate value  from meritaccess/merit_access to meritaccess

