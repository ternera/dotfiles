# Welcome to my dotfiles!

These are customization files for my system. You are free to use them, but please take a look at them and confirm that you understand how they work first!

## Installation:
```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/webpro/dotfiles/master/remote-install.sh"```

or if git is installed:

```bash
git clone https://github.com/webpro/dotfiles.git ~/.dotfiles```

Run the Makfile.

```bash
cd ~/.dotfiles
make
```

## Post-Installation
- Set your Git credentials:
```bash
git config --global user.name "your name"
git config --global user.email "your@email.com"
git config --global github.user "your-github-username"
```

- Set macOS Dock items and system defaults:
```sh
dot dock
dot macos
```

- Populate this file with tokens (example: export GITHUB_TOKEN=abc):
```bash
touch ~/.dotfiles/system/.exports
```

## Dot Command
```bash
$ dot help
Usage: dot <command>

Commands:
   clean            Clean up caches (brew, cargo, gem, pip)
   dock             Apply macOS Dock settings
   edit             Open dotfiles in IDE ($VISUAL) and Git GUI ($VISUAL_GIT)
   help             This help message
   macos            Apply macOS system defaults
   test             Run tests
   update           Update packages and pkg managers (brew, casks, cargo, pip3, npm, gems, macOS)
```