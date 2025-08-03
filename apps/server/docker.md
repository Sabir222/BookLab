docker run --name booklab_redis_db \
 -p 6379:6379 \
 redis redis-server --requirepass redispw
