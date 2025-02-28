plugins=(git zsh-completions zsh-autosuggestions venv-info virtualenv)

ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
  mkdir "$ZSH_CACHE_DIR"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="shibby"

source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/themes/shibby.zsh-theme"

# export GPG Signing key(?)
export GPG_TTY=$(tty)

# editor environment
export EDITOR='nvim'

# Pacman
alias pacman="sudo pacman"

# Virtual Environment specified python version needs to be installed on system
makevenv() {
  python$1 -m venv .venv
}

alias .venv="source .venv/bin/activate"

# cht.sh
alias languages="nvim $HOME/.tmux/tmux-cht-languages"
alias commands="nvim $HOME/.tmux/tmux-cht-command"

# tmux config
alias tmuxconf="nvim $HOME/.tmux.conf"

# tmux standard sessions
alias tmux="tmux -2"
alias tmux-main="tmux -2 new -s main"

# shell config shortcuts
alias zshrc="nvim $HOME/.zshrc"
alias bashrc="nvim $HOME/.bashrc"

# C++
function grooster() {
    local filename=$1
    local base_name="${filename%.*}"
    [[ -f "./${base_name}" ]] && rm ${base_name}
    gcc -g -lstdc++ -std=c++20 -pedantic "${base_name}.cpp" -o ./${base_name} -time
    timeout 2 ./${base_name}
}

function clrooster() {
    local filename=$1
    local base_name="${filename%.*}"
    [[ -f "./${base_name}" ]] && rm ${base_name}
    clang++ -g -lstdc++ -std=c++20 -pedantic "${base_name}.cpp" -o ./${base_name}
    timeout 2 ./${base_name}
}

# other
alias lsb="ls -latrh"
alias lf="ls -lhF"
alias la="ls -alhF"
alias h="history|grep"
alias c="clear"
alias p=pwd
alias help="bat ~/.zshrc | less"

# cd
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias ........="cd ../../../.."

# functionalities
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#16161E"
bg_highlight="#292E42"
purple="#B388FF"
blue="#0A64AC"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

tmux_open_widget() {
  $HOME/.scripts/tmux-open.sh
  zle reset-prompt
}
zle -N tmux_open_widget

export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

# Then bind your tmux-open widget to a different key
bindkey '^Y' tmux_open_widget  # Example: Using Ctrl+Y instead

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source $HOME/.config/fzf-git/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview "eza --tree --color=always {} | head -200"                        "$@" ;;
    rm)           fzf --preview "head -200; else bat -n --color= always --line-range :500 {}; fi" "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"                                                "$@" ;;
    ssh)          fzf --preview "dig {}"                                                          "$@" ;;
    # docker is WIP
    docker)       fzf --preview "docker inspect {}"                                               "$@" ;;
    kill)         fzf --preview "ps -f -p {}"                                                     "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"                                       "$@" ;;
  esac
}

# zsh plugins config
bindkey '^f' autosuggest-accept

# ----- Bat (better cat) -----
export BAT_THEME=OneHalfDark

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- TheFuck -----
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init --cmd cd zsh)"

