# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify correct
bindkey -e
# End of lines configured by zsh-newuser-install

# Add Cargo to path
export PATH="$HOME/.cargo/bin:$PATH"

# Set prompt. git-prompt-info is a custom function.
# We need prompt_subst to evaluate $()-s in the prompt.
setopt prompt_subst
export PROMPT='%~$(git-prompt-info)$ '


# Move the completion cache out of $HOME
compinit -d $ZDOTDIR/.zcompdump

# Aliases
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias ls='exa'

# Git Prompt Stuff
git-dirty() {
  test -z "$(command git status --porcelain --ignore-submodules -unormal)"
  if [[ $? -eq 1 ]]; then
    echo '%F{red}dirty%f'
  else
    echo '%F{green}clean%f'
  fi
}

current-git-branch() {
  git symbolic-ref --short -q HEAD
}

git-prompt-info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  echo " %F{green}($(current-git-branch)%f $(git-dirty)%F{green})%f"
}
