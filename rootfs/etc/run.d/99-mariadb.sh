[ -f /var/lib/mysql/multi-master.info ] || suexec sudo -E -u "$PUSER" mariadbd --bootstrap --skip-grant-tables <<-EOF || exit $?
	CREATE DATABASE IF NOT EXISTS mysql;
	USE mysql;
	$(cat \
		/usr/share/mariadb/mariadb_system_tables.sql \
		/usr/share/mariadb/mariadb_system_tables_data.sql \
		/usr/share/mariadb/mariadb_performance_tables.sql \
		/usr/share/mariadb/mariadb_sys_schema.sql \
		/usr/share/mariadb/maria_add_gis_sp_bootstrap.sql \
		/usr/share/mariadb/fill_help_tables.sql \
		/usr/share/mariadb/init.sql \
	)
EOF

suexec sudo -E -u "$PUSER" mariadbd --skip-name-resolve &

