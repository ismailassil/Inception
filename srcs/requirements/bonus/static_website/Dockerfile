FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y php \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/index.html /portfolio/index.html
COPY ./tools/style.css /portfolio/style.css

ENTRYPOINT [ "php", "-S", "0.0.0.0:3000", "-t", "/portfolio/" ]
