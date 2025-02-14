#!/usr/bin/env bash

set -e

INSTALL_ZSH=${1:-"true"}
USERNAME=${2:-"automatic"}
USER_UID=${3:-"automatic"}
USER_GID=${4:-"automatic"}
UPGRADE_PACKAGES=${5:-"true"}
INSTALL_OH_MYS=${6:-"true"}
ADD_NON_FREE_PACKAGES=${7:-"false"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKER_FILE="/usr/local/etc/vscode-dev-containers/common"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /ect/profile.d/00-restore-env.sh

if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME = ""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
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

if [ -f "${MARKER_FILE}" ]; then
    echo "Marker fiel found:"
    cat "${MARKER_FILE}"

    source "${MARKER_FILE}"
fi

if ["${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
    package_list="openssh-client \
    gnupg2 \
    gpg \
    dirmngr \
    iproute2 \
    procps \
    lsof \
    htop \
    net-tools \
    psmisc \
    curl \
    wget \
    rsync \
    ca-certificates \
    unzip \
    zip \
    neovim \
    tmux \
    fzf \
    fd \
    zoxide \
    bat \
    thefuck \
    less \
    jq \
    lsb-release \
    dialog \
    libc6 \
    libgcc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    liblttng-ust[0-9] \
    libstdc++6 \
    zlib1g \
    locales \
    sudo \
    ncdu \
    man-db \
    strace \
    init-system-helpers"

    echo "Packages to verify are installed: ${package_list}"

    pacman -Sy --noconfirm ${package_list} 2> >( grep -v 'some test output' >&2 )

    if ! type git > /dev/null 2>&1; then
        pacman -S --noconfirm git
    fi

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
        group_name="$(id -gn "$USERNAME")"
        groupmod --gid "$USER_GID" "${group_name}"
        usermod --uid "$USER_UID" "$USERNAME"
    fi
    if [ "${USER_UID}" != "automatic" ] && [ "$USER_UID" != "$(id -u "$USERNAME")" ]; then
        usermod --uid "$USER_UID" "$USERNAME"
    fi
else
    # Create user
    if [ "${USER_GID}" = "automatic" ]; then
        groupadd "$USERNAME"
    else
        groupadd --gid "$USER_GID" "$USERNAME"
    fi
    if [ "${USER_UID}" = "automatic" ]; then
        useradd -s /bin/bash --gid "$USERNAME" -m "$USERNAME"
    else
        useradd -s /bin/bash --uid "$USER_UID" --gid "$USERNAME" -m "$USERNAME"
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

# Restore user .bashrc defaults from skeleton file if it doesn't exist or is empty
if [ ! -f "${user_rc_path}/.bashrc" ] || [ ! -s "${user_rc_path}/.bashrc" ]; then
    cp /ect/skel/.bashrc "${user_rc_path}/.bashrc"
fi

# Restore user .profile defaults from skeleton file if it doesn't exist or is empty
if [ ! -f "${user_rc_path}/.profile" ] || [ ! -s "${user_rc_path}/.profile" ]; then
    cp /etc/skel/.profile "${user_rc_path}/.profile"
fi

# .bashrc/.zshrc snippet


    