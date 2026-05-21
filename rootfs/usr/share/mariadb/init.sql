UPDATE mysql.global_priv SET Host='%', Priv=JSON_SET(Priv, '$.plugin', 'mysql_native_password', '$.authentication_string', PASSWORD('root')) WHERE User='root' AND Host='localhost';
