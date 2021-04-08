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

# Transfer .vimrc
sudo cp "${SCRIPT_PATH}"/config_files/.vimrc /home/"${DEV_USER}"/

# Change to home folder
cd /home/"${DEV_USER}"

exit 0
