#!/bin/bash

# This deployment script starts a zero downtime phased deployment.
# It works by doubling the currently running tasks by introducing the new versions
# Auto scaling will detect that there are too many tasks running for the current load and slowly start decomissioning the old running tasks
# Production traffic will gradually be moved to the new running tasks

set -e

assume_deploy_role() {
  TEMP_ROLE=`aws sts assume-role --role-arn $ROLE_ARN --role-session-name ci-ima-deploy-$CODEBUILD_BUILD_NUMBER`
  export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')
}

deploy() {
  cluster_name=mojo-${ENV}-ima-ecs-cluster
  service_name=mojo-${ENV}-ima-blackbox_exporter-ecs-service

  aws ecs update-service \
    --cluster $cluster_name \
    --service $service_name \
    --force-new-deployment
}

main() {
  if [ "$CODEBUILD_CI" = "true" ]
  then
    assume_deploy_role
  fi

  deploy
}

main
