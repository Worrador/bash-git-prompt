#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to browse for a directory using PowerShell
browse_directory() {
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; \$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog; \$folderBrowser.Description = 'Select installation directory'; \$folderBrowser.RootFolder = 'MyComputer'; if(\$folderBrowser.ShowDialog() -eq 'OK') { Write-Host \$folderBrowser.SelectedPath }"
}

# Install Scoop if not present
if ! command -v scoop &> /dev/null; then
    # Prompt user to browse for installation directory
    echo "Please select the installation directory:"
    install_dir=$(browse_directory)

    # Validate and create the directory if it doesn't exist
    if [ ! -z "$install_dir" ]; then
        if [ ! -d "$install_dir" ]; then
            mkdir -p "$install_dir"
        fi
        # Convert to Windows path style
        install_dir=$(echo "$install_dir" | sed 's/\//\\/g')
        echo "Installation directory set to: $install_dir"

        # Set the SCOOP environment variable to the selected directory in PowerShell
        powershell -Command "[Environment]::SetEnvironmentVariable('SCOOP', '$install_dir', [System.EnvironmentVariableTarget]::User)"
    else
        echo -e "${YELLOW}No directory selected. Using default installation paths for each software.${NC}"
        exit 1
    fi

    echo "Installing Scoop..."
    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh'))"
    export PATH="$install_dir/shims:$PATH"
	# Configure Scoop to use the selected installation directory
	scoop config root "$install_dir"
else
    echo -e "${YELLOW}Scoop is already installed.${NC}"
    scoop_dir=$(powershell -Command "[Environment]::GetEnvironmentVariable('SCOOP', [System.EnvironmentVariableTarget]::User)")
    echo -e "${YELLOW}Installation directory is set to: $scoop_dir. Uninstall scoop to change that.${NC}"
fi

# Function to install software with Scoop
install_software() {
    local software=$1
    if ! scoop list | grep -q "^$software "; then
        read -p "Do you want to install $software? (y/n): " choice
        case "$choice" in 
            y|Y )
                echo -e "${YELLOW}Installing $software...${NC}"
                scoop install $software
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}$software installed successfully.${NC}"
                else
                    echo -e "${RED}Failed to install $software.${NC}"
                fi
                ;;
            * )
                echo -e "${YELLOW}Skipping installation of $software.${NC}"
                ;;
        esac
    else
        echo "$software is already installed."
    fi
}


# Function to add bucket if it doesn't exist

add_bucket_if_not_exists() {
    local bucket_name=$1
    if ! scoop bucket list | grep -q "$bucket_name"; then
        echo -e "${YELLOW}Adding bucket: $bucket_name${NC}"
        scoop bucket add "$bucket_name"
    fi
}



# Add necessary buckets
echo "Checking bucket installations..."
add_bucket_if_not_exists extras
add_bucket_if_not_exists versions
add_bucket_if_not_exists java
add_bucket_if_not_exists nerd-fonts

# Core development tools
install_software git
install_software mingw
install_software cmake
install_software make
install_software ninja
install_software gdb
install_software llvm

# Package managers and build tools
install_software vcpkg
install_software conan

# Programming languages and runtimes
install_software python
install_software nodejs

# IDEs and text editors
install_software vscode
install_software notepadplusplus

# Version control and CLI tools
install_software gh

# Containerization and virtualization
echo -e "${YELLOW}Docker installation might require manual steps. Please visit https://docs.docker.com/desktop/windows/install/ for instructions.${NC}"

# Debugging tools
echo -e "${YELLOW}WinDbg might require manual installation. Please visit https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools for instructions.${NC}"

# Data science and notebooks
install_software jupyter

# Terminal and system utilities
install_software windows-terminal
install_software 7zip

# Browsers
install_software brave

# Media players
install_software vlc

# Archivers
install_software winrar

echo -e "${GREEN}All installations checked!${NC}"

# Keep the window open
read -p "Press [Enter] to exit."
