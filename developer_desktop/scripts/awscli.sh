#!/bin/bash
# install AWS CLI

sudo apt-get -qq -y install python-pip
sudo pip install -q --upgrade pip
sudo pip install -q awscli --upgrade
