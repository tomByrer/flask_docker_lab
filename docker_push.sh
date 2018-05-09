#!/usr/bin/env bash
# We want this script to exit if we get any errors
set -e
# Travis-ci uses this script to push the built docker image to the repository

# We should have secrets file created by create_ecr_secrets.sh, encoded
# in the dev environment and decoded in the travis environment

# Import the AWS ECR variables
. ./ecr.secrets

# Log into the AWS ECR repository
echo "Logging into repository ${ECR_URL}"
docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}

# Tag current build as latest
echo "Tagging flask_docker_lab as ${ECR_DNS}/flask_docker_lab:latest"
docker tag flask_docker_lab ${ECR_DNS}/flask_docker_lab:latest

# Push this version as :latest
echo "Pushing ${ECR_DNS}/flask_docker_lab:latest"
docker push ${ECR_DNS}/flask_docker_lab:latest

if [ ! -z ${TRAVIS_TAG} ]; then
  # Tag the image we built with the tag sent from github
  echo "\$TRAVIS_TAG is set to $TRAVIS_TAG"
  echo "Tagging ${ECR_DNS}/flask_docker_lab:latest as ${ECR_DNS}/flask_docker_lab:${TRAVIS_TAG}"
  docker tag ${ECR_DNS}/flask_docker_lab:latest ${ECR_DNS}/flask_docker_lab:${TRAVIS_TAG}

  # Now push the docker image again AWS ECR repository with version tag
  echo "Pushing ${ECR_DNS}/flask_docker_lab:${TRAVIS_TAG}"
  docker push ${ECR_DNS}/flask_docker_lab:${TRAVIS_TAG}
fi
