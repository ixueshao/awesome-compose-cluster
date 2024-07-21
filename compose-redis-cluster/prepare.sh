#！/bin/env bash


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

#安装集群
install(){
  printMsg "安装集群"
  echo "ANNOUNCE_IP=$1" > ./.env
  #安装redis
  docker-compose up -d
  returnExitMsg "安装集群"
}

#卸载集群
uninstall(){
  printMsg "卸载集群"
  #停止集群
  docker-compose down
  returnExitMsg "卸载集群"
}


#初始化集群
init(){
  printMsg "初始化集群"
  #初始化集群
  yes yes | docker exec -i redis1 redis-cli --cluster create \
    $1:7001 $1:7002 $1:7003 $1:7004 $1:7005 $1:7006 --cluster-replicas 1
  returnExitMsg "初始化集群"
}


#检查集群状态
check(){
  printMsg "检查集群状态"
  #检查集群状态
  docker exec -i redis1 redis-cli cluster info
  printMsg "检查集群槽位分布"
  docker exec -i redis1 redis-cli CLUSTER SLOTS
  printMsg "检查集群节点状态"
  docker exec -i redis1 redis-cli --cluster check redis1:6379
  returnExitMsg "检查集群状态"
}

#判断脚本的第一个参数是install还是uninstall, 为install则执行安装, 为uninstall则执行卸载
if [ $1 = "install" ]; then
  install $2
  init $2
  check
elif [ $1 = "uninstall" ]; then
  uninstall
elif [ $1 = "check" ]; then
  check
else
  echo "请输入正确的参数: install, uninstall, init, check"
fi