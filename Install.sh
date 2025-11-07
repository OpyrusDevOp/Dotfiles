#!/bin/bash

#==============================================================================
# Arch Linux System Setup Script
# Description: Automated installation and configuration script
#==============================================================================

set -e  # Exit on error

#------------------------------------------------------------------------------
# Configuration Variables
#------------------------------------------------------------------------------
readonly DOTNET_INSTALL_URL="https://dot.net/v1/dotnet-install.sh"
readonly BUN_INSTALL_URL="https://bun.sh/install"
readonly NEOVIM_CONFIG_REPO="https://github.com/OpyrusDevOp/Neovim-Config.git"
readonly YAY_REPO="https://aur.archlinux.org/yay.git"

#------------------------------------------------------------------------------
# Utility Functions
#------------------------------------------------------------------------------

# Print colored messages
print_header() {
    echo -e "\n\033[1;34m#### $1 ####\033[0m"
}

print_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

# Display installation message
display_install_msg() {
    print_info "Installing $1..."
}

#------------------------------------------------------------------------------
# Installation Functions
#------------------------------------------------------------------------------

# Install package using pacman
install_pacman() {
    local description="$1"
    local package="$2"
    
    display_install_msg "$description"
    sudo pacman -S --noconfirm --needed "$package" || {
        print_error "Failed to install $description"
        return 1
    }
}

# Install package using yay (AUR helper)
install_yay() {
    local description="$1"
    local package="$2"
    
    display_install_msg "$description"
    yay -S --noconfirm --needed "$package" || {
        print_error "Failed to install $description"
        return 1
    }
}

# Install .NET SDK
install_dotnet() {
    display_install_msg "Dotnet SDK"
    
    local install_script="dotnet-install.sh"
    curl -fsSL "$DOTNET_INSTALL_URL" -o "$install_script"
    chmod +x "$install_script"
    ./"$install_script" --version latest
    rm -f "$install_script"
}

# Install Bun runtime
install_bun() {
    display_install_msg "Bun Runtime"
    curl -fsSL "$BUN_INSTALL_URL" | bash
}

# Setup Neovim configuration
setup_neovim_config() {
    print_info "Setting up Neovim configuration..."
    
    local nvim_config_dir="$HOME/.config/nvim"
    
    if [[ -d "$nvim_config_dir" ]]; then
        print_info "Backing up existing Neovim config..."
        mv "$nvim_config_dir" "${nvim_config_dir}.backup.$(date +%s)"
    fi
    
    git clone "$NEOVIM_CONFIG_REPO" "$nvim_config_dir"
}

# Install Yay AUR helper
install_yay_helper() {
    print_info "Installing Yay AUR helper..."
    
    # Install dependencies
    sudo pacman -S --noconfirm --needed git base-devel
    
    # Clone and build yay
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git clone "$YAY_REPO"
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf "$temp_dir"
}

#------------------------------------------------------------------------------
# Main Installation Sections
#------------------------------------------------------------------------------

# Update system
update_system() {
    print_header "System Update"
    sudo pacman -Syu --noconfirm
}

# Install all packages
install_packages() {
    print_header "Package Installation"
    
    # Core tools
    install_pacman "Git" "git"
    
    # Setup Neovim early
    setup_neovim_config
    
    # Install AUR helper
    install_yay_helper
    
    # Terminal & Shell
    install_pacman "Terminal (Kitty)" "kitty"
    install_pacman "Neovim" "neovim"
    install_pacman "Fish Shell" "fish"
    
    # Browsers & Applications
    install_yay "Zen Browser" "zen-browser-bin"
    
    # Hyprland ecosystem
    install_pacman "Fuzzel Launcher" "fuzzel"
    install_pacman "EWW Widget Manager" "eww"
    install_pacman "Hyprpaper" "hyprpaper"
    install_pacman "SWWW Wallpaper Daemon" "swww"
    install_pacman "Hyprshot Screenshot" "hyprshot"
    install_yay "AGS Hyprpanel" "ags-hyprpanel-git"
    
    # Development tools
    install_yay "JetBrains Toolbox" "jetbrains-toolbox"
    install_yay "NVM (Node Version Manager)" "nvm"
    
    # Utilities
    install_pacman "Fastfetch" "fastfetch"
    install_pacman "FZF Fuzzy Finder" "fzf"
    install_pacman "FD Find Tool" "fd"
    install_pacman "Yazi File Manager" "yazi"
    install_pacman "Zellij Session Manager" "zellij"
    install_pacman "Unzip" "unzip"
    install_pacman "Keychain" "keychain"
    install_pacman "Rsync" "rsync"
    
    # Media & Communication
    install_yay "Jellyfin Media Player" "jellyfin-media-player"
    install_pacman "Discord" "discord"
    install_pacman "Thunderbird Mail" "thunderbird"
    
    # Productivity
    install_pacman "Blender" "blender"
    install_pacman "Obsidian" "obsidian"
    install_pacman "LibreOffice" "libreoffice"
    
    # System control
    install_pacman "Bluetooth (Bluez)" "bluez bluez-utils"
    install_pacman "Brightness Control" "brightnessctl"
    install_pacman "Audio (Wireplumber)" "wireplumber"
    
    # Runtimes
    install_dotnet
    install_bun
}

# Sync configuration files
sync_config_files() {
    local source_config="./config"
    local dest_config="$HOME/.config"
    
    if [[ ! -d "$source_config" ]]; then
        print_error "Config source directory '$source_config' not found"
        return 1
    fi
    
    print_info "Syncing configuration files to $dest_config..."
    
    # Create destination if it doesn't exist
    mkdir -p "$dest_config"
    
    # Sync each subfolder individually, excluding .git directories
    for config_dir in "$source_config"/*/; do
        if [[ -d "$config_dir" ]]; then
            local dir_name
            dir_name=$(basename "$config_dir")
            
            print_info "Syncing $dir_name..."
            rsync -av --delete \
                --exclude='.git' \
                --exclude='.gitignore' \
                --exclude='.gitmodules' \
                "$config_dir" "$dest_config/"
        fi
    done
    
    print_info "Configuration sync completed"
}

# Setup directory structure and configurations
setup_configuration() {
    print_header "System Configuration"
    
    # Create user directories
    print_info "Creating directory structure..."
    mkdir -p "$HOME"/{Documents,Musics,Pictures,Programs,Videos}
    mkdir -p "$HOME/Projects"/{Softwares,Games}
    
    # Setup font directories
    print_info "Setting up font directories..."
    sudo mkdir -p /usr/local/share/fonts/{otf,ttf}
    
    # Install fonts if zip files exist
    if [[ -f "./JetBrainsMono.zip" ]]; then
        print_info "Installing JetBrains Mono fonts..."
        sudo unzip -o ./JetBrainsMono.zip -d /usr/local/share/fonts/ttf/
        fc-cache -f
    else
        print_error "JetBrainsMono.zip not found in current directory"
    fi
    
    # Install SDDM theme if zip exists
    if [[ -f "./catppuccin-mocha.zip" ]]; then
        print_info "Installing Catppuccin SDDM theme..."
        sudo mkdir -p /usr/share/sddm/themes/
        sudo unzip ./catppuccin-mocha.zip /usr/share/sddm/themes/ 
        sudo rsync ./sddm.conf /etc/sddm.conf.d/

    chsh -s /usr/bin/fish
        

#------------------------------------------------------------------------------
# Main Execution
#------------------------------------------------------------------------------

main() {
    print_header "Arch Linux Setup Script"
    print_info "Starting system setup..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        exit 1
    fi
    
    # Execute setup steps
    update_system
    install_packages
    setup_configuration
    
    print_header "Setup Complete"
    print_info "System setup completed successfully!"
    print_info "Please restart your system for all changes to take effect."
    print_info "Don't forget to change your default shell: chsh -s /usr/bin/fish"
}

# Run main function
main "$@"
