#!/bin/sh

test -f /var/lib/mysql/auto.cnf || mysqld --user="$PUSER" --initialize --init-file=/usr/share/mysql/init.sql

trap 'kill -TERM $PID; wait $PID' TERM INT TSTP QUIT
mysqld  --skip-mysqlx --skip-name-resolve --user="$PUSER" &
PID=$!
wait $PID
