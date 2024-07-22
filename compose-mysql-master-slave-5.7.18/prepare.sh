#!/bin/bash
#################### 变量定义 ####################
root_password="ComplexPassw0rd$" # 每台服务器的root密码
mysql_user="mydb_slave_user"     # 主服务器允许从服务器登录的用户名
mysql_password=${root_password}  # 主服务器允许从服务器登录的密码

# 主库列表
master_container=mysql_master
# 从库列表
slave_containers=(mysql_slave mysql_slave2)
# 所有的数据库集群列表
all_containers=("$master_container" "${slave_containers[@]}")

# 链接重试间隔时间 s
retry_duration=5

#################### 函数定义 ####################
# 获取服务器的ip
getIp() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

cleanCluster(){
  docker-compose down
  rm -rf ./master/data/* ./slave/data/* ./slave2/data/*
}

runCluster(){
  #################### docker-compose初始化 ####################
  cleanCluster
  docker-compose build
  docker-compose up -d

  #################### 服务器初始化操作 ####################
  # 这个操作的目的是尝试连接服务器, 如果连接失败, 就等待4s后重试, 直到等待mysql服务器就绪, 并且连接上为止
  for container in "${all_containers[@]}";do
    until docker exec $container sh -c 'export MYSQL_PWD='$root_password'; mysql -u root -e ";"'
    do
        echo "等待 $container 连接中,请稍候,每 ${retry_duration}s 尝试连接一次,可能会重试多次,直到容器启动完毕......"
        sleep $retry_duration
    done
  done

  #################### 主服务器操作 ####################开始
  # 在主服务器上添加数据库用户
  priv_stmt='GRANT REPLICATION SLAVE ON *.* TO "'$mysql_user'"@"%" IDENTIFIED BY "'$mysql_password'"; FLUSH PRIVILEGES;'

  docker exec $master_container sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e '$priv_stmt'"

  # 查看主服务器的状态
  MS_STATUS=`docker exec $master_container sh -c 'export MYSQL_PWD='$root_password'; mysql -u root -e "SHOW MASTER STATUS"'`

  # binlog文件名字,对应 File 字段,值如: mysql-bin.000004
  CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
  # binlog位置,对应 Position 字段,值如: 1429
  CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`

  #################### 从服务器操作 ####################开始
  # 设置从服务器与主服务器互通命令
  start_slave_stmt="CHANGE MASTER TO
          MASTER_HOST='$(getIp $master_container)',
          MASTER_USER='$mysql_user',
          MASTER_PASSWORD='$mysql_password',
          MASTER_LOG_FILE='$CURRENT_LOG',
          MASTER_LOG_POS=$CURRENT_POS;"
  start_slave_cmd='export MYSQL_PWD='$root_password'; mysql -u root -e "'
  start_slave_cmd+="$start_slave_stmt"
  start_slave_cmd+='START SLAVE;"'

  # 执行从服务器与主服务器互通
  for slave in "${slave_containers[@]}";do
    # 从服务器连接主互通
    docker exec $slave sh -c "$start_slave_cmd"
    # 查看从服务器得状态
    docker exec $slave sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e 'SHOW SLAVE STATUS \G'"
  done

  echo -e "\033[42;34m finish success !!! \033[0m"
}

enablePassowrdPolicy(){
  for containter in mysql_master mysql_slave mysql_slave2
  do
    echo -e "\033[42;34m enabled $containter !!! \033[0m"
    docker exec -i $containter mysql -uroot -p${root_password} < ./passwordPolicy.sql
    docker exec -it $containter mysql -uroot -p${root_password} -e "SHOW VARIABLES LIKE '%password%';"
  done
}

enableConnectionControl(){
  for containter in mysql_master mysql_slave mysql_slave2
  do
    echo -e "\033[42;34m enabled $containter !!! \033[0m"
    docker exec -i $containter mysql -uroot -p${root_password} < ./connectionControll.sql
    docker exec -it $containter mysql -uroot -p${root_password} -e "SHOW VARIABLES LIKE '%connection%';"
  done
}

enableAduitControl(){
  for containter in mysql_master mysql_slave mysql_slave2
  do
    echo -e "\033[42;34m enabled $containter !!! \033[0m"
    docker exec -i $containter mysql -uroot -p${root_password} < ./aduit.sql
    docker exec -it $containter mysql -uroot -p${root_password} -e "show variables like '%audit%';"
  done
}

execCommand(){
  if [ $2 == "audit" ];then
    mysql_command="show variables like '%audit%';"
    docker exec -it $1 mysql -uroot -p${root_password} -e "${mysql_command}"
  elif [ $2 == "connection" ];then
    mysql_command="show variables like '%audit%';"
    docker exec -it $1 mysql -uroot -p${root_password} -e "${mysql_command}"
  elif [ $2 == "password" ];then
    mysql_command="show variables like '%password%';"
    docker exec -it $1 mysql -uroot -p${root_password} -e "${mysql_command}"
  elif [ $2 == "" ];then
    mysql_command="show slave status\G;"
    docker exec -it $1 mysql -uroot -p${root_password} -e "${mysql_command}"
  else
    echo """Usage:
  bash build.sh cmd $CONTAINER_NAME subCommand[audit|connection|password|]
example:
  bash build.sh cmd mysql_master password
  +---------------------------------------+-------+
  | Variable_name                         | Value |
  +---------------------------------------+-------+
  | default_password_lifetime             | 0     |
  | sha256_password_proxy_users           | OFF   |
  +---------------------------------------+-------+"""
  fi
}

funcUsage="""
  run: 先清理目录，然后一键运行集群
  clean: 清理目录
  enablePassPolicy: 启用密码策略
  enableConnectionControl: 启用连接控制策略
  enableAduitControl: 启用日志审计策略
  """


if [ $1 == "run" ];then
  runCluster
elif [ $1 == "clean" ];then
  cleanCluster
elif [ $1 == "enablePassPolicy" ];then
  enablePassowrdPolicy
elif [ $1 == "enableConnectionControll" ];then
  enableConnectionControl
elif [ $1 == "audit" ];then
  enableAduitControl
elif [ $1 == "cmd" ];then
  execCommand $2 $3
else
  echo "请提供功能选项: 目前支持${funcUsage}"
fi

