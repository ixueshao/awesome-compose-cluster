#!/usr/bin/env bash

#set -exu

HOST_IP_ADDRESS=$2

uninstall(){
  docker-compose down -v
  rm -rf ./sentinel
}

install(){
  source ./.env

  rm -rf ./sentinel || true

  #修改docker-compose.yaml中的announce-ip为待部署服务器的IP
  cp -R ./sentinel-example sentinel

  sed -i '' "s#CURRENT_HOST_IP_ADDRESS#${HOST_IP_ADDRESS}#g" sentinel/sentinel*

  docker-compose up -d
}

returnExitMsg(){
  if [ `echo $?` -eq 0 ]; then
    echo "$1:执行成功!"
  else
    echo "$1:执行失败!"
  fi
}

printMsg(){
  echo "$1: 开始执行..."
}

testSentinel(){
  printMsg "测试哨兵"
  for sentinel in redis-sentinel1 redis-sentinel2 redis-sentinel3
  do
    status=`docker exec -it $sentinel redis-cli -p 26379 ping 2>/dev/null`
    echo "$sentinel 测试ping结果为: $status"
  done

  printMsg "从哨兵获取redis主节点"
  for sentinel in redis-sentinel1 redis-sentinel2 redis-sentinel3
  do
    master_ip=`docker exec -i $sentinel redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster 2> /dev/null | awk 'NR==1'`
    master_port=`docker exec -i $sentinel redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster 2> /dev/null | awk 'NR==2'`
    echo -e "\033[34m${sentinel} 上获取到的redis主节点信息为: ${master_ip}:${master_port}\033[0m"
  done
}

testRedisMaster(){
  printMsg "测试主从"
  for redis in redis-master redis-slave1 redis-slave2
  do
    replicationStatus=`docker exec -i $redis redis-cli -p 6379 info replication`
    echo -e "\033[34m${redis}主从同步集群状态:${replicationStatus}\033[0m"
  done
}


#判断脚本的第一个参数是install还是uninstall, 为install则执行安装, 为uninstall则执行卸载
if [ $1 = "install" ]; then
  printMsg "安装"
  install
  sleep 10
  testRedisMaster
  testSentinel
  returnExitMsg "安装"
elif [ $1 = "uninstall" ]; then
  printMsg "卸载"
  uninstall
  returnExitMsg "卸载"
elif [ $1 == "check" ]; then
  testRedisMaster
  testSentinel
  testRedisMaster
else
  echo "请输入install或者uninstall"
fi