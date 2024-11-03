FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY mariadb_script.sh /
RUN chmod +x mariadb_script.sh

ENTRYPOINT [ "bash", "/mariadb_script.sh" ]

# CMD ["mysqld_safe", "--datadir='/var/lib/mysql'"]
