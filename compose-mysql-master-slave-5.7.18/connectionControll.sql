install plugin CONNECTION_CONTROL soname 'connection_control.so';
install plugin CONNECTION_CONTROL_FAILED_LOGIN_ATTEMPTS soname 'connection_control.so';
set global connection_control_failed_connections_threshold=5;
set global connection_control_min_connection_delay=1000;
set global connection_control_max_connection_delay = 86400;