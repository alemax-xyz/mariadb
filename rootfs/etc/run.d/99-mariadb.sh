[ -f /var/lib/mysql/auto.cnf ] || suexec sudo -u "$PUSER" mariadbd --bootstrap --skip-grant-tables <<-EOF || exit $?
	CREATE DATABASE IF NOT EXISTS mysql;
	USE mysql;
	$(cat /usr/share/mariadb/mariadb_system_tables.sql)
	$(cat /usr/share/mariadb/mariadb_system_tables_data.sql)
	$(cat /usr/share/mariadb/mariadb_performance_tables.sql)
	$(cat /usr/share/mariadb/mariadb_sys_schema.sql)
	$(cat /usr/share/mariadb/maria_add_gis_sp_bootstrap.sql)
	$(cat /usr/share/mariadb/fill_help_tables.sql)
	$(cat /usr/share/mariadb/init.sql)
EOF

suexec sudo -u "$PUSER" mariadbd --skip-name-resolve &

