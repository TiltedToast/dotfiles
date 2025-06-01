setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

export ZSH="$HOME/.zsh"

[[ -r ~/3rd-party/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/3rd-party/znap
source ~/3rd-party/znap/znap.zsh

zstyle ':znap:*' repos-dir ~/3rd-party/znap-plugins

znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions

znap install zsh-users/zsh-completions

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
znap eval omp "oh-my-posh init zsh --config $HOME/powerline_custom.omp.json" &> /dev/null
znap eval zoxide "zoxide init --cmd cd zsh"
znap eval atuin "atuin init --disable-up-arrow zsh"

source $ZSH/aliases.sh
source $ZSH/hooks.sh


if [[ ! "$fpath" =~ .*"$ZSH/completions".* ]]; then
  fpath=(~/.zsh/completions $fpath)
fi

autoload -Uz compinit && compinit

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable completions with sudo
zstyle ':completion::complete:*' gain-privileges 1

# Close shell with ctrl+d regardless of if the command line is empty or not
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# Path to your oh-my-zsh installation.

# Fix paste being super slow
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        source $ZSH/ubuntu_specific.sh
    elif [[ "$ID" == "arch" ]]; then
        source $ZSH/arch_specific.sh
    elif [[ "$ID" == "endeavouros" ]]; then
        source $ZSH/arch_specific.sh
        source $ZSH/endeavouros_specific.sh
    elif [[ "$ID" == "nixos" ]]; then
        source $ZSH/nixos_specific.sh
    fi
fi

gfomo() {
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4)
    git fetch origin $main_branch &&
    git merge origin/$main_branch;
}

watch_mode() {
    fd -t file --search-path $1 | entr $(which $(ps -p $$ -o comm=)) -c $2
}

function cargo-new {
    cargo new --bin $1
    cd $1
    cargo add anyhow
    code .
}

function cargo-new-tokio {
    cargo new --bin $1
    cd $1
    cargo add tokio --features="full"
    cargo add anyhow
    code .
}

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word  # Ctrl + Backspace
bindkey '^[[3;5~' kill-word      # Ctrl + Delete
bindkey "^[[3~"  delete-char


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/mambaforge/etc/profile.d/conda.sh" ]; then
        . "$HOME/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


if [ -n "$WSL_INTEROP" ]; then
    source $ZSH/wsl_specific.sh
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# bun completions
[ -s "/home/tim/.bun/_bun" ] && source "/home/tim/.bun/_bun"
export PATH="$PATH:/home/tim/.modular/bin"
