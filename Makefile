PHP_CONTAINER=app
NODE_CONTAINER=node

env:
	cp src/.env.example src/.env

mysql_777:
	sudo chmod -R 777 docker/mysql

init:
	docker compose build
	docker compose up -d
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "composer install"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan key:generate"
	#docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "sudo chmod -R 777 storage"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan storage:link"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan migrate"
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash -c "php artisan db:seed"
	docker compose exec $(NODE_CONTAINER) bash -c "npm i"
	docker compose exec $(NODE_CONTAINER) bash -c "npm run dev"
build:
	docker compose build

up:
	docker compose up -d

dev:
	docker compose exec $(NODE_CONTAINER) bash -c "npm run dev"

prod:
	docker compose exec $(NODE_CONTAINER) bash -c "npm run build"

down:
	docker compose down

php:
	docker compose exec -u root -t -i $(PHP_CONTAINER) bash

node:
	docker compose exec $(NODE_CONTAINER) bash
