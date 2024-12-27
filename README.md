# Welcome to my dotfiles!

These are customization files for my system. You are free to use them, but please take a look at them and confirm that you understand how they work first!

## Installation:
Download the dotfiles.
```bash
curl -Lo dotfiles.zip https://github.com/ternera/dotfiles/archive/refs/heads/main.zip && unzip dotfiles.zip && rm dotfiles.zip
```

or if git is installed:

```bash
git clone https://github.com/ternera/dotfiles.git ~/.dotfiles
```

Run the bash script. A log will be created in `~/.local/logs`.

```bash
cd ~/.dotfiles
chmod +x install.sh
./install.sh   
```

If you run into issues, edit the `install.sh` script and add the following line towards the beginning to troubleshoot:

```bash
set -x
```

## Post-Installation
Set your Git credentials:
```bash
git config --global user.name "your name"
git config --global user.email "your@email.com"
git config --global github.user "your-github-username"
```

Populate this file with tokens (example: export GITHUB_TOKEN=abc):
```bash
touch ~/.dotfiles/system/.exports
```
Check the `documentation/` folder for helpful installation notes.