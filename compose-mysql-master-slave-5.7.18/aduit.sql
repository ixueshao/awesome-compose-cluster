INSTALL PLUGIN server_audit SONAME 'server_audit.so';
set global server_audit_logging=on;
set global server_audit_file_rotate_size=10000000;
set global server_audit_incl_users='root';