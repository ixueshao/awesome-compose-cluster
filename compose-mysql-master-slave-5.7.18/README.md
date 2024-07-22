## 启动

```shell
bash ./build.sh run
````

日志输出如下
```log
[+] Running 14/14
 ✔ mysql_master Pulled                                                                                                                                                                                                         21.0s 
 ✔ mysql_slave Pulled                                                                                                                                                                                                          21.0s 
   ✔ 9f0706ba7422 Pull complete                                                                                                                                                                                                10.0s 
   ✔ 2290e155d2d0 Pull complete                                                                                                                                                                                                10.0s 
   ✔ 547981b8269f Pull complete                                                                                                                                                                                                10.1s 
   ✔ 2c9d42ed2f48 Pull complete                                                                                                                                                                                                10.1s 
   ✔ 55e3122f1297 Pull complete                                                                                                                                                                                                11.1s 
   ✔ abc10bd84060 Pull complete                                                                                                                                                                                                11.1s 
   ✔ c0a5ce64f2b0 Pull complete                                                                                                                                                                                                11.2s 
   ✔ c4595eab8e90 Pull complete                                                                                                                                                                                                16.0s 
   ✔ 098988cead35 Pull complete                                                                                                                                                                                                16.0s 
   ✔ 300ca5fa5eea Pull complete                                                                                                                                                                                                16.1s 
   ✔ 43fdc4e3e690 Pull complete                                                                                                                                                                                                16.1s 
 ✔ mysql_slave2 Pulled                                                                                                                                                                                                         21.0s 
[+] Running 4/4
 ✔ Network mysql-cluster-5718_overlay  Created                                                                                                                                                                                  0.1s 
 ✔ Container mysql_master              Started                                                                                                                                                                                  1.5s 
 ✔ Container mysql_slave2              Started                                                                                                                                                                                  0.9s 
 ✔ Container mysql_slave               Started                                                                                                                                                                                  0.9s 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
等待 mysql_master 连接中,请稍候,每 5s 尝试连接一次,可能会重试多次,直到容器启动完毕......
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.200.1.2
                  Master_User: mydb_slave_user
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 600
               Relay_Log_File: mysql-relay-bin.000002
                Relay_Log_Pos: 320
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 600
              Relay_Log_Space: 527
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 11
                  Master_UUID: 75f5ba1b-4837-11ef-8545-02420ac80102
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.200.1.2
                  Master_User: mydb_slave_user
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 600
               Relay_Log_File: mysql-relay-bin.000002
                Relay_Log_Pos: 320
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 600
              Relay_Log_Space: 527
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 11
                  Master_UUID: 75f5ba1b-4837-11ef-8545-02420ac80102
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
 finish success !!! 

```

## 清理

```shell
bash ./build.sh clean
```

## 其他(等保场景)

```shell
bash ./build.sh enablePassPolicy #启用密码策略
```

```shell
bash ./build.sh enableConnectionControll #启用连接策略
```

```shell
bash ./build.sh audit #启用审计策略
```

```shell
bash ./build.sh cmd mysql_master password #在mysql_master容器中检查password类环境变量配置
```

你会在`data`目录下查看到对应的日志文件

- server_audit.log

```shell
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,10,QUERY,mysql,'START TRANSACTION',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,11,QUERY,mysql,'INSERT INTO time_zone (Use_leap_seconds) VALUES (\'N\')',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,12,QUERY,mysql,'SET @time_zone_id= LAST_INSERT_ID()',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,13,QUERY,mysql,'INSERT INTO time_zone_name (Name, Time_zone_id) VALUES (\'Africa/Abidjan\', @time_zone_id)',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,14,QUERY,mysql,'INSERT INTO time_zone_transition (Time_zone_id, Transition_time, Transition_type_id) VALUES\n (@time_zone_id, -1830383032, 1)',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,15,QUERY,mysql,'INSERT INTO time_zone_transition_type (Time_zone_id, Transition_type_id, Offset, Is_DST, Abbreviation) VALUES\n (@time_zone_id, 0, -968, 0, \'LMT\')\n,(@time_zone_id, 1, 0, 0, \'GMT\')',0
20240722 23:05:27,dcd0b1d4a5e2,root,localhost,4,16,QUERY,mysql,'INSERT INTO time_zone (Use_leap_seconds) VALUES (\'N\')',0
```
- server_error.log
- server_general.log
- server_slow.log
