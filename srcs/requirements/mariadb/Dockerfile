FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install mariadb-server netcat -y	\
	&& apt-get clean -y && apt-get autoremove -y

COPY tools/mariadb_script.sh /mariadb_script.sh
RUN chmod +x mariadb_script.sh

ENTRYPOINT [ "/mariadb_script.sh" ]
