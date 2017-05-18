# /bin/bash!
# ENV
BCKP_DIR=/backup/postgresql
PGHOST=localhost
B_CURR_Y=`date "+%Y"`
DATE=`date +%Y_%m_%d`
PGUSER=admin
PGPASSWORD=boutpgmin

# DB list all
db_list () {
  DB=$(psql -lt -h $PGHOST  -U $PGUSER | egrep -v 'template[01]' | egrep -v 'postgres' | grep _  | egrep -v 'test' | awk '{print $1}')
}

# DB list all
db_list_curr () {
  DBC=$(psql -lt -h $PGHOST -U $PGUSER | egrep -v 'template[01]' | egrep -v 'postgres' | grep _ | egrep -v 'test' | grep $B_CURR_Y | awk '{print $1}')
}

backup_curr () {
  for d in $DBC
           do
           cd $BCKP_DIR/$DATE
           pg_dump -Fc -h $PGHOST -U $PGUSER $d  > $d.backup
           done
}

backup_all () {
  for d in $DB
           do
           cd $BCKP_DIR/$DATE
           pg_dump -Fc -h $PGHOST -U $PGUSER $d  > $d.backup
           done
}

backup_server (){
  cd $BCKP_DIR/$DATE
  pg_dumpall -h $PGHOST -U $PGUSER | gzip -c > server.all.sql.gz
}

vacuum () {
  cd $BCKP_DIR/$DATE 
  ls -t | tail -n +30 | xargs -I {} rm {}
}

# create BCKP_DIR
if [[ ! -e $BCKP_DIR/$DATE ]]; then
    mkdir -p $BCKP_DIR/$DATE
fi

# run backup
if [ "$1" == curr ];then
    db_list_curr
    backup_curr
#    vacuum
elif [ "$1" == all ];then
    db_list
    backup_all
#    vacuum
elif  [ "$1" == server ];then
    backup_server
fi
exit
