#!/bin/bash
set -e
PG_MAJOR=9.5
POSTGRESQL_DATA=/var/lib/postgresql/$PG_MAJOR/main
POSTGRESQL_CONF=/etc/postgresql/$PG_MAJOR/main

appSetup () {

touch /etc/postgresql/.alreadysetup

if [ ! -d $POSTGRESQL_DATA ]; then
    mkdir -p $POSTGRESQL_DATA
    mkdir -p $POSTGRESQL_CONF
    chown -R postgres:postgres $POSTGRESQL_CONF
    chown -R postgres:postgres $POSTGRESQL_DATA
    pg_createcluster --start -e UTF-8 $PG_MAJOR main

    sudo -u postgres  /usr/bin/psql --command "CREATE USER admin  WITH SUPERUSER PASSWORD 'boutpgmin';"  
    sudo -u postgres  /usr/bin/psql --command "CREATE ROLE  xtrole NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"  
    echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
    echo "listen_addresses='*'" >> /etc/postgresql/$PG_MAJOR/main/postgresql.conf

    mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
fi
}

appStart () {
    [ -f /etc/postgresql/.alreadysetup ] && echo "Skipping setup..." || appSetup
    mkdir -p /var/run/postgresql/9.5-main.pg_stat_tmp && chown -R postgres  /var/run/postgresql/9.5-main.pg_stat_tmp  
    sudo -u  postgres /usr/lib/postgresql/$PG_MAJOR/bin/postgres  --config_file=/etc/postgresql/$PG_MAJOR/main/postgresql.conf
}

appHelp () {
	echo "Available options:"
	echo " app:start          - Starts all services needed for bout PSQL"
	echo " app:setup          - First time setup."
	echo " app:help           - Displays the help"
	echo " [command]          - Execute the specified linux command eg. /bin/bash."
}

case "$1" in
	app:start)
		appStart
		;;
	app:setup)
		appSetup
		;;
	app:help)
		appHelp
		;;
	*)
		if [ -x $1 ]; then
			$1
		else
			prog=$(which $1)
			if [ -n "${prog}" ] ; then
				shift 1
				$prog $@
			else
				appHelp
			fi
		fi
		;;
esac

exit 0
