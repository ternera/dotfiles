#!/bin/bash
set -euo pipefail

# run homebrew natively
if [[ "$(sysctl -n hw.optional.arm64 2>/dev/null || echo 0)" == 1 && "$(uname -m)" != arm64 ]]; then
  exec arch -arm64 /bin/bash "$0" "$@"
fi

cd "$(dirname "$0")"
DOTFILES_DIR="$PWD"

LOG_DIR="$HOME/.local/logs"
LOG_FILE="$LOG_DIR/dotfiles_install_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*"; }

link() {
  mkdir -p "$(dirname "$2")"
  if [[ -e "$2" && ! -L "$2" ]]; then mv "$2" "$2.bak"; fi
  ln -sfn "$1" "$2"
}

log "Starting installation ($(uname -m))..."

sudo -v
(while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null) &
trap 'kill $! 2>/dev/null || true' EXIT

log "Installing Homebrew..."
if [[ "$(uname -m)" == arm64 ]]; then BREW_PREFIX=/opt/homebrew; else BREW_PREFIX=/usr/local; fi
if [[ ! -x "$BREW_PREFIX/bin/brew" ]]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$("$BREW_PREFIX/bin/brew" shellenv)"
if [[ "$BREW_PREFIX" == /opt/homebrew && -x /usr/local/bin/brew ]]; then
  log "WARNING: an Intel Homebrew exists at /usr/local. Uninstall it so it can't shadow $BREW_PREFIX."
fi

log "Installing Homebrew packages..."
brew bundle --file=install/Brewfile || log "Some formulae failed to install."
brew bundle --file=install/Caskfile || log "Some casks failed to install."

log "Linking dotfiles..."
[[ "$DOTFILES_DIR" == "$HOME/.dotfiles" ]] || link "$DOTFILES_DIR" "$HOME/.dotfiles"
link "$DOTFILES_DIR/bin" "$HOME/bin"
find bin -type f ! -name '*.*' -exec chmod +x {} +
for dir in fish git kitty nvim; do
  link "$DOTFILES_DIR/config/$dir" "$HOME/.config/$dir"
done
link "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/config/zsh/.aliases" "$HOME/.aliases"
link "$DOTFILES_DIR/config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

log "Installing VS Code extensions..."
CODE_BIN="$(command -v code || true)"
VSCODE_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -z "$CODE_BIN" && -x "$VSCODE_CLI" ]]; then CODE_BIN="$VSCODE_CLI"; fi
if [[ -n "$CODE_BIN" ]]; then
  while read -r extension || [[ -n "$extension" ]]; do
    [[ -n "$extension" ]] && { "$CODE_BIN" --install-extension "$extension" --force || log "Failed: $extension"; }
  done < install/Codefile
else
  log "VS Code not found, skipping extensions."
fi

log "Setting default applications..."
duti -v install/duti

log "Configuring hosts file..."
if ! grep -q "screen.studio" /etc/hosts; then
  echo "127.0.0.1 screen.studio" | sudo tee -a /etc/hosts >/dev/null
fi

log "Configuring macOS defaults..."
/bin/bash macos/defaults.sh
/bin/bash macos/defaults-chrome.sh

# familyshield dns
log "Configuring DNS (OpenDNS FamilyShield)..."
for service in "Wi-Fi" "Ethernet"; do
  if networksetup -listallnetworkservices | grep -qx "$service"; then
    sudo networksetup -setdnsservers "$service" 208.67.222.123 208.67.220.123
  fi
done

log "Installation complete! Log saved to: $LOG_FILE"
