#!/bin/bash

# Ensure script is run with sudo privileges and keep sudo alive
ensure_sudo() {
    echo "Checking sudo privileges..."
    if ! sudo -v; then
        echo "Failed to obtain sudo privileges. Please run script again."
        exit 1
    fi
    
    # Keep sudo alive in the background
    (while true; do 
        sudo -n true
        sleep 50
        kill -0 "$$" || exit
    done 2>/dev/null) &
    
    SUDO_KEEP_ALIVE_PID=$!
    trap 'kill $SUDO_KEEP_ALIVE_PID' EXIT
}

# Call ensure_sudo before any other operations
ensure_sudo

# Create timestamp function
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Create log directory and file
LOG_DIR="$HOME/.local/logs"
LOG_FILE="$LOG_DIR/dotfiles_install_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

echo "$(timestamp) Starting installation..." | tee -a "$LOG_FILE"
#set -x

echo "$(timestamp) Setting up bin directory..." | tee -a "$LOG_FILE"
mkdir ~/bin 2>&1 | tee -a "$LOG_FILE"
cp -R bin/ ~/bin 2>&1 | tee -a "$LOG_FILE"
chmod +x ~/bin/* 2>&1 | tee -a "$LOG_FILE"
sudo cp install/addtopath /etc/paths.d 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Configuring stow..." | tee -a "$LOG_FILE"
sudo -u ternera brew install stow 2>&1 | tee -a "$LOG_FILE"
mkdir -p $HOME/.config 2>&1 | tee -a "$LOG_FILE"
stow -t $HOME runcom --adopt 2>&1 | tee -a "$LOG_FILE"
stow -t $HOME/.config config --adopt 2>&1 | tee -a "$LOG_FILE"
mkdir -p $HOME/.local/runtime 2>&1 | tee -a "$LOG_FILE"
chmod 700 $HOME/.local/runtime 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Cleaning previous stow configurations..." | tee -a "$LOG_FILE"
stow --delete -t $HOME runcom --adopt 2>&1 | tee -a "$LOG_FILE"
stow --delete -t $HOME/.config config --adopt 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Setting up Kitty terminal..." | tee -a "$LOG_FILE"
cp config/kitty/* ~/.config/kitty/ 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Copying zsh aliases..." | tee -a "$LOG_FILE"
cp config/zsh/.aliases $HOME/.aliases 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Copying zsh configuration..." | tee -a "$LOG_FILE"
cp -f config/zsh/.zshrc $HOME/.zshrc 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Installing Homebrew..." | tee -a "$LOG_FILE"
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Installing git and node..." | tee -a "$LOG_FILE"
sudo -u ternera brew install git git-extras 2>&1 | tee -a "$LOG_FILE"
sudo n install lts 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Installing Homebrew packages..." | tee -a "$LOG_FILE"
sudo -u ternera brew bundle --file=install/Brewfile || true 2>&1 | tee -a "$LOG_FILE"
sudo -u ternera brew bundle --file=install/Caskfile || true 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Installing VSCode extensions..." | tee -a "$LOG_FILE"
cat install/Codefile | while read -r extension || [[ -n $extension ]]; do
  code --install-extension "$extension" --force 2>&1 | tee -a "$LOG_FILE"
done

echo "$(timestamp) Installing latest Ruby with rbenv..." | tee -a "$LOG_FILE"
sudo -u ternera rbenv install $(rbenv install -l | grep -v - | tail -1) 2>&1 | tee -a "$LOG_FILE"
LATEST_RUBY=$(rbenv install -l | grep -v - | tail -1)
sudo -u ternera rbenv global $LATEST_RUBY 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Configuring Kitty to use the latest Ruby version..." | tee -a "$LOG_FILE"
echo "export PATH=\"$HOME/.rbenv/versions/$LATEST_RUBY/bin:\$PATH\"" >> ~/.config/kitty/kitty.conf

#echo "$(timestamp) Installing gems from Gemfile..." | tee -a "$LOG_FILE"
#if [ -f Gemfile ]; then
#  sudo -u ternera bundle install --gemfile=Gemfile 2>&1 | tee -a "$LOG_FILE"
#else
#  echo "$(timestamp) No Gemfile found. Skipping gem installation." | tee -a "$LOG_FILE"
#fi

#echo "$(timestamp) Installing global NPM packages..." | tee -a "$LOG_FILE"
#/Users/ternera/.n/bin/npm install --force --location global install/npmfile --verbose 2>&1 | tee -a "$LOG_FILE"

# Skip Rust, I think.
#cargo install install/Rustfile 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Setting default applications..." | tee -a "$LOG_FILE"
duti -v install/duti 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Configuring hosts file..." | tee -a "$LOG_FILE"
echo "127.0.0.1 screen.studio" | sudo tee -a /etc/hosts 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Configuring MacOS defaults..." | tee -a "$LOG_FILE"
/bin/bash macos/defaults.sh 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Configuring Chrome defaults..." | tee -a "$LOG_FILE"
/bin/bash macos/defaults-chrome.sh 2>&1 | tee -a "$LOG_FILE"

echo "$(timestamp) Installation complete! Log saved to: $LOG_FILE" | tee -a "$LOG_FILE"
