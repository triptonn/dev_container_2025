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

FROM archlinux:latest

COPY ./library-scripts/*.sh ./library-scripts/*.env /tmp/library-scripts/

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN pacman -Syu --noconfirm
RUN bash /tmp/library-scripts/common-arch.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"
    # TODO: Clean after pacman

ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash /tmp/library-scripts/python-arch.sh "none" "/usr/bin" "${PIPX_HOME}" "${USERNAME}"
    # TODO: Clean after pacman

ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node-arch.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"
    # TODO: Clean after pacman

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# Remove default config files before copying your own
RUN rm /home/"${USERNAME}"/.bshrc && rm /home/"${USERNAMER}"/.zshrc

# Create config directories
RUN mkdir /home/"${USERNAME}"/.tmux /home/"${USERNAME}"/.scripts

# Copy own config files
COPY ./scripts/.zshrc ./scripts/.bashrc ./scripts/.tmux.conf /home/"${USERNAME}"/
COPY ./scripts/tmux-cht-command ./scripts/tmux-cht-languages /home/"${USERNAME}"/.tmux/
COPY ./scripts/tmux-cht.sh ./scripts/tmux-sessionizer /home/"${USERNAME}"/.scripts/
COPY ./scripts/nvim /home/"${USERNAME}"/.config/nvim

RUN chown -R "${USERNAME}":"${USERNAME}" /home/"${USERNAME}" \
    && chmod +x /home/"${USERNAME}"/.scripts/tmux-cht.sh

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]