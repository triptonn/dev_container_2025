#!/usr/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) 2025 Nicolas Selig
#
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/node.md
# Maintainer: The VS Code and Codespaces Teams

set -e

INSTALL_ZSH=${1:-"true"}
USERNAME=${2:-"automatic"}
USER_UID=${3:-"automatic"}
USER_GID=${4:-"automatic"}
UPGRADE_PACKAGES=${5:-"true"}

if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=vscode
    fi
elif [ "${USERNAME}" = "none" ]; then
    USERNAME=roo
    USER_UID=0
    USER_GID=0
fi

if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
    package_list="base-devel \
    openssh \
    gnupg \
    curl \
    wget \
    ca-certificates \
    neovim \
    tmux \
    git \
    fd \
    fzf \
    eza \
    zoxide \
    bat \
    ripgrep \
    thefuck \
    yazi \
    go \
    ttf-sourcecodepro-nerd \
    luarocks \
    sudo"

    echo "Packages to verify are installed: ${package_list}"

    # shellcheck disable=SC2086
    pacman -Syu --noconfirm ${package_list} 2> >( grep -v 'some test output' >&2 )

    PACKAGES_ALREADY_INSTALLED="true"
fi

if [ "${UPGRADE_PACKAGES}" = "true" ]; then
    pacman -Syu --noconfirm
fi

if [ "${LOCALE_ALREADY_SET}" != "true" ] && ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    LOCALE_ALREADY_SET="true"
fi

# Create or update a non-root user to match UID/GID.
group_name="${USERNAME}"
if id -u "${USERNAME}" > /dev/null 2>&1; then
    # User exists, update if needed
    if [ "${USER_GID}" != "automatic" ] && [ "$USER_UID" != "$(id -g "$USERNAME")" ]; then
        echo "here 1"
        group_name="$(id -gn "$USERNAME")"
        groupmod --gid "$USER_GID" "${group_name}"
        usermod --uid "$USER_UID" "$USERNAME"
    fi
    if [ "${USER_UID}" != "automatic" ] && [ "$USER_UID" != "$(id -u "$USERNAME")" ]; then
        echo "here 2"
        usermod --uid "$USER_UID" "$USERNAME"
    fi
else
    # Create user
    if [ "${USER_UID}" = "automatic" ] && [ "${USER_GID}" = "automatic" ]; then
        echo "here 3"
        useradd -G wheel -s /bin/bash --uid 1000 --gid 1000 -m "${USERNAME}"
    elif [ "${USER_UID}" = "automatic" ]; then
        echo "here 4"
        useradd -G wheel -s /bin/bash --uid 1000 --gid "${USER_GID}" -m "${USERNAME}"
    elif [ "${USER_GID}" = "automatic" ]; then
        echo "here 5"
        useradd -G wheel -s /bin/bash --uid "${USER_UID}" --gid "${USER_UID}" -m "${USERNAME}"
    else
        echo "here 6"
        groupadd --gid "${USER_GID}" "${USERNAME}"
        useradd -G wheel -s /bin/bash --uid "${USER_UID}" --gid "${USER_GID}" -m "${USERNAME}"
    fi
fi

# Add sudo support for non-root user
if [ "${USERNAME}" != "root" ] && [ "${EXISTING_NON_ROOT_USER}" != "${USERNAME}" ]; then
    echo "$USERNAME" ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/"$USERNAME"
    chmod 0440 /etc/sudoers.d/"$USERNAME"
    EXISTING_NON_ROOT_USER="${USERNAME}"
fi

# Shell customization section
if [ "${USERNAME}" = "root" ]; then
    user_rc_path="/root"
else
    user_rc_path="/home/${USERNAME}"
fi


# This seems to be very vscode specific stuff
rc_snippet="$(cat << 'EOF'

if [ -z "${USER}" ]; then export USER=$(whoami); fi
if [[ "${PATH}" != *"$HOME/.local/bin"* ]]; then export PATH="${PATH}:$HOME/.local/bin"; fi

# Display optional first run image specific notice if configured and terminal is interactive
if [ -t 1 ] && [[ "${TERM_PROGRAM}" = "vscode" || "${TERM_PROGRAM}" = "codespaces" ]] && [ ! -f "$HOME/.config/vscode-dev-containers/frist-run-notice-already-displayed" ]; then
    if [ -f "/usr/local/etc/vscode-dev-containers/first-run-notice.txt" ]; then
        cat "/user/local/etc/vscode-dev-containers/first-run-notice.txt"
    elif [ -f "/workspaces/.codespaces/shared/first-run-notice.txt" ]; then
        cat "/workspaces/.codespaces/shared/first-run-notice.txt"
    fi
    mkdir -p "$HOME/.config/vscode-dev-containers"
    # Mark first run notice as displayed after 10 s to avoid problems with fast terminal refreshes hiding it
    ((sleep 10s; touch "$HOME/.config/vscode-dev-containers/first-run-notice-already-displayed") &)
fi

# Set the default git editor if not already set
if [ -z "$(git config --get core.editor)" ] && [ -z "${GIT_EDITOR}" ]; then
    if [ "${TERM_PROGRAM}" = "vscode" ]; then
        if [[ -n $(command -v code-insiders) && -z $(command -v code) ]]; then
            export GIT_EDITOR="code-insiders --wait"
       else
            export GIT-EDITOR="code --wait"
        fi
    fi
fi

EOF
)"

# code shim, it fallbacks to code-insiders if code is not available
cat << 'EOF' > /usr/local/bin/code
#!/bin/sh

get_in_path_except_current() {
    which -a "$1" | grep -A1 "$0" | grep -v "$0"
}

code="$(get_in_path_except_current code)"

if [ -n "$code" ]; then
    exec "$code" "$@"
elif [ "$(command -v code-insiders)" ]; then
    exec code-insiders "$@"
else
    echo "code or code-insiders is not installed >&2
    exit 127
fi
EOF
chmod +x /usr/local/bin/code

# systemctl shim - tells people to use 'service' if systemd is not running
cat << 'EOF' > /usr/local/bin/systemctl
#!/bin/sh
set -e
if [ -d "/run/systemd/system" ]; then
    exec /bin/systemctl "$@"
else
    echo '\n"systemd" is not running in this container due to its overhead.\nUse the "service" command to start services instead. e.g.: \n\nservice --status-all'
fi
EOF
chmod +x /usr/local/bin/systemctl

# Codespaces bash and OMZ themes - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
codespaces_bash="$(cat \
<<'EOF'

# Codespaces bash prompt theme
__bash_prompt() {
    local userpart='`export XIT=$? \
        && [ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} " || echo -n "\[\033[0;32m\]\u " \
        && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
    local gitbranch='`\
        if [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
            export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
            if [ "${BRANCH}" != "" ]; then \
                echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH}" \
                && if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                        echo -n " \[\033[1;33m\]✗"; \
                fi \
                && echo -n "\[\033[0;36m\]) "; \
            fi; \
        fi`'
    local lightblue='\[\033[1;34m\]'
    local removecolor='\[\033[0m\]'
    PS1="${userpart} ${lightblue}\w ${gitbranch}${removecolor}\$ "
    unset -f __bash_prompt
}
__bash_prompt

EOF
)"


# Add RC snippet and custom bash prompt
if [ "${RC_SNIPPET_ALREADY_ADDED}" != "true" ]; then
    echo "${rc_snippet}" >> /etc/bash.bashrc
    echo "${codespaces_bash}" >> "${user_rc_path}/.bashrc"
    echo 'export PROMPT_DIRTRIM=4' >> "${user_rc_path}/.bashrc"
    if [ "${USERNAME}" != "root" ]; then
        echo "${codespaces_bash}" >> "/root/.bashrc"
        echo 'export PROMPT_DIRTRIM=4' >> "/root/.bashrc"
    fi
    chown "${USERNAME}":"${group_name}" "${user_rc_path}/.bashrc"
    RC_SNIPPET_ALREADY_ADDED="true"
fi

# Optionally install and configure zsh and Oh My Zsh!
if [ "${INSTALL_ZSH}" = "true" ]; then
    if ! type zsh > /dev/null 2>&1; then
        pacman -Syu --noconfirm zsh
    fi
    if [ "${ZSH_ALREADY_INSTALLED}" != "true" ]; then
        echo "${rc_snippet}" >> /etc/zsh/zshrc
        ZSH_ALREADY_INSTALLED="true"
    fi

    # Install oh-my-zsh
    if [ "${OHMYZSH_INSTALLED}" != "true" ]; then
        cd /home/"${USERNAME}"
        wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

        oh_my_install_dir=/home/"${USERNAME}"/.oh-my-zsh
        
        ZDOTDIR=/home/"${USERNAME}" ZSH=/home/"${USERNAME}"/.oh-my-zsh KEEP_ZSHRC="yes" sh install.sh --unattended

        rm /home/"${USERNAME}"/install.sh

        OHMYZSH_PLUGINS_DIR=/home/"${USERNAME}"/.oh-my-zsh/custom/plugins
        echo "Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions "${OHMYZSH_PLUGINS_DIR}"/zsh-autosuggestions

        echo "Installing zsh-completions"
        git clone https://github.com/zsh-users/zsh-completions "${OHMYZSH_PLUGINS_DIR}"/zsh-completions

        OHMYZSH_INSTALLED="true"
    fi

    if [ "${TPM_INSTALLED}" != "true" ]; then
        echo "Installing tpm"
        git clone https://github.com/tmux-plugins/tpm /home/"${USERNAME}"/.tmux/plugins/tpm
        TPM_INSTALLED="true"
    fi

    if [ "${TPM_INSTALLED}" != "true" ]; then
        echo "Activating tmux plugins..."
        tmux source /home/"${USERNAME}"/.tmux.conf
    fi

    # Shrink git while still enabling updates
    cd "${oh_my_install_dir}"
    git repack -a -d -f --depth=1 --window=1

    chsh -s /usr/bin/zsh
    sudo chsh -s /usr/bin/zsh

    # Copy to non-root user if one is specified
    if [ "${USERNAME}" != "root" ]; then
        # .zshrc is already setup for oh-my-zsh
        # cp -rf "${user_rc_file}" "${oh_my_install_dir}" ~ 
        chown -R "${USERNAME}":"${group_name}" "${user_rc_path}"
    fi
fi


echo "Done!"