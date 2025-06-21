Installation() {
  Installing_Message $1
  sudo pacman -S $2
}

Install_Dotnet() {
  Installing_Message Dotnet
  curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
  chmod +rx dotnet-install.sh
  ./dotnet-install.sh --version latest
}

Installing_Message() {
  echo "Installing $1 ..."
}

echo "####  App Installion  ####"

Installation "git" git

echo "Install Neovim Config ..."
git clone https://github.com/OpyrusDevOp/Neovim-Config.git ~/.config/nvim

echo "Installing Yay ..."
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

Installation "Terminal" kitty

Installation "Neovim" neovim

Installation "Shell" fish

Installation "Browser" firefox

Installation "AppLauncher" fuzzel

Installation "Dock" waybar

Installation "Wallpaper daemon" hyprpaper

Installation "File Manager" nautilus

Installation "Terminal Session Manager" zellij

Installation "Discord" discord

Installation "Obsidian" obsidian

Installation "Libre Office" libreoffice

Installation "Unzip" unzip

Installation "Keychain" keychain

Installation "Brightness Control" brightnessctl

Install_Dotnet

Installing_Message Bun
curl -fsSL https://bun.sh/install | bash

Installing_Message "Nvm"
yay -S nvm

echo "#### Configuration ####"
mkdir -p ~/{Documents, Musics, Pictures, Projects/{Softwares, Games}, Videos}
mkdir -p /usr/local/share/fonts/{otf,ttf}
unzip ./JetBrainsMono.zip -d /usr/local/share/fonts/ttf/
