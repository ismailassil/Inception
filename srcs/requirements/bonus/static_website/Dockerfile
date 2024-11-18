FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y php \
	&& apt-get clean -y && apt-get autoremove -y

COPY ./tools/index.html /static_html/index.html
COPY ./tools/style.css /static_html/style.css

CMD [ "php", "-S", "0.0.0.0:3000", "-t", "/static_html/" ]
