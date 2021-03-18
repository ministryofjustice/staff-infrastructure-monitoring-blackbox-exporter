ifneq (,$(wildcard ./.env))
	include .env
endif

authenticate_docker:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com

build: authenticate_docker
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t pttp-${ENV}-ima-blackbox-exporter .

build_mojo: authenticate_docker
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t mojo-${ENV}-ima-blackbox-exporter .

publish: build
	ENV=${ENV} ./scripts/deploy.sh blackbox_exporter_repository

publish_mojo: build_mojo
	ENV=${ENV} ./scripts/deploy_mojo.sh blackbox_exporter_repository_v2

deploy:
	ENV=${ENV} ./scripts/restart_ecs_service.sh

deploy_mojo:
	ENV=${ENV} ./scripts/restart_ecs_service_mojo.sh

serve:
	docker run -d -p 9115:9115 --name blackbox-exporter pttp-${ENV}-ima-blackbox-exporter

stop:
	docker container stop blackbox-exporter

test:
	echo "No tests"

.PHONY: build deploy serve test
