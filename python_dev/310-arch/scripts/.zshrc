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

# Shell stuff
alias update="yay -Syu"

# Virtual Environment specified python version needs to be installed on system
makevenv() {
  python$1 -m venv .venv
}

alias .venv="source .venv/bin/activate"

# Display settings profiles
alias threeMonitors="autorandr -l three_monitor_home"

# Mounting
alias mountbackup="sudo mount -o rw,user,uid=1000,umask=007,exec --onlyonce PARTUUID=e8900690-03 $HOME/BackupHDD"
alias mountplaystation="sudo mount -o rw,user,exec --onlyonce PARTUUID=e8900690-02 $HOME/PlaystationHDD"
alias mountdata="sudo mount -o rw,user,exec --onlyonce UUID=963b910b-11eb-48da-89f1-a96837e08d65 $HOME/DataSSD"
alias mountdataf="sudo mount -o rw,user,exec --onlyonce UUID=371d8a28-bcbc-4efb-a715-3884851826dd $HOME/DataNVME"
alias mountwindows="sudo mount -o rw,user,uid=1000,umask=007,exec --onlyonce UUID=0F76318F6A366E58 $HOME/WindowsSSD"

alias umountbackup="sudo umount $HOME/BackupHDD"
alias umountplaystation="sudo umount $HOME/PlaystationHDD"
alias umountdata="sudo umount $HOME/DataSSD"
alias umountdataf="sudo umount $HOME/DataNVME"
alias umountwindows="sudo umount $HOME/WindowsSSD"

alias mountall="mountbackup && mountplaystation && mountdata && mountdataf && mountwindows"
alias umountall="umountbackup && umountplaystation && umountdata && umountdataf && umountwindows"

# AUR - yay
alias yeet="yay -Rn"
alias yeeet="yay -Rns"
alias yeet_useless="yay -Rns $(yay -Qtdq)"

# Snipping tool escrotum
alias sp="escrotum -s -C"
alias ss="escrotum -s"

# Shortcuts for VSCode
alias scode="sudo code --no-sandbox"

# docker
alias da="docker attach"
alias db="docker build"

# cht.sh
alias languages="nvim $HOME/.dotfiles/tmux/.tmux/tmux-cht-languages"
alias commands="nvim $HOME/.dotfiles/tmux/.tmux/tmux-cht-command"

# tmux config
alias tmuxconf="nvim $HOME/.dotfiles/tmux/.tmux.conf"

# tmux standard sessions
alias tmux="tmux -2"
alias tmux-left="tmux -2 new -s leftyLeft"
alias tmux-main="tmux -2 new -s main"
alias tmux-right="tmux -2 new -s rightyRight"

# i3 and Polybar config shortcut
alias i3conf="nvim $HOME/.dotfiles/i3/.config/i3/config"
alias polybarconf="nvim $HOME/.dotfiles/polybar/.config/polybar/config.ini"

# shell config shortcuts
alias zshrc="nvim $HOME/.dotfiles/zsh/.zshrc"
alias bashrc="nvim $HOME/.dotfiles/bash/.bashrc"

# bluetooth
alias kh="systemctl start bluetooth.service; sudo bluetoothctl connect 00:1B:66:06:01:FF"

# ssh to pi
alias pi="ssh quacksalber@192.168.178.39"

# sound
alias sd="pavucontrol"
alias sdmin="xdotool search --class pavucontrol windowunmap"
alias sdmax="xdotool search --class pavucontrol windowmap"

# droidcam
alias dcam="droidcam -dev=/dev/video0 -size=1280x720 &"

# Huion Tablet
alias tablet="/usr/lib/huiontablet/huiontablet.sh &"
alias huionmin="xdotool search --class huiontablet windowunmap"
alias huionmax="xdotool search --class huiontablet windowmap"

# Obsidian
alias obsidian="sudo obsidian --no-sandbox"

# git
alias g="git"
alias gad="git add --all"
alias gcm="git commit -m"
alias gcms="git commit -S -m"
alias gph="git push"
alias gpl="git pull"
alias gcl="git clone"
alias gin="git init"

alias gst="git status"
alias glg="git log -n 5"
alias glgr="git reflog"
alias gdf="git diff"

alias gbr="git branch"
alias gsw="git switch"
alias gch="git checkout"
alias gra="git remote add origin git@github.com:"
alias grs="git remote set-url origin git@github.com:"

# other
alias lsb="ls -latrh"
alias lf="ls -lF"
alias la="ls -alF"
alias h="history|grep"
alias c="clear"
alias p=pwd
alias logout="killall -KILL -u $USER"
alias files="dolphin"
alias files.="dolphin ."
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

