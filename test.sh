#!/bin/bash

# This script sets up "${DEV_USER}" box ubuntu/bionic64 for Vim full ide development

# Languages: Python, Rust, Node/JSX

# Test for sudo
if ! [[ $(id -u) = 0 ]]
then
   echo "You need to be root to perform this command." >&2
   exit 1
fi

# Get login username
DEV_USER="${SUDO_USER}"

# Set script path
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Make temporary ~/setup folder for easy cleanup
sudo mkdir /home/"${DEV_USER}"/setup
cd /home/"${DEV_USER}"/setup

# Configure git 
sudo git config --global user.name "emerdenny"
sudo git config --global user.email "emerdenny@protonmail.ch"

# INSTALL NODE
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install node

# INSTALL YARN
npm install --global yarn

# INSTALL FZF
sudo apt-get install fzf

# Transfer .vimrc
cp "${SCRIPT_PATH}"/config_files/.vimrc /home/"${DEV_USER}"/

# Change to home folder
cd /home/"${DEV_USER}"

# Remove setup directory
rm -rf /home/"${DEV_USER}"/setup

exit 0
