ifneq (,$(wildcard ./.env))
	include .env
endif

authenticate_docker:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com

build:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t pttp-${ENV}-ima-blackbox-exporter .

deploy: build
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag pttp-${ENV}-ima-blackbox-exporter:latest ${REGISTRY_URL}/pttp-${ENV}-ima-blackbox-exporter:latest
	docker push ${REGISTRY_URL}/pttp-${ENV}-ima-blackbox-exporter:latest
	./scripts/restart_ecs_service.sh

build_mojo:
	docker build --build-arg SHARED_SERVICES_ACCOUNT_ID=${SHARED_SERVICES_ACCOUNT_ID} -t mojo-${ENV}-ima-blackbox-exporter .

deploy_mojo: build
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag mojo-${ENV}-ima-blackbox-exporter:latest ${REGISTRY_URL}/mojo-${ENV}-ima-blackbox-exporter:latest
	docker push ${REGISTRY_URL}/mojo-${ENV}-ima-blackbox-exporter:latest
	./scripts/restart_ecs_service_mojo.sh

serve:
	docker run -d -p 9115:9115 --name blackbox-exporter pttp-${ENV}-ima-blackbox-exporter

stop:
	docker container stop blackbox-exporter

test:
	echo "No tests"

.PHONY: build deploy serve test
