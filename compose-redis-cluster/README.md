- 安装install

```shell
bash ./prepare.sh install
```

- 卸载(uninstall)

```shell
bash ./prepare.sh uninstall
```

- 集群信息检查(check)

```bash
bash ./prepare.sh check
```

- 压测

```shell
root@17d8736b4a10:/data# redis-benchmark -h 192.168.31.143 -p 7001 -n 10000000 -r 100000  -c 512 -t set -d  1024 --threads 32 --cluster
Cluster has 3 master nodes:

Master 0: b710fc9fbad917f02194f29682ebf6bac9ba4cd3 192.168.31.143:7003
Master 1: f46b887637aae252e2932b5d99e74de064453203 192.168.31.143:7002
Master 2: 8f028a1fdfb0af78486503ef9c2e33a567a60ddd 192.168.31.143:7001

SET: rps=7646.8 (overall: 8416.4) avg_msec=68.430 (overall: 60.757)
```

- 代码测试

```shell
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

	clusterSlots := func(ctx context.Context) ([]redis.ClusterSlot, error) {
		slots := []redis.ClusterSlot{
			// First node with 1 master and 1 slave.
			{
				Start: 0,
				End:   5460,
				Nodes: []redis.ClusterNode{{
					Addr: "192.168.31.143:7001", // master
				}, {
					Addr: "192.168.31.143:7005", // 1st slave
				}},
			},
			// Second node with 1 master and 1 slave.
			{
				Start: 5461,
				End:   10922,
				Nodes: []redis.ClusterNode{{
					Addr: "192.168.31.143:7002", // master
				}, {
					Addr: "192.168.31.143:7006", // 1st slave
				}},
			},
			{
				Start: 10923,
				End:   16383,
				Nodes: []redis.ClusterNode{{
					Addr: "192.168.31.143:7003", // master
				}, {
					Addr: "192.168.31.143:7004", // 1st slave
				}},
			},
		}
		return slots, nil
	}

	rdb := redis.NewClusterClient(&redis.ClusterOptions{
		ClusterSlots:  clusterSlots,
		RouteRandomly: true,
	})
	rdb.Ping(ctx)

	// ReloadState reloads cluster state. It calls ClusterSlots func
	// to get cluster slots information.
	rdb.ReloadState(ctx)

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