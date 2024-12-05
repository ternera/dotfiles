#!/bin/bash

sudo -v
#sudo -n true

# Put my custom scripts in the ~/bin folder and add them to path
mkdir ~/bin
cp -R bin/ ~/bin
chmod +x ~/bin/*
export PATH=".:/Users/ternera/bin:$PATH"

brew instal stow
mkdir -p $HOME/.config
stow -t $HOME runcom
stow -t $HOME/.config config
mkdir -p $HOME/.local/runtime
chmod 700 $HOME/.local/runtime

stow --delete -t $HOME runcom
stow --delete -t $HOME/.config config

# Install Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

brew install git git-extras
sudo n install lts

brew bundle --file=install/Brewfile || true
# UNCOMMENT THE LINE BELOW ONCE EVERYTHING IS WORKING
#brew bundle --file=install/Caskfile || true

# Install VSCode extensions
cat install/Codefile | while read extension || [[ -n $extension ]];
do
  code --install-extension $extension --force
done

sudo npm install --force --location global install/npmfile --verbose
cargo install install/Rustfile

#duti -v install/duti

#source macos/defaults.sh