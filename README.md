## Mariadb docker image

MariaDB is a fast, stable and true multi-user, multi-threaded SQL database server.
This image is based on official mariadb packages for debian and is built on top of [clover/common](https://hub.docker.com/r/clover/common/).

### Exposed ports
| Port | Description
| ---- | -----------
| 3306 | TCP port _mariadb_ is listening on

### Enviroment variables

| Name | Default value | Description
| ---- | ------------- | -----------
| `PUID` | _not set_ | desired user id of the process owner
| `PGID` | _not set_ | desired group id of the process pwner (primary group of the `PUID` user)
| `PUSER` | _not set_ | desired `PUID` user name
| `PGROUP` | _not set_ | desired `PGID` group name
| `CHOWN` | _not set_ | space-separated list of directories to change ownership to `PUID`/`PGID` during container startup
| `CRON` | _not set_ (`0`) | will start _cron_ inside the container if set to `1`
| `TZ` / `TIMEZONE` | _not set_ (`UTC`) | desired container timezone

### Configuration files

| Location | Description
| -------- | -----------
| `/etc/mysql/mariadb.cnf/` | mani _mariadb_ configuration file
| `/etc/mysql/conf.d/` | _mariadb_ configuration directory, all files within will be included by `/etc/mysql/mariadb.cnf`

### Supported platforms

 * `linux/amd64`;
 * `linux/386`;
 * `linux/arm/v7`;
 * `linux/arm64/v8`;
 * `linux/ppc64le`;
 * `linux/s390x`;
