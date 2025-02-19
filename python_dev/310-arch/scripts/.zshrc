ZSH="$HOME/.oh-my-zsh/"
export ZSH="$HOME/.oh-my-zsh/"
ZSH_THEME="shibby"
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
)

ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
  mkdir "$ZSH_CACHE_DIR"
fi

source "$ZSH"/oh-my-zsh.sh

# PATH settings
path+=("$HOME/.local/bin/")
export PATH

# editor environment
export EDITOR='nvim'

# Virtual Environment
alias makevenv="sudo python3 -m venv .venv"
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

# other
alias lsb="ls -latrh"
alias lf="ls -lF"
alias la="ls -alF"
alias h="history|grep"
alias c="clear" # I know about ctrl l etc.
alias p=pwd
alias logout="killall -KILL -u $USER"
alias help="cat ~/.zshrc | less"

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
    kill)         fzf --preview "ps -f -p {}"                                                     "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"                                       "$@" ;;
  esac
}

# zsh plugins config
bindkey '^f' autosuggest-accept

# ----- Bat (better cat) -----
export BAT_THEME=GitHub

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- TheFuck -----
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init --cmd cd zsh)"

