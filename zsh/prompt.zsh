# symlink to zpresto/modules/prompt/functions/prompt_haug_setup
function prompt_haug_precmd {
  git-info
}

function prompt_haug_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook precmd prompt_haug_precmd

  # Set git-info parameters.
  zstyle ':prezto:module:git:info' verbose 'yes'
  zstyle ':prezto:module:git:info:branch' format '%F{green}%b%f'
  zstyle ':prezto:module:git:info:clean' format ' %F{green}clean%f'
  zstyle ':prezto:module:git:info:dirty' format ' %F{red}dirty%f'
  zstyle ':prezto:module:git:info:keys' format \
    'prompt' ' %F{green}(%f$(coalesce "%b" "%p" "%c")${git_info[rprompt]}%s%F{green})%f' \
    'rprompt' '%C%D'

  # Define prompts.
  PROMPT='%~${(e)git_info[prompt]}$ '
  RPROMPT=''
}

prompt_haug_setup "$@"
