ARG CLEAR="&& apt-get clean -y && apt-get autoremove -y"

FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& get-apt install -y	wget			\
							unzip			\
							curl			\
							php				\
							php-fpm			\
							php-mysql		\
							php-xml			\
							php-curl		\
							php-mbstring	\
							php-zip			\
							php-gd			\
							php-soap		\
							php-intl		\
							php-json		\
							php-bcmath		\
							php-imagick		\
							php-xmlrpc		\
							php-opcache		\
							${CLEAR}

RUN service restart php-fpm

RUN wget https://wordpress.org/latest.zip -O /tmp/latest.zip && \
	unzip /tmp/latest.zip -d /var/www/ && \
	rm /tmp/latest.zip
