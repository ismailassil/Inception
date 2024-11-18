FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y wget \
	&& apt-get clean -y && apt-get autoremove -y

RUN wget https://github.com/google/cadvisor/releases/download/v0.47.2/cadvisor-v0.47.2-linux-amd64 -O /usr/local/bin/cadvisor

RUN chmod +x /usr/local/bin/cadvisor

CMD ["/usr/local/bin/cadvisor", "--port=7000", "--docker_only=true"]