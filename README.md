# Suse Academic Introduction to containers

## Playing with CLI

- Check you have installed docker or podman:

```bash
podman run hello-world
```

```bash
docker run hello-world
```

- Run a container:

```bash
podman run -d --name mynginx nginx
```

```bash
docker run -d --name mynginx nginx
```

- List the containers running:

```bash
podman ps
```

```bash
docker ps
```

- Enter a running container:

```bash
podman exec -ti mynginx bash
```

```bash
docker exec -ti mynginx bash
```

- Check a container's logs:

```bash
podman logs mynginx
```

```bash
docker logs mynginx
```

- Inspect a container's data:

```bash
podman inspect mynginx
```

```bash
docker inspect mynginx
```

- Check a container's running processes:

```bash
podman top mynginx
```

```bash
docker top mynginx
```

- Check container's resources consumption:

```bash
podman stats mynginx
```

```bash
docker stats mynginx
```

- Pause a running container:

```bash
podman pause mynginx
```

```bash
docker pause mynginx
```

- Unpause a container:

```bash
podman unpause mynginx
```

```bash
docker unpause mynginx
```

- Stop a container:

```bash
podman stop mynginx
```

```bash
docker stop mynginx
```

- Start a container:

```bash
podman start mynginx
```

```bash
docker start mynginx
```

- kill a container:

```bash
podman kill mynginx
```

```bash
docker kill mynginx
```

- delete a container:

```bash
podman delete mynginx
```

```bash
docker delete mynginx
```

## Let’s explore a bit the filesystem

- Remove all containers:

```bash
podman rm -f $(podman ps -aq)
```

```bash
docker rm -f $(docker ps -aq)
```

- Get a alpine image:

```bash
podman pull alpine
```

```bash
docker pull alpine
```

- Check layers of a image:

```bash
podman history alpine
```

```bash
docker history alpine
```

- Lunch a alpine and attach to it:

```bash
podman run --name mytest --ti alpine bash
```

```bash
docker run --name mytest --ti alpine bash
```

Inside the container (mytest):

```bash
echo "Hi" > myfile
rm /etc/localtime
```

Check the diff

```bash
podman diff mytest
```

```bash
docker diff mytest
```

Create a new image with the changes:

```bash
podman commit mytest academy/mytest:r0
```

```bash
docker commit mytest academy/mytest:r0
```

Check the history of the new image:

```bash
podman history academy/mytest:r0
```

```bash
docker history academy/mytest:r0
```

Export a image:

```bash
podman save academy/mytest:ro -o /tmp/image.tar
```

```bash
docker save academy/mytest:ro -o /tmp/image.tar
```

## Image registry:

```bash
podman search wordpress
```

```bash
docker search wordpress
```

```bash
podman search wordpress --list-tags
```

## Configuring containers

```bash
podman run --name mymaria -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" docker.io/library/mariadb
```

```bash
docker run --name mymaria -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" mariadb
```

## Using Networks

```bash
podman run --name client --rm -ti docker.io/library/mysql:latest bash
```

```bash
docker run --name client --rm -ti mysql bash
```

In the console of the container:

```bash
mysql -h "mymaria" -u"foo" -p"bar1234" "academy"
```

You can't access so let's use a networks:

```bash
podman network create testnetwork
podman network inspect testnetwork
```

```bash
docker network create testnetwork
docker network inspect testnetwork
```

Now try to access again:

```bash
podman run --name mymaria --hostname mymaria --network testnetwork -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" mariadb

podman run --name client --network testnetwork -ti --rm docker.io/library/mysql:latest bash
```

```bash
docker run --name mymaria --hostname mymaria --network testnetwork -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" mariadb

docker run --name client --network testnetwork --rm -ti mysql bash
```

```bash
mysql -h "mymaria" -u"foo" -p"bar1234" "academy"
```

## Port publishing

```bash
podman ps -a
podman stop mymaria && docker rm mymaria
```

```bash
podman run --name mymaria -p 3306:3306 --hostname mymaria --network testnetwork -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" mariadb
```

```bash
docker ps -a
docker stop mymaria && docker rm mymaria
```

```bash
docker run --name mymaria -p 3306:3306 --hostname mymaria --network testnetwork -d -e MARIADB_ROOT_PASSWORD="pa$$w0rd" -e MARIADB_USER="foo" -e MARIADB_PASSWORD="bar1234" -e MARIADB_DATABASE="academy" mariadb
```

## Working with volumes

```bash
podman volume create myvol
podman volume inspect myvol
```

```bash
podman run --name cont1 -v myvol:/mnt/volume -ti alpine
podman run --name cont2 -v myvol:/mnt/volume -ti alpine
```

```bash
docker volume create myvol
docker volume inspect myvol
```

```bash
docker run --name cont1 -v myvol:/mnt/volume -ti alpine
docker run --name cont2 -v myvol:/mnt/volume -ti alpine
```

## MariaDB with persistence

```bash
podman stop $(podman ps -aq) && podman rm $(podman ps -aq)
```

```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
```

Create a new volume

```bash
podman volume create mariadb-data
```

```bash
docker volume create mariadb-data
```

Deploy a new container with the volume

```bash
podman run -d -p 3306:3306 --name mymaria \
  --hostname mymaria \
  --network testnetwork \
  -e MARIADB_ROOT_PASSWORD="pa$$w0rd" \
  -e MARIADB_USER="foo" \
  -e MARIADB_PASSWORD="bar123" \
  -e MARIADB_DATABASE="academy" \
  -v mariadb_data:/var/lib/mysql mariadb
```

```bash
docker run -d -p 3306:3306 --name mymaria \
  --hostname mymaria \
  --network testnetwork \
  -e MARIADB_ROOT_PASSWORD="pa$$w0rd" \
  -e MARIADB_USER="foo" \
  -e MARIADB_PASSWORD="bar123" \
  -e MARIADB_DATABASE="academy" \
  -v mariadb_data:/var/lib/mysql mariadb
```

You can specify a path in your host:

```bash
podman run -d -p 3306:3306 --name maria2 \
  --hostname mymaria \
  --network testnetwork \
  -e MARIADB_ROOT_PASSWORD="pa$$w0rd" \
  -e MARIADB_USER="foo" \
  -e MARIADB_PASSWORD="bar1234" \
  -e MARIADB_DATABASE="academy" \
  -v /tmp/mypath:/var/lib/mysql mariadb
```

```bash
docker run -d -p 3306:3306 --name maria2 \
  --hostname mymaria \
  --network testnetwork \
  -e MARIADB_ROOT_PASSWORD="pa$$w0rd" \
  -e MARIADB_USER="foo" \
  -e MARIADB_PASSWORD="bar1234" \
  -e MARIADB_DATABASE="academy" \
  -v /tmp/mypath:/var/lib/mysql mariadb
```

## Dockerfile

```bash
podman build -t academy/test:latest .
podman run -d --name test  -p 8080:80 academy/test:latest
```

```bash
docker build -t academy/test:latest .
docker run -d --name test  -p 8080:80 academy/test:latest
```

## Tips for not running out of space

```bash
podman container prune
podman image prune
podman volume prune
podman system prune
```

```bash
docker container prune
docker image prune
docker volume prune
docker system prune
```

## Docker Compose

```bash
docker run -d --name mymongo mongo
```

```yaml
version: '3'
services:
  mongodb:
    image: mongo
    container_name: mymongo
```

```bash
docker compose up -d
```

```bash
docker compose down
```

```bash
docker compose -f docker-compose-mariadb.yaml up -d
```

Testing docker-compose:

```bash
mariadb -h "mariadb" -u"foo" -p"bar1234" "academy"
```

### Some docker compose commands

```bash
docker compose ps
docker compose stop client
docker compose run client bash
docker compose run --no-deps client bash
docker compose logs
docker compose down --volumes
```
