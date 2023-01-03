THIS_FILE := $(lastword $(MAKEFILE_LIST))
ELIXIR_IMAGE=elixir:1.13.3

DB_INSTANCE=assignment_service_database
DB_IMAGE=postgres
DB_PASS=postgres
DB_PORT=5432
DB_HOST=182.17.0.40

.PHONY: echo_test
echo_test:
	echo ${MAKE} ${THIS_FILE} ${ELIXIR_IMAGE} $(shell pwd)

.PHONY: local-docker-build
local-docker-build:
	@docker run \
			--rm \
			--volume $(shell pwd):/app \
			--workdir /app \
			$(ELIXIR_IMAGE) \
			/bin/bash -c "mix local.hex --force --if-missing && \
						  mix local.rebar --force && \
						  mix deps.get && \
						  mix deps.compile"

.PHONY: db-start
db-start: create-network db-install
	@docker rm -f assignment_service_database
	@docker run --name $(DB_INSTANCE) \
					-e POSTGRES_PASSWORD=$(DB_PASS) \
					-e MIX_ENV=dev \
					--network assignment_service_net \
					--ip 178.17.0.40 \
					-p $(DB_PORT):$(DB_PORT) \
					-d $(DB_IMAGE)
	@$(MAKE) -f $(THIS_FILE) db-create

.PHONY: db-install
db-install:
	@docker pull $(DB_IMAGE)

.PHONY: db-create
db-create:
	@docker run -it \
			--rm \
			--volume $(shell pwd):/app \
			--workdir /app \
			-e MIX_ENV=dev \
			--network assignment_service_net \
			--ip 178.17.0.43 \
			$(ELIXIR_IMAGE) \
			/bin/bash -c "mix local.hex --force --if-missing && \
						  mix local.rebar --force && \
						  mix ecto.create"
	@$(MAKE) -f $(THIS_FILE) db-migrate

.PHONY: db-migrate
db-migrate: 
	@docker run -it \
			--rm \
			--volume $(shell pwd):/app \
			--workdir /app \
			-e MIX_ENV=dev \
			--network assignment_service_net \
			--ip 178.17.0.44 \
			$(ELIXIR_IMAGE) \
			/bin/bash -c "mix local.hex --force --if-missing && \
						  mix local.rebar --force && \
						  mix ecto.migrate"

.PHONY: create-network
create-network:
	@docker network create -d bridge --subnet 178.17.0.0/24 --gateway 178.17.0.1 assignment_service_net || true
