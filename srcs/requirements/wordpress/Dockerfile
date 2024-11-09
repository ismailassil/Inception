FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& get-apt install -y	wget			\
							unzip			\
							curl			\
							php				\
							php8.1-fpm		\
							php-mysql		\
							mariadb-client	\
							&& apt-get clean -y && apt-get autoremove -y

RUN service restart php8.1-fpm

COPY tools/wordpress_script.sh /wordpress_script.sh

RUN chmod +x wordpress_script.sh

ENTRYPOINT [ "./wordpress_script.sh" ]