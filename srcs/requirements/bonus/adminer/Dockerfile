FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y curl vim netcat adminer \
	&& apt-get clean -y && apt-get autoremove -y

RUN mv /usr/share/adminer/adminer.php /usr/share/adminer/index.php

ENTRYPOINT [ "php", "-S", "0.0.0.0:8080", "-t", "/usr/share/adminer/" ]
