#!/bin/bash

# This script sets up vagrant box bento/amazonlinux-2 for python development.

# Make temporary ~/setup folder for easy cleanup
mkdir /home/vagrant/setup
cd /home/vagrant/setup

# Configure git 
git config --global user.name "emerdenny"
git config --global user.email "emerdenny@protonmail.ch"

# Transfer .zshrc
cp /home/vagrant/EWDscripts/config_files/.zshrc /home/vagrant/.zshrc

# Install ZSH
yum -q -y install zsh

# Install Oh-My-ZSH
su -c "sh $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" vagrant 

# Install Powerlevel9k Theme
git clone -q https://github.com/bhilburn/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k

# Install Powerline Fonts
git clone -q https://github.com/powerline/fonts.git
./fonts/install.sh

# Install Vundle
git clone https://github.com/gmarik/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim

# Transfer .vimrc
cp /home/vagrant/EWDscripts/config_files/.vimrc /home/vagrant/.vimrc

# Within Vim run :PluginInstall
vim -c ":PluginInstall" -c ":q"

# Install Tmux
yum -q -y install tmux

# Transfer .tmux.conf
cp /home/vagrant/EWDscripts/config_files/.vimrc /home/vagrant/.vimrc

# Remove setup directory
rm -rf /home/vagrant/setup

# Set ZSH as default shell
vim passwordtest -c ":%s/"${USER}":\/bin\/bash/"${USER}":\/bin\/zsh/g" -c ":wq"

# Run ZSH
zsh

exit 0
