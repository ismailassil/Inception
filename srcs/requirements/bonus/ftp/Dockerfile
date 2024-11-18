FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y vsftpd \
	&& apt-get clean -y && apt-get autoremove

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/ftp_script.sh /ftp_script.sh

RUN chmod +x /ftp_script.sh

ENTRYPOINT [ "./ftp_script.sh" ]
