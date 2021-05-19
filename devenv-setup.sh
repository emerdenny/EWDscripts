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

# Install tmux config
git clone https://github.com/samoshkin/tmux-config.github
./tmux-config/install.sh

# BUILD VIM FROM SOURCE
sudo apt update && sudo apt-get update
sudo apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev \
	libcairo2-dev libx11-dev libxpm-dev libxt-dev \
	python3-dev python3-pip ruby-dev lua5.2 liblua5.2-dev libperl-dev git
sudo apt remove -y vim vim-runtime gvim
git clone https://github.com/vim/vim.git
cd ./vim
./configure --with-features=huge \
				  --enable-multibyte \
		                  --enable-rubyinterp=yes \
				  --enable-python3interp=yes \
				  --enable-perlinterp=yes \
				  --enable-luainterp=yes \
				  --enable-gui=gtk2 \
				  --enable-cscope \
				  --prefix=/usr/local
sudo make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
sudo make install
update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
update-alternatives --set editor /usr/local/bin/vim
update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
update-alternatives --set vi /usr/local/bin/vim
cd /home/"${USER}"/setup

# INSTALL RUST LANG
# need param to accept defaults (currently typing 1)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup default nightly

# INSTALL NODE
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
source ~/.profile
. /home/"${USER}"/.nvm/nvm.sh
nvm install node

# INSTALL YARN
npm install --global yarn

# INSTALL RIPGREP
cd /home/"${USER}"/setup
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
sudo dpkg -i ripgrep_12.1.1_amd64.deb

# Dependency for vimspector python adapter
pip3 install setuptools

# Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Transfer .vimrc
cp "${SCRIPT_PATH}"/config_files/.vimrc /home/"${USER}"/

# Within Vim run :PluginInstall
vim -c ":PlugInstall" -c ":q" -c ":q"

# CocInstall Extensions
vim -c 'CocInstall -sync coc-css coc-eslint coc-fzf-preview coc-git coc-html coc-htmlhint coc-html-css-support coc-json coc-prettier coc-pyright coc-rust-analyzer coc-tsserver coc-yaml|q'

# Add Coc/Ale integration settings
cp "${SCRIPT_PATH}"/config_files/coc-settings.json /home/"${USER}"/.vim/

# Change to home folder
cd /home/"${USER}"

# Remove setup directory
sudo rm -rf /home/"${USER}"/setup

source ~/.bashrc

exit 0
