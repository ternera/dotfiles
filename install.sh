#!/bin/bash

set -x
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Put my custom scripts in the ~/bin folder and add them to path
mkdir ~/bin
cp -R bin/ ~/bin
chmod +x ~/bin/*
#export PATH=".:/Users/ternera/bin:$PATH"
sudo cp install/addtopath /etc/paths.d

sudo -u ternera brew instal stow
mkdir -p $HOME/.config
stow -t $HOME runcom --adopt
stow -t $HOME/.config config --adopt
mkdir -p $HOME/.local/runtime
chmod 700 $HOME/.local/runtime

stow --delete -t $HOME runcom --adopt
stow --delete -t $HOME/.config config --adopt

# Install Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

sudo -u ternera brew install git git-extras
sudo n install lts

sudo -u ternera brew bundle --file=install/Brewfile || true
# UNCOMMENT THE LINE BELOW ONCE EVERYTHING IS WORKING
#sudo -u brew bundle --file=install/Caskfile || true

# Install VSCode extensions
cat install/Codefile | while read -r extension || [[ -n $extension ]]; do
  code --install-extension "$extension" --force
done

#/Users/ternera/.n/bin/npm install --force --location global install/npmfile --verbose

# Skip Rust, I think.
#cargo install install/Rustfile

# Use duti to specify default applications for file extensions
duti -v install/duti

# Set MacOS Defaults
/bin/bash macos/defaults.sh

# Set Google Chrome Defaults
/bin/bash macos/defaults-chrome.sh

# Setup Kitty
cp config/kitty/* ~/.config/kitty/