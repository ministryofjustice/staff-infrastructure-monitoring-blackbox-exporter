ifneq (,$(wildcard ./.env))
	include .env
endif

.DEFAULT_GOAL := help

.PHONY: authenticate_docker
authenticate_docker: ## Authenticate docker script
	./scripts/authenticate_docker.sh

.PHONY: build
build: ## Docker build image
	$(MAKE) authenticate_docker
	docker build --platform linux/amd64 -t mojo-${ENV}-ima-blackbox-exporter .

.PHONY: publish
publish: ## Docker build and deploy blackbox exporter repo
	$(MAKE) build
	ENV=${ENV} ./scripts/deploy.sh blackbox_exporter_repository_v2

.PHONY: deploy
deploy: ## Redeploy ecs-service
	ENV=${ENV} ./scripts/restart_ecs_service.sh

.PHONY: serve
serve: ## Run blackbox-exporter
	docker run -d -p 9115:9115 --name blackbox-exporter mojo-${ENV}-ima-blackbox-exporter

.PHONY: stop
stop: ## Stop blackbox-exporter container
	docker container stop blackbox-exporter

.PHONY: test
test: ## Run tests
	echo "No tests"

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
