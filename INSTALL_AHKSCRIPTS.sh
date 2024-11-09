#!/bin/bash

# Define variables
AHK_URL="https://autohotkey.com/download/ahk-v2.exe"
AHK_INSTALLER="AutoHotkey_2.0.18_setup.exe"
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

# Count the number of .ahk files in the current directory
AHK_COUNT=$(ls -1 *.ahk 2>/dev/null | wc -l)

if [ $AHK_COUNT -eq 0 ]; then
    echo -e "${RED}Error: No .ahk files found in current directory.${NC}"
else
    echo "Found $AHK_COUNT AutoHotkey script(s)."
    echo "Copying .ahk files to Startup folder..."
    
    # Copy all .ahk files to startup folder
    for file in *.ahk; do
        if [ -f "$file" ]; then
            echo "Copying $file..."
            if cp "$file" "$STARTUP_FOLDER"; then
                echo -e "${GREEN}Successfully copied $file${NC}"
            else
                echo -e "${RED}Failed to copy $file${NC}"
            fi
        fi
    done
    
    echo -e "${GREEN}All AutoHotkey scripts processed.${NC}"
fi

# Keep the window open
read -p "Press [Enter] to exit."