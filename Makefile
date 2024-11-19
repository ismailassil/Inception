DB_DIR_PATH	= "/home/${USER}/data/mariadb"
WP_DIR_PATH	= "/home/${USER}/data/wordpress"
RD_DIR_PATH	= "/home/${USER}/data/redis"
DCK_PATH	= "./srcs/docker-compose.yml"

DB_SRV		= mariadb
WP_SRV		= wordpress
NG_SRV		= nginx
RD_SRV		= redis
FT_SRV		= ftp
AD_SRV		= adminer
CA_SRV		= cadvisor
ST_SRV		= static_website

all: help

up: clean build
	@docker compose -f $(DCK_PATH) -p inception up

down:
	@docker compose -f $(DCK_PATH) down

build: mkdir
	@docker compose -f $(DCK_PATH) build

ps:
	@docker compose -f $(DCK_PATH) ps

start:
	@docker compose -f $(DCK_PATH) start $(docker compose -f $(DCK_PATH) config --services)

stop:
	@docker compose -f $(DCK_PATH) stop $(docker compose -f $(DCK_PATH) config --services)

mariadb:
	@docker container exec -it `docker ps -q -f "name=$(DB_SRV)"` bash

nginx:
	@docker container exec -it `docker ps -q -f "name=$(NG_SRV)"` bash

wordpress:
	@docker container exec -it `docker ps -q -f "name=$(WP_SRV)"` bash

redis:
	@docker container exec -it `docker ps -q -f "name=$(RD_SRV)"` bash

adminer:
	@docker container exec -it `docker ps -q -f "name=$(AD_SRV)"` bash

ftp:
	@docker container exec -it `docker ps -q -f "name=$(FT_SRV)"` bash

cadvisor:
	@docker container exec -it `docker ps -q -f "name=$(CA_SRV)"` bash

website:
	@docker container exec -it `docker ps -q -f "name=$(ST_SRV)"` bash

mkdir:
	@mkdir -p $(DB_DIR_PATH) $(WP_DIR_PATH) $(RD_DIR_PATH)

clean:
	@docker stop `docker ps -qa` >/dev/null 2>&1 || true
	@docker rm `docker ps -qa` -f  >/dev/null 2>&1 || true
	@docker rmi -f `docker images -qa`  >/dev/null 2>&1 || true
	@docker volume rm `docker volume ls -q` -f  >/dev/null 2>&1 || true
	@docker network rm `docker network ls -q`  >/dev/null 2>&1 || true
	@sudo rm -rf $(DB_DIR_PATH) $(WP_DIR_PATH) $(RD_DIR_PATH)
	@echo "$(YELLOW)[ ✓ ] Cleanup process complete!$(RESET)"

prune: clean
	@docker system prune --all --volumes --force >/dev/null 2>&1
	@echo "$(YELLOW)[ ✓ ] System prune complete!$(RESET)"

help:
	@echo ""
	@echo ""
	@echo "$(PURPLE)\t ██▓ ███▄    █  ▄████▄  ▓█████  ██▓███  ▄▄▄█████▓ ██▓ ▒█████   ███▄    █ $(END)"
	@echo "$(PURPLE)\t▓██▒ ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ ▓██░  ██▒▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █ $(END)"
	@echo "$(PURPLE)\t▒██▒▓██  ▀█ ██▒▒▓█    ▄ ▒███   ▓██░ ██▓▒▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒$(END)"
	@echo "$(PURPLE)\t░██░▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ ▒██▄█▓▒ ▒░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒$(END)"
	@echo "$(PURPLE)\t░██░▒██░   ▓██░▒ ▓███▀ ░░▒████▒▒██▒ ░  ░  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░$(END)"
	@echo "$(PURPLE)\t░▓  ░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░▒▓▒░ ░  ░  ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ $(END)"
	@echo "$(PURPLE)\t ▒ ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░░▒ ░         ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░$(END)"
	@echo "$(PURPLE)\t ▒ ░   ░   ░ ░ ░           ░   ░░         ░       ▒ ░░ ░ ░ ▒     ░   ░ ░ $(END)"
	@echo "$(PURPLE)\t ░           ░ ░ ░         ░  ░                   ░      ░ ░           ░ $(END)"
	@echo "$(PURPLE)\t               ░                                                         $(END)"
	@echo "\t"
	@echo "\t"
	@echo "This project sets up a small infrastructure composed of different services under specific rules."
	@echo "\nUsage:\tmake [$(BOLD)OPTIONS$(END)]"
	@echo "\nGlobal options: "
	@echo "\tup\t\tBuild and run all services"
	@echo "\tdown\t\tStop and remove containers and networks"
	@echo "\tbuild\t\tBuild or rebuild services"
	@echo "\tps\t\tList containers"
	@echo "\tstart\t\tStart services"
	@echo "\tstop\t\tStop services"
	@echo "\tmkdir\t\tCreate folders for the MariaDB and WordPress databases"
	@echo "\tclean\t\tClean up containers (force clean if a container is running)"
	@echo "\tprune\t\tClean up images and containers"
	@echo "\tre\t\tRebuild images and start containers from scratch"
	@echo "\tmariadb\t\tStart the MariaDB container in interactive mode"
	@echo "\tnginx\t\tStart the NGINX container in interactive mode"
	@echo "\twordpress\tStart the WordPress container in interactive mode"
	@echo "\tredis\t\tStart the Redis container in interactive mode"
	@echo "\tftp\t\tStart the FTP container in interactive mode"
	@echo "\tcadvisor\tStart the cAdvisor container in interactive mode"
	@echo "\twebsite\t\tStart the Website container in interactive mode"
	@echo "\tadminer\t\tStart the Adminer container in interactive mode"
	@echo ""

.PHONY: all up down start stop mkdir clean prune re mdb ng wp help 

PURPLE	= \033[0;35m
GREEN=	\033[1;32m
YELLOW=	\033[33m
BOLD	= \033[1m
END		= \033[0m