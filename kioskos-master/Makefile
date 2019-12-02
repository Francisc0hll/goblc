SHELL := /bin/bash

all: build db apidocs run

run: build
	docker-compose run --service-ports web

build: .built .bundled

.built: Dockerfile.development
	docker-compose build
	touch .built

.bundled: Gemfile Gemfile.lock
	docker-compose run web bundle config --delete bin
	docker-compose run web bundle
	touch .bundled

stop:
	docker-compose stop

restart: build
	docker-compose restart web

open:
	$(shell \
				IP=`docker-machine ip default` ;\
				PORT=`docker-compose port web 3000 | cut -d: -f2` ;\
				if [ "$$PORT" == "" ] ;\
				then echo "@echo 'App NOT running. Check the logs'" ;\
				else echo "open http://$${IP}:$${PORT}" ;\
				fi)

clean: stop
	rm -f tmp/pids/*
	docker-compose rm -f -v bundle_cache
	rm -f .bundled
	docker-compose rm -f
	rm -f .built
	rm -f .create_db

test: db
	docker-compose run web rails test

logs:
	docker-compose logs

admin:
	docker-compose run web rails db:seed

db:
	docker-compose run web rails db:create db:migrate

apidocs:
	docker-compose run web rake swagger:docs

console:
	docker-compose run web rails c

sandbox:
	docker-compose run web rails c '--sandbox'

docker-build:
	docker build -t egob/totems-autoatencion .

production-build: Dockerfile.production
	docker build -f Dockerfile.production -t egob/totems-autoatencion .

.PHONY: all run build stop restart open clean test logs db apidocs
