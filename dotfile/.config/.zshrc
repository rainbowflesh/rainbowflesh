#!/bin/zsh
echo $fg[red] "Adventure, awaist! Hazaaa!"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ime
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# Compilation flags
export RUST_LOG="debug"
export PATH=$PATH:~/.opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin:/home/rainbow/App/swww/target/release
export ARCH=arm64
export CROSS_COMPILE=/usr/local/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

#export JAVA_HOME='/home/rainbow/App/android-studio/jbr/'
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk-amd64/'
export ANDROID_HOME="$HOME/Android/Sdk"
export NDK_HOME="$ANDROID_HOME/ndk/25.0.8775105/"

# Tools config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffd700,bold,underline"
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --preview-window '~3''
export _ZO_ECHO=1

# Setup oh-my-zsh
ZSH_THEME="random"

export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export LLVM_CONFIG_PATH="/bin/llvm-config"
export ZSH="$HOME/.oh-my-zsh"
export BAT_THEME="Monokai Extended Light"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 2
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

plugins=(
  git zsh-autosuggestions emotty zsh-syntax-highlighting zsh-history-substring-search
  extract adb ansible command-not-found copybuffer copyfile copypath emoji
  fzf git-flow github git-hubflow gitignore
  python rust sudo poetry zoxide zsh-fzf-history-search
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
fpath+=${ZDOTDIR:-~}/.zsh_functions
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(zoxide init zsh)"

# Alias
## Apps
alias ff="firefox-dev"
alias firefox-dev=". /home/rainbow/App/firefox/firefox"
alias lvim="/home/rainbow/.local/bin/lvim"
## basic
alias adbd='adb devices'
alias adbrm='adb shell pm uninstall --user 0'
alias aptd="sudo apt upgrade"
alias apti="sudo apt install"
alias aptr="sudo apt remove"
alias aptra="sudo apt autoremove"
alias aptu="sudo apt update"
alias cargoe="cargo run --example"
alias cargol="cargo nextest list"
alias cargot="cargo nextest run --no-capture"
alias cd="z"
alias cdi="zi"
alias cpf='cp  $(fzf --preview "cat {} ")'
alias docker='sudo docker'
alias dpkg="sudo dpkg"
alias fcat="fzf --preview 'cat {}'"
alias fd='fzf'
alias fnmod='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'
alias ge='grep'
alias gitcc="git-cz commit"
alias hxf='hx $(fzf --preview "cat {} ")'
alias hyper="/opt/Hyper/hyper"
alias ime='ibus-daemon -d'
alias kill='kill -9'
alias kitty="~/.local/kitty.app/bin/kitty"
alias lzd='lazydocker'
alias minicom='sudo minicom -c on -t xterm'
alias pptest='poetry run pytest -s'
alias rabbitctl='sudo rabbitmqctl'
alias rk='sudo rkdeveloptool'
alias ssh='TERM="xterm-256color" kitty +kitten ssh'
alias startrabbit='systemctl start rabbitmq-server'
alias stoprabbit='systemctl stop rabbitmq-server'
alias suvi='sudo lvim'
alias tar='extract'
alias tlp-stat='sudo tlp-stat'
alias tlp='sudo tlp'
alias venv='. .venv/bin/activate'
alias vim='hx'
alias vimf='vim $(fzf --preview "cat {} ")'
## fuzzy
alias cd..="cd .."
alias dpgk="dpkg"
alias sudp="sudo"
## ignored
alias cat=" bat --theme gruvbox-light --style=plain"
alias ckear=" clear"
alias cl=" clear"
alias cle=" clear"
alias clea=" clear"
alias clean=" clear"
alias clear=" clear"
alias clearn=" clear"
alias exit=" exit"
alias ipa=" ip a"
alias ipaddr=' ip addr'
alias l=" exa -a --icons"
alias la=" l -lhT -L 2"
alias ls=" l -lh"
alias ps=" ps aufx"
alias rl=" l"

# fzf
export FZF_DEFAULT_OPTS="
    --color=fg:#797593,bg:#faf4ed,hl:#d7827e
    --color=fg+:#575279,bg+:#f2e9e1,hl+:#d7827e
    --color=border:#dfdad9,header:#286983,gutter:#faf4ed
    --color=spinner:#ea9d34,info:#56949f,separator:#dfdad9
    --color=pointer:#907aa9,marker:#b4637a,prompt:#797593"

# vkff
export VKFFT_ROOT=~/App/VkFFT

# pnpm
export PNPM_HOME="/home/rainbow/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# sqlite
export PATH=$PATH:/home/rainbow/App/sqlite-tools-linux-x86-3390400/

# go
export PATH=$PATH:/usr/local/go/bin

export RBENV_SHELL=zsh

# py
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ruby
eval export PATH="/home/rainbow/.rbenv/shims:${PATH}"

command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash | shell)
    eval "$(rbenv "sh-$command" "$@")"
    ;;
  *)
    command rbenv "$command" "$@"
    ;;
  esac
}

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

export TERM=kitty
