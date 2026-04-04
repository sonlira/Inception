NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml -p $(NAME)
HOST = abaldelo

all:
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

clean:
	@rm -rf /home/$(HOST)/data/mysql/*
	@rm -rf /home/$(HOST)/data/wordpress/*
	$(COMPOSE) down --rmi all

fclean: clean
	$(COMPOSE) down -v

.PHONY: all build down ru clean fclean