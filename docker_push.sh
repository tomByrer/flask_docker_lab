#!/usr/bin/env bash
# We want this script to exit if we get any errors
set -e
# Travis-ci uses this script to push the built docker image to the containersitory

# We should have secrets file created by create_ecr_secrets.sh, encoded
# in the dev environment and decoded in the travis environment

# Get the container name from the terraform variables file
containerName=`grep -A1 containerName infrastructure/terraform/variables.tf | \
    tail -1 | awk -F'=' '{print$2}' | sed s/\"//g | sed s/\ //g`

# Import the AWS ECR variables
. ./ecr.secrets

# Log into the AWS ECR containersitory
echo "Logging into containersitory ${ECR_URL}"
docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}

# Tag current build as latest
echo "Tagging ${containerName} as ${ECR_DNS}/${containerName}:latest"
docker tag ${containerName} ${ECR_DNS}/${containerName}:latest

# Push this version as :latest
echo "Pushing ${ECR_DNS}/${containerName}:latest"
docker push ${ECR_DNS}/${containerName}:latest

if [ ! -z ${TRAVIS_TAG} ]; then
  # Tag the image we built with the tag sent from github
  echo "\$TRAVIS_TAG is set to $TRAVIS_TAG"
  echo "Tagging ${ECR_DNS}/${containerName}:latest as ${ECR_DNS}/${containerName}:${TRAVIS_TAG}"
  docker tag ${ECR_DNS}/${containerName}:latest ${ECR_DNS}/${containerName}:${TRAVIS_TAG}

  # Now push the docker image again AWS ECR containersitory with version tag
  echo "Pushing ${ECR_DNS}/${containerName}:${TRAVIS_TAG}"
  docker push ${ECR_DNS}/${containerName}:${TRAVIS_TAG}
fi
