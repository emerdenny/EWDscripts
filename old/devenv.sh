#!/bin/bash/

# This script brings up the vagrant boxes defined in the Vagrantfile and sets up the tmux environment.

tmux new-session -d -n "pycomm" 
tmux split-window -h
tmux split-window -v
tmux select-pane -L
tmux split-window -v
tmux select-pane -U
tmux -2 attach-session -d
