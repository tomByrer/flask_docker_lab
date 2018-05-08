#!/bin/bash

# installs docker-ce and docker-compose

# Install Docker-CE
curl get.docker.com | sh
# Docker-ce 18.05.0-ce will be GA and sppt ubuntu 18.04 in June 2018
if [ $? -ne 0 ]; then
	# Until then, lets intall a test version
	curl test.docker.com | sh
fi
sudo usermod ubuntu -a -G docker

# Install Docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod 755 /usr/local/bin/docker-compose
