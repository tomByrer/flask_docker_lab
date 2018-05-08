#!/bin/bash

# Install Atom IDE

sudo add-apt-repository -y ppa:webupd8team/atom
sudo apt-get install -qq -y atom

# Atom wont work over VNC unless we run this:
# https://github.com/atom/atom/issues/4360
sudo cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/atom/
sudo sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/atom/libxcb.so.1
