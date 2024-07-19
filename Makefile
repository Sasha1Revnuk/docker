# Define variables
PHP_CONTAINER=app


init:
	cp .env.example .env
	cp -r ./docker-sources ./docker
	make sync-env
	mv docker/docker-compose.yml docker-compose.yml
	rm docker/Makefile
	rm docker/.env


docker-init:
	docker compose build
	docker compose up -d
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "composer install"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan key:generate"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "sudo chmod -R 777 storage/framework"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "sudo chmod -R 777 storage/logs"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan storage:link"
	docker compose exec $(PHP_CONTAINER) bash -c "npm i"
	docker compose exec $(PHP_CONTAINER) bash -c "npm run build"

build:
	docker compose build

up:
	docker compose up -d

dev:
	docker compose exec $(PHP_CONTAINER) bash -c "npm run dev"

prod:
	docker compose exec $(PHP_CONTAINER) bash -c "npm run build"

down:
	docker compose down

php:
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash


.PHONY: sync-env
sync-env:
	@echo "Syncing environment variables from docker/.env to .env"
	@while IFS= read -r line; do \
		if [ -n "$$line" ]; then \
			variable=$$(echo $$line | cut -d '=' -f 1); \
			value=$$(echo $$line | cut -d '=' -f 2-); \
			if grep -q "^$$variable=" .env; then \
				sed -i.bak "s/^$$variable=.*/$$variable=$$value/" .env; \
			else \
				echo "$$variable=$$value" >> .env; \
			fi; \
		fi; \
	done < docker/.env
	@rm -f .env.bak
