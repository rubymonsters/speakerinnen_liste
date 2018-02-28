#!/bin/bash

# Set environment
set -e

# Ensure utf8 encoding
update-locale LC_ALL=en_US.utf8

apt-get update

# This will prevent the password setting dialogue
export DEBIAN_FRONTEND=noninteractive

# Enable the add-apt-repository command
apt-get install -y software-properties-common

# Install build essentials & libraries
apt-get install -y git curl python-software-properties build-essential \
                   imagemagick libmagick++-dev libxslt-dev libxml2-dev \
                   zlib1g-dev vim ruby ruby-dev git

# Install latest release of node.js 9.x PPA
apt-get update
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

# Install packages node.js and npm
apt-get install nodejs

# Create a symlink for nodejs and node
ln -s `which nodejs` /usr/bin/node

