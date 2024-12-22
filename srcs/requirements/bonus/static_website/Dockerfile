FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y python3 \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/index.html /portfolio/index.html
COPY ./tools/style.css /portfolio/style.css

ENTRYPOINT [ "python3", "-m", "http.server", "3000", "--directory", "/portfolio/" ]
