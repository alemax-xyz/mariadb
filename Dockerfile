FROM clover/base AS base

RUN groupadd \
        --gid 50 \
        --system \
        mysql \
 && useradd \
        --home-dir /var/lib/mysql \
        --no-create-home \
        --system \
        --shell /bin/false \
        --uid 50 \
        --gid 50 \
        mysql

FROM library/debian:stable-slim AS build

ENV LANG=C.UTF-8 \
    SANDBOX_ROOT=/

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y wget openssl ca-certificates

ADD https://github.com/alemax-xyz/misc-tools.git#main /usr/local/bin/

RUN mkdir -p /build /rootfs

WORKDIR /build

COPY build/ .

COPY --from=clover/common:latest /var/lib/packages/ var/lib/packages/

RUN apt-sandbox --install --verstamp \
        --apt-config \
            APT::Install-Recommends=false \
            APT::Get::Upgrade==false \
        --repository . \
        --keyring . \
        --installed var/lib/packages \
        --obsolete packages.obsolete \
        --required packages.required

WORKDIR /rootfs

RUN rm -rf \
        etc/apparmor.d \
        etc/init.d \
        etc/logcheck \
        etc/logrotate.d \
        etc/mysql \
        usr/bin/galera* \
        usr/bin/innotop \
        usr/bin/mariadb-access \
        usr/bin/mariadb-convert-table-format \
        usr/bin/mariadb-dumpslow \
        usr/bin/mariadb-find-rows \
        usr/bin/mariadb-fix-extensions \
        usr/bin/mariadb-hotcopy \
        usr/bin/mariadb-install-db \
        usr/bin/mariadb-report \
        usr/bin/mariadb-secure-installation \
        usr/bin/mariadb-service-convert \
        usr/bin/mariadb-setpermission \
        usr/bin/mariadbd-multi \
        usr/bin/mariadbd-safe \
        usr/bin/msql2mysql \
        usr/bin/mysql_install_db \
        usr/bin/mysqld_safe \
        usr/bin/mytop \
        usr/bin/wsrep* \
        usr/lib/systemd \
        usr/lib/tmpfiles.d \
        usr/share/apport \
        usr/share/doc \
        usr/share/lintian \
        usr/share/man \
        usr/share/mariadb/charsets/README \
        usr/share/mariadb/mariadb_test*.sql \
        usr/share/mariadb/*.sh \
        usr/share/mariadb/echo_stderr \
        usr/share/mariadb/mini-benchmark \
        usr/share/mariadb/wsrep* \
        usr/share/menu \
        usr/share/mysql-common \
        usr/share/perl* \
 && sed -i -r \
        -e 's,^[[:space:]]*[#;]+.*$,,g' \
        -e 's,[[:space:]]+, ,g' \
        -e '/^[[:space:]]*$/d' \
        etc/security/*.conf \
 && mkdir -p \
        run/mysqld \
        var/lib/mysql \
        var/lib/mysql-files \
 && chmod 0770 var/lib/mysql-files

COPY --from=base /etc/group /etc/gshadow /etc/passwd /etc/shadow etc/
COPY rootfs/ .

FROM clover/common

WORKDIR /

COPY --from=build /rootfs /

EXPOSE 3306
