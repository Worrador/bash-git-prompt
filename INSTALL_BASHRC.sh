#!/bin/bash

# Get the current directory path using Windows-style forward slashes
CURRENT_PATH=$(pwd | sed 's#\\#/#g')
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Function to search for directories on the D: drive containing 'repo'
function search_repo_folders() {
    find /d -type d -iname "*repo*" 2>/dev/null | head -n 10  # Limit search to 10 results for simplicity
}

# Search for "repo" directories beforehand
repo_dirs=$(search_repo_folders)

# Combine the parent directory and the search results for listing
echo -e "Select a repository root folder from the list below, or enter a custom path:\n"

# Add found directories to options array
while IFS= read -r line; do
    options+=("$line")
done <<< "$repo_dirs"

# Add manual input option
options+=("Enter a custom path manually")

# Display the options to the user
i=1
for option in "${options[@]}"; do
    echo "$i) $option"
    ((i++))
done

# Prompt the user to choose from the options or enter a custom path
echo
read -p "Enter the number of your choice, or type a custom path: " choice

# Handle user selection
if [[ "$choice" =~ ^[0-9]+$ ]]; then
    if ((choice > 0 && choice <= ${#options[@]})); then
        if [[ "${options[$((choice-1))]}" == "Enter a custom path manually" ]]; then
            read -p "Enter the full path to your repository root folder: " REPO_ROOT
        else
            REPO_ROOT="${options[$((choice-1))]}"
        fi
    else
        echo "Invalid choice. Exiting..."
        exit 1
    fi
else
    REPO_ROOT="$choice"
fi

# Validate the selected or entered directory
if [ -d "$REPO_ROOT" ]; then
    echo "Selected repository root: $REPO_ROOT"
else
    echo "Invalid directory. Exiting..."
    exit 1
fi

# Clear the screen after selection
clear

# Step 0: Copy .bashrc to home folder
cp ./.bashrc ~/

# Step 1: Set the alias to jump to the selected repo folder
ALIAS="alias repos='cd $REPO_ROOT'"

# Step 2: Add the alias to .bashrc
echo "Adding \"repos\" alias for jumping to repo folder to .bashrc..."
echo "$ALIAS" >> ~/.bashrc

# Step 3: Source the git prompt script
echo "source $CURRENT_PATH/gitprompt.sh" >> ~/.bashrc

echo
echo "Alias added, .bashrc updated, and copied to home folder."

# Step 5: Keep the script open
echo
read -n 1 -s -p "Press any key to continue..."
