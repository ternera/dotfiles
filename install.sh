#!/bin/bash

#set -x
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Put my custom scripts in the ~/bin folder and add them to path
mkdir ~/bin
cp -R bin/ ~/bin
chmod +x ~/bin/*
export PATH=".:/Users/ternera/bin:$PATH"

sudo -u ternera brew instal stow
mkdir -p $HOME/.config
stow -t $HOME runcom
stow -t $HOME/.config config
mkdir -p $HOME/.local/runtime
chmod 700 $HOME/.local/runtime

stow --delete -t $HOME runcom
stow --delete -t $HOME/.config config

# Install Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

sudo -u ternera brew install git git-extras
n install lts

sudo -u ternera brew bundle --file=install/Brewfile || true
# UNCOMMENT THE LINE BELOW ONCE EVERYTHING IS WORKING
#sudo -u brew bundle --file=install/Caskfile || true

# Install VSCode extensions
cat install/Codefile | while read extension || [[ -n $extension ]];
do
  code --install-extension $extension --force
done

/Users/ternera/.n/bin/npm install --force --location global install/npmfile --verbose

# Skip Rust, I think.
#cargo install install/Rustfile

duti -v install/duti

#/bin/basg macos/defaults.sh

/bin/bash macos/defaults-chrome.sh

cp /config/kitty/* ~/.config/kitty/kitty.conf