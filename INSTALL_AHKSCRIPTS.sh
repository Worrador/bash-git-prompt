#!/bin/bash

# Define variables
AHK_URL="https://autohotkey.com/download/ahk-v2.exe"
AHK_INSTALLER="AutoHotkey_2.0.18_setup.exe"
AHK_FILE="GitBashBorderless.ahk"
STARTUP_FOLDER="$APPDATA\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


# Check if AutoHotkey is installed
if ! command -v AutoHotkey > /dev/null 2>&1; then
    echo -e "${YELLOW}AutoHotkey not found. Installing...${NC}"
	
    # Install AutoHotkey
    if ! "./$AHK_INSTALLER"; then
        echo -e "${RED}Error: Failed to install AutoHotkey.${NC}"
		read -p "Press [Enter] to exit."
		exit 1
    else
		echo -e "${GREEN}AutoHotkey installed.${NC}"
	fi
else
    echo "AutoHotkey is already installed."
fi

# Copy the GitBashBorderless.ahk file to the startup folder
if [ -f "$AHK_FILE" ]; then
    echo "Copying $AHK_FILE to Startup folder..."
    cp "$AHK_FILE" "$STARTUP_FOLDER"
    echo -e "${GREEN}AutoHotkey script copied to startup folder.${NC}"
else
    echo -e "${RED}Error: $AHK_FILE not found.${NC}"
fi

# Keep the window open
read -p "Press [Enter] to exit."