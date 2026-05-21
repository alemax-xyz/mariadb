#!/bin/sh

chown $PUID:$PGID \
	/var/lib/mysql \
	/var/lib/mysql-files \
	/var/run/mysqld || exit 2
