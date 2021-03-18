#!/bin/bash

REGISTRY_URL=`aws ssm get-parameter --name /terraform_staff_infrastructure_monitoring/$ENV/outputs | jq -r .Parameter.Value | jq .blackbox_exporter_repository_v2.value.repository_url | sed 's/"//g'`
REGISTRY_HOSTNAME=`echo $REGISTRY_URL | cut -d'/' -f 1`
REGISTRY_PARAM=`echo $REGISTRY_URL | cut -d'/' -f 2`

echo $REGISTRY_URL
aws ecr get-login-password | docker login --username AWS --password-stdin $REGISTRY_HOSTNAME
docker tag $REGISTRY_PARAM:latest $REGISTRY_URL:latest
docker push $REGISTRY_URL:latest
