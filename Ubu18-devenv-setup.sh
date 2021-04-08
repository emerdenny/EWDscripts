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

# BUILD VIM FROM SOURCE
sudo apt update && apt-get update
sudo apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev \
	libcairo2-dev libx11-dev libxpm-dev libxt-dev \
	python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev git
sudo apt remove -y vim vim-runtime gvim
sudo git clone https://github.com/vim/vim.git
cd ./vim
sudo ./configure --with-features=huge \
				  --enable-multibyte \
		                  --enable-rubyinterp=yes \
				  --enable-python3interp=yes \
				  --with-python3-config-dir=$(python3-config --configdir) \
				  --enable-perlinterp=yes \
				  --enable-luainterp=yes \
				  --enable-gui=gtk2 \
				  --enable-cscope \
				  --prefix=/usr/local
sudo make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
sudo make install
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
cd /home/"${DEV_USER}"/setup

# INSTALL RUST LANG
# need param to accept defaults (currently typing 1)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo sh
source $HOME/.cargo/env
rustup default nightly

# INSTALL NODE
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | sudo bash
source ~/.bashrc
sudo nvm install node

# INSTALL YARN
sudo npm install --global yarn

# INSTALL FZF
sudo apt-get install fzf

# INSTALL RIPGREP
cd /home/"${DEV_USER}"/setup
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
dpkg -i ripgrep_12.1.1_amd64.deb

# Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Transfer .vimrc
cp "${SCRIPT_PATH}"/config_files/.vimrc /home/"${DEV_USER}"/

# Within Vim run :PluginInstall
vim -c ":PluginInstall" -c ":q" -c ":q"

# Change to home folder
cd /home/"${DEV_USER}"

# Remove setup directory
rm -rf /home/"${DEV_USER}"/setup

exit 0
