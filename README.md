
# CS Notbank service

 Единый сервис небанковских услуг (ЕСНУ)

## Использование

```
# cp .env.dist .env && vi .env
# cp .appenv.dist .appenv && vi .appenv

# docker-compose -f docker-compose.yml -f development.yml up -d
# docker exec -ti --user apache cs.notbank-service_api_1 composer install
$ curl localhost:8083
```
