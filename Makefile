build:
	docker build -t pttp-${ENV}-ima-blackbox-exporter .

deploy: build
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag pttp-${ENV}-ima-blackbox-exporter:latest ${REGISTRY_URL}/pttp-${ENV}-ima-blackbox-exporter:latest
	docker push ${REGISTRY_URL}/pttp-${ENV}-ima-blackbox-exporter:latest

serve:
	docker run -d -p 9115:9115 --name blackbox-exporter pttp-${ENV}-ima-blackbox-exporter

stop:
	docker container stop blackbox-exporter

test:
	echo "No tests"

.PHONY: build deploy serve test
