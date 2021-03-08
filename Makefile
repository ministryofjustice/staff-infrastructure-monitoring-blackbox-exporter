ifneq (,$(wildcard ./.env))
	include .env
endif

authenticate_docker:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com

build:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t pttp-${ENV}-ima-blackbox-exporter .

deploy: build
	REGISTRY_URL=$(./scripts/extract_params.sh snmp_exporter_repository repository_url)
	REGISTRY_HOSTNAME=$(cut -f 1 -d '/' <<<"$REGISTRY_URL")
	echo ${REGISTRY_URL}
	echo ${REGISTRY_HOSTNAME}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_HOSTNAME}
	docker tag pttp-${ENV}-ima-blackbox-exporter:latest ${REGISTRY_URL}:latest
	docker push ${REGISTRY_URL}:latest
	./scripts/restart_ecs_service.sh

build_mojo:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t mojo-${ENV}-ima-blackbox-exporter .

deploy_mojo: build
	REGISTRY_URL=$(./scripts/extract_params.sh snmp_exporter_repository_v2 repository_url)
	REGISTRY_HOSTNAME=$(cut -f 1 -d '/' <<<"$REGISTRY_URL")
	echo ${REGISTRY_URL}
	echo ${REGISTRY_HOSTNAME}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_HOSTNAME}
	docker tag mojo-${ENV}-ima-blackbox-exporter:latest ${REGISTRY_URL}:latest
	docker push ${REGISTRY_URL}:latest
	./scripts/restart_ecs_service_mojo.sh

serve:
	docker run -d -p 9115:9115 --name blackbox-exporter pttp-${ENV}-ima-blackbox-exporter

stop:
	docker container stop blackbox-exporter

test:
	echo "No tests"

.PHONY: build deploy serve test
