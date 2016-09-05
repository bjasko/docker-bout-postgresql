# docker-postgresql
docker-postgresql za  F18_knowhow bazu 

# init
start.sh podesimo admin usera/pwd 
 > sudo -u postgres  /usr/bin/psql --command "CREATE USER admin  WITH SUPERUSER PASSWORD 'xxxxx';" 

Prilikom prvog pokretanja inicijalizira se postgresql cluster
Za reinicijalizaciju pobrišemo $VOLUME_BASE/$S_HOST.$S_DOMAIN/etc/postgresql/.alreadysetup

## Build 

docker build -t bjasko/f18-postgresql:latest  .


## RUN 
Podesimo IP, DNS, domenu itd 

./run_bout_postgresql.sh

## update baze

docker exec -it CT_NAME  /migrate_all.sh
