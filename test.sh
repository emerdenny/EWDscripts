#!/bin/bash

# This script sets up "${USER}" box ubuntu/bionic64 for Vim full ide development

# Languages: Python, Rust, Node/JSX

# Set script path
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Make temporary ~/setup folder for easy cleanup
mkdir /home/"${USER}"/setup
cd /home/"${USER}"/setup

# Configure git 
git config --global user.name "emerdenny"
git config --global user.email "emerdenny@protonmail.ch"

# INSTALL NODE
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

# INSTALL YARN
npm install --global yarn

# Transfer .vimrc
cp "${SCRIPT_PATH}"/config_files/.vimrc /home/"${USER}"/

# Change to home folder
cd /home/"${USER}"

# Remove setup directory
rm -rf /home/"${USER}"/setup

exit 0
