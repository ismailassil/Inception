ARG CLEAR="&& apt-get clean -y && apt-get autoremove -y"

FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install mariadb-server -y	\
	${CLEAR}

COPY tools/mariadb_script.sh /mariadb_script.sh
RUN chmod +x mariadb_script.sh

ENTRYPOINT [ "/mariadb_script.sh" ]
