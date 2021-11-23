### Create database

```
  CREATE DATABASE umai_dev
```
### Take the schema dump

```
  psql -U <username> -d umai_dev -f dump.sql
```

### Run the server

```
thin -R config.ru -a 127.0.0.1 -p 8080 start
```

#### To start in test mode

```
thin -R config.ru -a 127.0.0.1 -e test -p 8080 start
```