FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install nginx openssl vim netcat -y		\
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -new -newkey rsa:4096 -nodes	\
				-keyout /etc/nginx/ssl/cert.key		\
				-out /etc/nginx/ssl/cert.crt		\
				-sha256 -days 365					\
				-subj "/C=MA/ST=KH/L=KH/O=SELF/OU=IT/CN=iassil.42.fr"

COPY tools/nginx.conf /etc/nginx/conf.d/my.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]
