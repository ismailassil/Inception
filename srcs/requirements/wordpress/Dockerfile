FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y unzip curl php php7.4-fpm php-mysql mariadb-client \
	&& apt-get clean -y && apt-get autoremove -y

RUN service php7.4-fpm start

COPY tools/wordpress_script.sh /wordpress_script.sh

RUN chmod +x wordpress_script.sh

ENTRYPOINT [ "./wordpress_script.sh" ]