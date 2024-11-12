DB_DIR_PATH	= "/home/${USER}/storage_vol/mariadb"
WP_DIR_PATH	= "/home/${USER}/storage_vol/wordpress_db"
DCK_PATH	= "./srcs/docker-compose.yml"

DB_SRV		= mariadb
WP_SRV		= wordpress
NG_SRV		= nginx

all: help

up: build
	@docker compose up -d -f $(DCK_PATH) -p inception

down:
	@docker compose -f $(DCK_PATH) down

build: mkdir
	@docker compose -f $(DCK_PATH) build

start:
	@docker compose -f $(DCK_PATH) start $(docker compose -f $(DCK_PATH) config --services)

stop:
	@docker compose -f $(DCK_PATH) stop $(docker compose -f $(DCK_PATH) config --services)

mdb:
	@docker container exec -it $(docker ps -q -f "name=$(DB_SRV)") bash

ng:
	@docker container exec -it $(docker ps -q -f "name=$(NG_SRV)") bash

wp:
	@docker container exec -it $(docker ps -q -f "name=$(WP_SRV)") bash

clean:
	@rm -rf $(DB_DIR_PATH) $(WP_DIR_PATH)
	@docker container rm $(docker ps -aq) -f -v
	@docker volume prune -f

prune: clean
	@docker system prune --all --volumes --force


mkdir:
	@mkdir -p $(DB_DIR_PATH) $(WP_DIR_PATH)

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
	@echo "\tup\tBuild and run all services"
	@echo "\tdown\tStop and remove containers and networks"
	@echo "\tbuild\tBuild or rebuild services"
	@echo "\tstart\tStart services"
	@echo "\tstop\tStop services"
	@echo "\tmkdir\tCreate folders for the MariaDB and WordPress databases"
	@echo "\tclean\tClean up containers (force clean if a container is running)"
	@echo "\tprune\tClean up images and containers"
	@echo "\tre\tRebuild images and start containers from scratch"
	@echo "\tmdb\tStart the MariaDB container in interactive mode"
	@echo "\tng\tStart the NGINX container in interactive mode"
	@echo "\twp\tStart the WordPress container in interactive mode"
	@echo ""

.PHONY: all up down start stop mkdir clean prune re mdb ng wp help 

PURPLE	= \033[0;35m
BOLD	= \033[1m
END		= \033[0m