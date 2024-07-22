ALTER USER 'root'@'localhost' IDENTIFIED BY 'ComplexPassw0rd$';
flush privileges;
-- -- 安装服务审计插件
-- INSTALL PLUGIN server_audit SONAME 'server_audit.so';
-- set global server_audit_logging=on;
-- set global server_audit_file_rotate_size=10000000;
-- set global server_audit_incl_users='root';
--
-- -- 安装连接限制插件
-- install plugin CONNECTION_CONTROL soname 'connection_control.so';
-- install plugin CONNECTION_CONTROL_FAILED_LOGIN_ATTEMPTS soname 'connection_control.so';
-- set global connection_control_failed_connections_threshold=5;
-- set global connection_control_min_connection_delay=1000;
-- set global connection_control_max_connection_delay = 86400;

-- -- 安装密码审计插件
INSTALL PLUGIN validate_password SONAME 'validate_password.so';
set global validate_password_length = 12;
set global validate_password_policy=1;
set global validate_password_mixed_case_count=2;
set global validate_password_number_count=2;
set global validate_password_special_char_count=2;