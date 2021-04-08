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

# Make temporary ~/setup folder for easy cleanup
sudo -u "${DEV_USER}" mkdir /home/"${DEV_USER}"/setup
cd /home/"${DEV_USER}"/setup

# Configure git 
sudo -u "${DEV_USER}" git config --global user.name "emerdenny"
sudo -u "${DEV_USER}" git config --global user.email "emerdenny@protonmail.ch"

# BUILD VIM FROM SOURCE
sudo -u "${DEV_USER}" apt update && apt-get update
sudo -u "${DEV_USER}" apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev \
	libcairo2-dev libx11-dev libxpm-dev libxt-dev \
	python3-dev ruby-dev lua5.2 liblua5.2-dev libperl-dev git
sudo -u "${DEV_USER}" apt remove vim vim-runtime gvim
sudo -u "${DEV_USER}" git clone https://github.com/vim/vim.git
cd ./vim
sudo -u "${DEV_USER}" ./configure --with-features=huge \
				  --enable-multibyte \
		                  --enable-rubyinterp=yes \
				  --enable-python3interp=yes \
				  --with-python3-config-dir=$(python3-config --configdir) \
				  --enable-perlinterp=yes \
				  --enable-luainterp=yes \
				  --enable-gui=gtk2 \
				  --enable-cscope \
				  --prefix=/usr/local
sudo -u "${DEV_USER}" make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
sudo -u "${DEV_USER}" make install
sudo -u "${DEV_USER}" update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo -u "${DEV_USER}" update-alternatives --set editor /usr/local/bin/vim
sudo -u "${DEV_USER}" update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo -u "${DEV_USER}" update-alternatives --set vi /usr/local/bin/vim
cd /home/"${DEV_USER}"/setup

# INSTALL RUST LANG
sudo -u "${DEV_USER}" curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo -u "${DEV_USER}" sh
rustup default nightly

# INSTALL NODE
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | sudo -u "${DEV_USER}" bash
sudo -u "${DEV_USER}" source ~/.bashrc
sudo -u "${DEV_USER}" nvm install node

# INSTALL YARN
sudo -u "${DEV_USER}" npm install --global yarn

# INSTALL FZF
sudo -u "${DEV_USER}" sudo apt-get install fzf

# INSTALL RIPGREP
cd /home/"${DEV_USER}"/setup
sudo -u "${DEV_USER}" curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
sudo -u "${DEV_USER}" sudo dpkg -i ripgrep_12.1.1_amd64.deb

# Transfer .bashrc
sudo -u "${DEV_USER}" cp /home/"${DEV_USER}"/EWDscripts/config_files/.bashrc /home/"${DEV_USER}"/

# Install Vim-Plug
sudo -u "${DEV_USER}" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Transfer .vimrc
sudo -u "${DEV_USER}" cp /home/"${DEV_USER}"/EWDscripts/config_files/.vimrc /home/"${DEV_USER}"/

# Within Vim run :PluginInstall
sudo -u "${DEV_USER}" vim -c ":PluginInstall" -c ":q" -c ":q"

# Change to home folder
cd /home/"${DEV_USER}"

# Remove setup directory
rm -rf /home/"${DEV_USER}"/setup

exit 0
