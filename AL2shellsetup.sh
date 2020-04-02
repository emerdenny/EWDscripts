#!/bin/bash

# This script sets up "${AL2_USER}" box bento/amazonlinux-2 for python development.

# Test for sudo
if ! [[ $(id -u) = 0 ]]
then
   echo "You need to be root to perform this command." >&2
   exit 1
fi

# Get login username
AL2_USER="${SUDO_USER}"

# Make temporary ~/setup folder for easy cleanup
sudo -u "${AL2_USER}" mkdir /home/"${AL2_USER}"/setup
cd /home/"${AL2_USER}"/setup

# Configure git 
sudo -u "${AL2_USER}" git config --global user.name "emerdenny"
sudo -u "${AL2_USER}" git config --global user.email "emerdenny@protonmail.ch"

# Transfer .zshrc
sudo -u "${AL2_USER}" cp /home/"${AL2_USER}"/EWDscripts/config_files/.zshrc /home/"${AL2_USER}"/.zshrc

# Install ZSH
yum -q -y install zsh

# Install Oh-My-ZSH
sudo -u "${AL2_USER}" /home/"${AL2_USER}"/EWDscripts/omzinstall.sh --unattended --keep-zshrc

# Install Powerlevel9k Theme
sudo -u "${AL2_USER}" git clone -q https://github.com/bhilburn/powerlevel9k.git /home/"${AL2_USER}"/.oh-my-zsh/custom/themes/powerlevel9k

# Install Powerline Fonts
sudo -u "${AL2_USER}" git clone -q https://github.com/powerline/fonts.git
sudo -u "${AL2_USER}" /home/"${AL2_USER}"/setup/fonts/install.sh

# Install Vundle
sudo -u "${AL2_USER}" git clone https://github.com/gmarik/Vundle.vim.git /home/"${AL2_USER}"/.vim/bundle/Vundle.vim

# Install Vim color darkburn
sudo -u "${AL2_USER}" mkdir /home/"${AL2_USER}"/.vim/colors/
sudo -u "${AL2_USER}" curl -fsSL https://raw.githubusercontent.com/flazz/vim-colorschemes/master/colors/darkburn.vim -o /home/"${AL2_USER}"/.vim/colors/darkburn.vim  

# Transfer .vimrc
sudo -u "${AL2_USER}" cp /home/"${AL2_USER}"/EWDscripts/config_files/.vimrc /home/"${AL2_USER}"/.vimrc

# Within Vim run :PluginInstall
sudo -u "${AL2_USER}" vim -c ":PluginInstall" -c ":q" -c ":q"

# Install Tmux
yum -q -y install tmux

# Transfer .tmux.conf
sudo -u "${AL2_USER}" cp /home/"${AL2_USER}"/EWDscripts/config_files/.tmux.conf /home/"${AL2_USER}"/.tmux.conf

# Install htop 
yum -q -y install htop 

# Install nethogs
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --enable epel
yum -q -y install nethogs

# Install Conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod 755 Miniconda3-latest-Linux-x86_64.sh 
sudo -u "${AL2_USER}" ./Miniconda3-latest-Linux-x86_64.sh -b
sudo -u "${AL2_USER}" export PATH="/home/"${AL2_USER}"/miniconda/bin:$PATH" 

# Remove setup directory
rm -rf /home/"${AL2_USER}"/setup

# Set ZSH as default shell
vim /etc/passwd -c ":%s/"${AL2_USER}":\/bin\/bash/"${AL2_USER}":\/bin\/zsh/g" -c ":wq"

# Change to home folder
cd /home/"${AL2_USER}"

# Run ZSH
sudo -u "${AL2_USER}" zsh

exit 0
