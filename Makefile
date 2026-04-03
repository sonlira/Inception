NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml -p $(NAME)
HOST = abaldelo

all: build
	@mkdir -p /home/$(HOST)/data/mysql
	@mkdir -p /home/$(HOST)/data/wordpress
	@chmod -R 777 /home/$(HOST)/data
	$(COMPOSE) up -d

build:
	$(COMPOSE) build

down:
	$(COMPOSE) down

re: fclean all

clean:
	$(COMPOSE) down --rmi all

fclean: clean
	$(COMPOSE) down -v
	sudo rm -rf /home/$(HOST)/data

.PHONY: all build down ru clean fclean