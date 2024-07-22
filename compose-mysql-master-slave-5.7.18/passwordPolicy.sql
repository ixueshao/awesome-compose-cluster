INSTALL PLUGIN validate_password SONAME 'validate_password.so';
set global validate_password_length = 12;
set global validate_password_policy=1;
set global validate_password_mixed_case_count=2;
set global validate_password_number_count=2;
set global validate_password_special_char_count=2;