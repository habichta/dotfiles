# dotfiles

## ZSH / Basic

- Install ZSH
- Install NerdFont (Hack Nerd Font)
- Install starship theme
  - `curl -sS https://starship.rs/install.sh | sh`
- Install mise (-> node / python) -> create global python
- Install pipx using pip of global python
- Install virtualenv (pipx)
- Install fzf (git)
- Install ansible (pipx)
- Install docker

## TMUX

- Install tmux (apt)
- Install TPM plugin manager
- copy .tmux.conf
- <prefix> + I to load plugins

## VIM

- Install neovim
  - `https://github.com/neovim/neovim/blob/master/INSTALL.md#appimage-universal-linux-package`

- Symlink .config/nvim
- Symlink .vimrc and .vim
- :PlugInstall
- Create virtualenv in ~/.config/nvim -> check `python_3_host_prog`
  - pip install neovim
  - pip install rope
  - pip install black
  - pip install autoflake
  - pip install pynvim (wilder)
- adapt fzf binary path
- :UpdateRemotePlugins
- :CocSetup
- :checkhealth -> go through issues

## Aider

- Currently requires python 3.12 -> `mise install python@3.12`
- `pipx_install_package` -> `aider-chat` with python 3.12
- setup aider config file

## Essentals (Debian)

- `sudo apt install build-essential`
- Install a GUI tool to allow WSL2 to open e.g. browser window

## CTAGS

- Install universal CTAGS
- use options file (sym link to ~/.ctags.d)
- Requires `autoconf`, `automake`, and `pkg-config` to build
  `sudo apt install autoconf automake pkg-config`

## SSH

- Install ssh-find-agent -> or change .zshrc

## Others

- Install diff-so-fancy
  `https://github.com/aos/dsf-debian`

- Install htop
- Install iotop
- Install nmap
- Install net-tools

# TODO

- Aider conf in secrets
- Tridactyl setup
