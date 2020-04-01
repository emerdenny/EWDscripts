#!/bin/bash

# This script sets up vagrant box bento/amazonlinux-2 for python development.

# Make temporary ~/setup folder for easy cleanup
sudo -u vagrant mkdir /home/vagrant/setup
cd /home/vagrant/setup

# Configure git 
sudo -u vagrant git config --global user.name "emerdenny"
sudo -u vagrant git config --global user.email "emerdenny@protonmail.ch"

# Transfer .zshrc
sudo -u vagrant cp /home/vagrant/EWDscripts/config_files/.zshrc /home/vagrant/.zshrc

# Install ZSH
yum -q -y install zsh

# Install Oh-My-ZSH
sudo -u vagrant /home/vagrant/EWDscripts/omzinstall.sh --unattended

# Install Powerlevel9k Theme
sudo -u vagrant git clone -q https://github.com/bhilburn/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k

# Install Powerline Fonts
sudo -u vagrant git clone -q https://github.com/powerline/fonts.git
sudo -u vagrant /home/vagrant/setup/fonts/install.sh

# Install Vundle
sudo -u vagrant git clone https://github.com/gmarik/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim

# Install Vim color darkburn
sudo -u vagrant mkdir /home/vagrant/.vim/colors/
sudo -u vagrant curl -fsSL https://raw.githubusercontent.com/flazz/vim-colorschemes/master/colors/darkburn.vim -o /home/vagrant/.vim/colors/darkburn.vim  

# Transfer .vimrc
sudo -u vagrant cp /home/vagrant/EWDscripts/config_files/.vimrc /home/vagrant/.vimrc

# Within Vim run :PluginInstall
sudo -u vagrant vim -c ":PluginInstall" -c ":q" -c ":q"

# Install Tmux
yum -q -y install tmux

# Transfer .tmux.conf
sudo -u vagrant cp /home/vagrant/EWDscripts/config_files/.vimrc /home/vagrant/.vimrc

# Remove setup directory
rm -rf /home/vagrant/setup

# Set ZSH as default shell
vim /etc/passwd -c ":%s/"${SUDO_USER}":\/bin\/bash/"${SUDO_USER}":\/bin\/zsh/g" -c ":wq"

# Run ZSH
sudo -u vagrant zsh

exit 0
