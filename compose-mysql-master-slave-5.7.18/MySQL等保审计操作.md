# MySQL等保相关的验证操作

```sql
SHOW VARIABLES LIKE "%password%";

INSTALL PLUGIN validate_password SONAME 'validate_password.so';

set global validate_password_length = 12;

create user 'binglijia'@'%' identified by 'Bsdf@5467672';

select user,host,password_expired,password_lifetime,password_last_changed,account_locked from mysql.user;

ALTER USER 'binglijia'@'%' PASSWORD EXPIRE INTERVAL 90 DAY;

SET GLOBAL default_password_lifetime = 90;

install plugin CONNECTION_CONTROL soname 'connection_control.so';

install plugin CONNECTION_CONTROL_FAILED_LOGIN_ATTEMPTS soname 'connection_control.so';

show variables like '%connection_control%';

set global connection_control_failed_connections_threshold=5;

set global connection_control_min_connection_delay=300000;

select VERSION();

SHOW GLOBAL VARIABLES LIKE '%plugin_dir%';

INSTALL PLUGIN server_audit SONAME 'server_audit.so';

show variables like '%audit%';

set global server_audit_logging=on;
set global server_audit_file_rotate_size=10000000;

set global server_audit_incl_users='root';
```