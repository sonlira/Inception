NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml -p $(NAME)
HOST = abaldelo
DATA_PATH = /home/$(HOST)/data

all:
	@mkdir -p $(DATA_PATH)/mysql
	@mkdir -p $(DATA_PATH)/wordpress
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

clean:
	@$(COMPOSE) down --rmi all
	@sudo rm -rf $(DATA_PATH)/mysql/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*

fclean: clean
	@$(COMPOSE) down -v --rmi all --remove-orphans

re: fclean all

.PHONY: all down clean fclean re