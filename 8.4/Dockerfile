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

ENV LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
        --no-install-recommends \
        software-properties-common \
        apt-utils

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y \
        wget

RUN export DEBIAN_FRONTEND=noninteractive \
 && echo "deb [trusted=yes] http://repo.mysql.com/apt/debian/ bookworm mysql-8.4-lts" > /etc/apt/sources.list.d/mysql.list \
 && apt-get update

RUN mkdir -p /build/image
WORKDIR /build
RUN apt-get download \
        libaio1 \
        libnuma1 \
        libmysqlclient24 \
        mysql-common \
        mysql-client \
        mysql-community-client \
        mysql-community-client-core \
        mysql-community-server \
        mysql-community-server-core
RUN for file in *.deb; do dpkg-deb -x ${file} image/; done

WORKDIR /build/image
RUN rm -rf \
        etc/apparmor.d \
        etc/init \
        etc/init.d \
        etc/logcheck \
        etc/logrotate.d \
        etc/mysql/* \
        etc/terminfo/README \
        lib/systemd \
        usr/bin/innotop \
        usr/bin/mysqld_multi \
        usr/bin/dh_perl_dbi \
        usr/bin/mysqldumpslow \
        usr/lib/tempfiles.d \
        usr/share/apport \
        usr/share/doc \
        usr/share/gcc-5 \
        usr/share/gdb \
        usr/share/lintian \
        usr/share/libdbi-perl \
        usr/share/man \
        usr/share/mysql-8.4/docs \
        usr/share/mysql-8.4/*.sql \
        usr/share/mysql-8.4/*.txt \
        usr/share/mysql-8.4/echo_stderr \
        usr/share/mysql-8.4/magic \
        usr/share/mysql-8.4/mysql-helpers \
        usr/share/mysql-8.4/mysql-log-rotate \
        usr/share/mysql-8.4/mysql-systemd-start \
        usr/share/mysql-8.4/mysqld_multi.server \
        usr/share/mysql-common \
        usr/share/perl5 && \
    mkdir -p \
        etc/mysql/conf.d \
        run/mysqld \
        var/lib/mysql \
        var/lib/mysql-files && \
    chmod 0770 var/lib/mysql-files

COPY --from=base /etc/group /etc/gshadow /etc/passwd /etc/shadow etc/
COPY my.cnf etc/mysql/
COPY conf.d/ etc/mysql/conf.d/
COPY init/ etc/init/
COPY init.sql usr/share/mysql/


FROM clover/common

WORKDIR /
COPY --from=build /build/image /

VOLUME ["/var/lib/mysql"]

EXPOSE 3306
