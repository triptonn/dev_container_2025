#!/usr/bin/env bash

# Add error handling for required commands
for cmd in tmux fzf nvim zathura; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

#if [[ $# -eq 1 ]]; then
#    selected=$1
#else
selected=$(find . \( -type f -o -type d \) -not -path '*/\.git/*' 2>/dev/null | fzf)
#fi

if [[ -z "$selected" ]]; then
    echo "No selection made. Exiting..."
    exit 0
fi

selected_name=$(basename "$selected" | tr . _ | tr ' ' _)

create_session() {
    if [ -d "$selected" ]; then
        tmux new-session -d -s "$selected_name" -c "$selected"
    elif [ -f "$selected" ]; then
        case "$selected_name" in
            *.pdf)
                echo "Opening zathura $(basename "$selected" | tr _ .)"
                tmux new-session -d -s "$selected_name" -c  "zathura" "$(dirname "$selected")" "$(basename "$selected" | tr _ .)"
                ;;
            *.cc|*.c|*.cpp|*.dart|*.hpp|*.sh|*.h|*.lua|*.py)
                echo "Opening nvim $(basename "$selected" | tr _ .)"
                tmux new-session -d -s "$selected_name" -c "nvim" "$(dirname "$selected")" "$(basename "$selected" | tr _ .)"
                ;;
            *)
                echo "Opening $(dirname "$selected")"
                tmux new-session -d -s "$selected_name" -c "$(dirname "$selected")"
                ;;
        esac
    else
        echo "Neither file nor directory... Exiting"
        return 1
    fi
}

attach_session() {
    if [ -d "$selected" ]; then
        tmux attach-session -t "${selected_name}"
    elif [ -f "$selected" ]; then
        case "$selected_name" in
            *pdf)
                echo "Opening zathura $(basename "$selected" | tr _ .)"
                tmux attach-session -t "${selected_name}" -f -s "${selected_name}" -c "zathura" "$(dirname "$selected")" "$(basename "$selected" | tr _ .)"
                ;;
            *cc|*c|*cpp|*dart|*hpp|*sh|*h|*lua|*py)
                echo "Opening nvim $(basename "$selected" | tr _ .)"
                tmux attach-session -t "${selected_name}" -f -s "${selected_name}" -c "nvim" "$(dirname "$selected")" "$(basename "$selected" | tr _ .)"
                ;;
            *)
                echo "Opening $(dirname "$selected")"
                tmux attach-session -t "${selected_name}" -f -s "${selected_name}" -c "$(dirname "$selected")"
                ;;
        esac
    else
        echo "Neither file nor directory... Exiting"
        return 1
    fi
}

if [[ -z $TMUX ]]; then
    # Not inside tmux, launch a new session or attach to existing one
    if ! tmux has-session -t="${selected_name}" 2>/dev/null; then
        create_session || exit 1
        tmux attach-session -t "${selected_name}"
    else
        tmux attach-session -t "${selected_name}"
    fi
else
    # Inside tmux: create detached session and switch client
    if ! tmux has-session -t="${selected_name}" 2>/dev/null; then
        create_session || exit 1
    fi
    tmux switch-client -t "${selected_name}"
fi
