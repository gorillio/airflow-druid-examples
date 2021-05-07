GIT_COMMIT:=$(shell git rev-parse --short HEAD)
CURRENT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
AIRFLOW_ENV?=dev


.PHONY: clean-all
clean-all:
	$(info --- clean all images and volumes)
	docker-compose -f docker-compose.yaml down --volumes --rmi all
	rm -rf logs/ database/ *.pid *.cfg webserver_config.py

.PHONY: clean
clean:
	$(info --- docker compose down)
	docker-compose -f docker-compose.yaml down
	rm -rf *.pid *.cfg webserver_config.py

.PHONY: install-requirements
install-requirements:
	$(info --- installing requirements)
	cat requirements.txt | xargs -n 1 pip install

.PHONY: up
up:
	$(info --- docker compose up)
	docker-compose -f docker-compose.yaml up


.PHONY: connections
connections:
	$(info -- add connections)

	@docker exec $$(docker ps -qf "name=scheduler_1$$") airflow connections add 'druid_ingest_conn_id' \
	  --conn-type 'http' \
	  --conn-description 'druid ingestion connection id' \
	  --conn-extra '{"endpoint": "druid/indexer/v1/task"}' \
	  --conn-host '${DRUID_HOST}' \
	  --conn-login '${DRUID_LOGIN_USER}' \
	  --conn-password '${DRUID_PASSWORD}' \
	  --conn-port '80' \
	  --conn-schema 'https'

.PHONY: up-in-detach
up-in-detach:
	$(info --- docker compose up)
	docker-compose -f docker-compose.yaml up -d

.PHONY: init
init:
	$(info --- setup required directories)
	mkdir -p logs database plugins

.PHONY: run
run: init up

.PHONY: run-in-detach
run-in-detach: init up-in-detach

