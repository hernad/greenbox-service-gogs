# Create docker volume.

if ! docker volume ls | grep -q gogs-data
then
    docker volume create --name gogs-data
else
    echo "docker volume gogs-data already exists"
fi

docker rm -f gogs
docker rm -f gogs_postgres

# ovaj vazda brise bazu?!
docker_postgresql_brise() {

docker run -d \
   --name gogs_postgres \
   -e POSTGRES_DB=gogs \
   -e POSTGRES_USER=gogs \
   -e POSTGRES_PASSWORD=test01 \
   -v $(pwd)/var_lib_postgres:/var/lib/postgres \
   postgres:9.6.2-alpine
}


docker run --name=gogs_postgres -d \
    --env='DB_NAME=gogs' \
    --env='DB_USER=gogs' --env='DB_PASS=test01' \
    --volume=$(pwd)/var_lib_postgresql:/var/lib/postgresql \
    sameersbn/postgresql:9.6-2


docker run -d \
	--name=gogs \
	-p 10022:22 -p 10080:3000 \
	-v gogs-data:/data  \
	-v gogs-etc:/etc \
	--link gogs_postgres:pg \
        gogs/gogs:0.11.4

docker cp app.ini gogs:/data/gogs/conf/app.ini


