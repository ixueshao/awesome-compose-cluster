# compose-redis-sentinel

## installation

1. 获取Redis要绑定本地的IP
2. 运行脚本

```shell
bash ./prepare.sh install $ip
```

## uninstall

```shell
bash ./prepare.sh uninstall
```

## check cluster

```shell
bash ./prepare.sh check
```

## 坑

1. 启动redis-sentinel，遇到无法解析主机名redis-master
```log
1:X 18 May 2024 04:54:08.938 # Failed to resolve hostname 'redis-master'
*** FATAL CONFIG FILE ERROR (Redis 7.2.4) ***
Reading the configuration file, at line 2
>>> 'sentinel monitor mymaster redis-master 6379 2'
Can't resolve instance hostname.
```
解决方法：
```shell
sentinel resolve-hostnames yes
```

2. redis-sentinel配置文件无法修改
```log
WARNING: Sentinel was not able to save the new configuration on disk!!!: Device or resource busy
```
解决方法：为了让redis有权修改配置，您必须挂载整个配置文件夹，而不是文件本身（并且文件夹内容应该是可写的）。将配置文件的目录挂载到容器中，而不是文件本身。


## 集群测试

```go
package main

import (
	"context"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"log"
	"net/http"
)

var (
	rdb       *redis.Client
	ctx       = context.Background()
	keyPrefix = "go-redis-demo:prefix:"
)

func main() {
	// Initialize Redis client
	rdb = redis.NewFailoverClient(&redis.FailoverOptions{
		MasterName:    "mymaster",
		SentinelAddrs: []string{"172.22.44.194:26379", "172.22.44.194:26380", "172.22.44.194:26381"},
	})

	// Initialize Gin engine
	r := gin.Default()

	// Set key-value pair in Redis
	r.POST("/set/:key/:value", func(c *gin.Context) {
		key := keyPrefix + c.Param("key") // Prefix keys with 'myapp:'
		value := c.Param("value")
		err := rdb.Set(ctx, key, value, 0).Err()
		if err != nil {
			log.Printf("Error setting key-value pair in Redis: %v\n", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		log.Printf("Key-value pair set successfully in Redis: %s = %s\n", key, value)
		c.JSON(http.StatusOK, gin.H{"message": "Key-value pair set successfully"})
	})

	// Get value of key from Redis
	r.GET("/get/:key", func(c *gin.Context) {
		key := keyPrefix + c.Param("key") // Prefix keys with 'myapp:'
		value, err := rdb.Get(ctx, key).Result()
		if err == redis.Nil {
			log.Printf("Key not found in Redis: %s\n", key)
			c.JSON(http.StatusNotFound, gin.H{"error": "Key not found"})
			return
		} else if err != nil {
			log.Printf("Error getting value from Redis: %v\n", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		log.Printf("Value retrieved from Redis: %s = %s\n", key, value)
		c.JSON(http.StatusOK, gin.H{"value": value})
	})

	// Start Gin server
	r.Run(":8080")
}
```

- 安装依赖包

```shell
go get github.com/gin-gonic/gin
go get github.com/go-redis/redis
go run main.go
```

- 新增key

```shell
curl --location --request POST 'http://localhost:8080/set/name/欢迎关注微信公众号：云原生生态圈' \
--header 'User-Agent: Apifox/1.0.0 (https://apifox.com)'
```

- 获取key 

```shell
curl --location --request GET 'http://localhost:8080/get/name' \
--header 'User-Agent: Apifox/1.0.0 (https://apifox.com)'
```