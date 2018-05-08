#!/bin/bash

# Install terraform
curl -s https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip | gzip -d - > ./terraform
chmod 755 ./terraform
sudo mv terraform /usr/local/bin
