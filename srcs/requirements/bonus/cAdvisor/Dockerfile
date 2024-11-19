FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y wget \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/google/cadvisor/releases/download/v0.47.2/cadvisor-v0.47.2-linux-amd64 \
	-O /usr/local/bin/cadvisor

RUN chmod +x /usr/local/bin/cadvisor

ENTRYPOINT [ "/usr/local/bin/cadvisor", "--port=7000" ]
