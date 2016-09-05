#!/bin/bash
# ver 0.2
# bjasko@bring.out.ba
# 19.05.2016


PGUSER=admin
PGPASSWORD=boutpgmin
PGHOST=localhost
SQLPATH=./F18_migrations/sql
MIGRATE=./migrate
GIT_URL=https://github.com/hernad/F18_migrations.git

export PGPASSWORD PGUSER

git clone https://github.com/hernad/F18_migrations.git

if [ -n "$1" ]
  then
    DB=$(psql -lt -h $PGHOST -U $PGUSER | egrep -v 'template[01]' | egrep -v 'postgres' | grep _ | grep $4 |awk '{print $1}')
  else
    DB=$(psql -lt -h $PGHOST -U $PGUSER | egrep -v 'template[01]' | egrep -v 'postgres' | grep _ | awk '{print $1}')
fi

# vrti update

for d in $DB
        do
        echo "Migracija baze $d u toku ..................."
        $MIGRATE  -url postgres://$PGUSER@$PGHOST:5432/$d?sslmode=disable -path $SQLPATH up
        $MIGRATE  -url postgres://$PGUSER@$PGHOST:5432/$d?sslmode=disable -path $SQLPATH version
        echo "Migracija baze $d je završena, idem dalje"
done

exit
