PROMPT="%{$reset_color%}%{$fg[red]%}%% %"
RPROMPT='$(git_prompt_info)  '"%{$terminfo[bold]%}%2~/%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="( "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="* )"
ZSH_THEME_GIT_PROMPT_CLEAN=" )"
