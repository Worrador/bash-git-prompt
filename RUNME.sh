#!/bin/bash

# Get the current directory path using Windows-style forward slashes
CURRENT_PATH=$(pwd | sed 's#\\#/#g')

# Step 1: Extend .bashrc with current path
echo "source $CURRENT_PATH/gitprompt.sh" >> ./.bashrc

# Step 2: Copy modified .bashrc to home folder
cp ./.bashrc ~/

echo "Updated .bashrc and copied to home folder."
