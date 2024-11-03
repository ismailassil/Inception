FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install mariadb-server -y

COPY mariadb_script.sh /
RUN chmod +x mariadb_script.sh

ENTRYPOINT [ "/mariadb_script.sh" ]
