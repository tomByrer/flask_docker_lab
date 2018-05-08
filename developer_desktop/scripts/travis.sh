#!/bin/bash
# Install travis cli

sudo apt-get -qq -y install ruby ruby-dev
sudo gem install travis -q -v 1.8.8 --no-rdoc --no-ri
