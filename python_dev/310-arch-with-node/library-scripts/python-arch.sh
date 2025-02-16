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

USERNAME=${1:-"automatic"}
PIPX_HOME=${2:-"/usr/local/py-utils"}
PIPX_BIN_DIR=${3:-"/usr/local/py-utils/bin"}

pacman -Syu --noconfirm

pacman -S --noconfirm python python-pip python-pipx

mkdir -p "${PIPX_HOME}"
chown -R "${USERNAME}:${USERNAME}" "${PIPX_HOME}"

su "${USERNAME}" -c "$(cat << EOF
    export PIPX_HOME="${PIPX_HOME}"
    export PIPX_BIN_DIR="${PIPX_BIN_DIR}"
    pipx install pylint
    pipx install autopep8
    pipx install black
    pipx install yapf
    pipx install pydocstyle
    pipx install pycodestyle
    pipx install bandit
    pipx install pytest
EOF
)"

echo "Done!"