# Build instructions for Docker container

From this directory, run the command:

```bash
docker build -t clus20_django:latest -f Dockerfile ..
```

For this container to function smoothly with the PgSQL container,
you should deploy a Docker network in order to facilitate easy
DNS handling:

```bash
docker network create --driver=bridge --subnet=192.168.254.0/24 \
                      --gateway=192.168.254.254 --attachable demo0
```

Once the Docker network has been created, you'll want to prepare and
launch the PgSQL to be prepared for consumption by Django:

```bash
mkdir ${REPO_BASE_DIR}/pgsql
docker run -d --name clus20_pgsql -p 5432:5432 --network demo0 \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=clus20_database -e PGDATA=/var/lib/postgresql/data \
    -v ${REPO_BASE_DIR}/pgsql:/var/lib/postgresql/data \
    postgres
```

Alternatively, you could leverage MySQL database as an alternative:

```bash
mkdir -p ${REPO_BASE_DIR}/mysql
docker run -d --name clus20_mysql -p 3306:3306 --network demo0 \
    -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql \
    -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=clus20_database \
    -v ${REPO_BASE_DIR}/mysql:/var/lib/mysql \
    mysql
```

With all the components in place, we can launch our demo application:

```bash
docker run -d --name clus20_django -p 8080:80 --network demo0 \
    clus20_django:latest
```
