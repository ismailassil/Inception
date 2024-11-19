FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y redis vim netcat curl procps \
	&& rm -rf /var/lib/apt/lists/*

COPY ./tools/redis_script.sh /redis_script.sh

RUN chmod +x /redis_script.sh

ENTRYPOINT [ "./redis_script.sh" ]
