eval "$(/opt/homebrew/bin/brew shellenv)"

export DOTFILES_DIR="$HOME/.dotfiles"
export PATH="$HOME/bin:$PATH"
export EDITOR="code --wait"
export VISUAL="code"

source "$HOME/.aliases"
[ -f "$DOTFILES_DIR/system/.exports" ] && source "$DOTFILES_DIR/system/.exports"
