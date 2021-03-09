ifneq (,$(wildcard ./.env))
	include .env
endif

REGISTRY_URL := $(shell ./scripts/extract_params.sh blackbox_exporter_repository repository_url)
REGISTRY_HOSTNAME := $(shell cut -f 1 -d '/' <<<"${REGISTRY_URL}")
REGISTRY_PARAM := $(shell cut -f 2 -d '/' <<<"${REGISTRY_URL}")
REGISTRY_URL_MOJO := $(shell ./scripts/extract_params.sh blackbox_exporter_repository_v2 repository_url)
REGISTRY_HOSTNAME_MOJO := $(shell cut -f 1 -d '/' <<<"${REGISTRY_URL_MOJO}")
REGISTRY_PARAM_MOJO := $(shell cut -f 2 -d '/' <<<"${REGISTRY_URL_MOJO}")

authenticate_docker:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com

build:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t pttp-${ENV}-ima-blackbox-exporter .

deploy: build
	echo ${REGISTRY_URL}
	echo ${REGISTRY_HOSTNAME}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_HOSTNAME}
	docker tag ${REGISTRY_PARAM}:latest ${REGISTRY_URL}:latest
	docker push ${REGISTRY_URL}:latest
	./scripts/restart_ecs_service.sh

build_mojo:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t mojo-${ENV}-ima-blackbox-exporter .

deploy_mojo: build
	echo ${REGISTRY_URL_MOJO}
	echo ${REGISTRY_HOSTNAME_MOJO}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_HOSTNAME_MOJO}
	docker tag ${REGISTRY_PARAM_MOJO}:latest ${REGISTRY_URL_MOJO}:latest
	docker push ${REGISTRY_URL-MOJO}:latest
	./scripts/restart_ecs_service_mojo.sh

serve:
	docker run -d -p 9115:9115 --name blackbox-exporter pttp-${ENV}-ima-blackbox-exporter

stop:
	docker container stop blackbox-exporter

test:
	echo "No tests"

.PHONY: build deploy serve test
