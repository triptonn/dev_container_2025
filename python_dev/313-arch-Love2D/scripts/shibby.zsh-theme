# My custom zsh theme shibby
PROMPT="$color_prefix"'$(virtualenv_info)$(virtualenv_prompt_info) '"$base_left_prompt$color_suffix"
RPROMPT="$color_prefix"' $(git_prompt_info) '"$base_right_prompt$color_suffix"

ZSH_THEME_GIT_PROMPT_PREFIX="( "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="* )"
ZSH_THEME_GIT_PROMPT_CLEAN=" )"

color_prefix="%{$reset_color%}%{$fg[red]%}"
base_left_prompt="%% "
base_right_prompt="%{$terminfo[bold]%}%2~/"
color_suffix="%{$reset_color%}"
