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
ARG USER_GID=1000

# Remove default config files before copying your own
# RUN rm /home/"${USERNAME}"/.bashrc
# RUN rm /home/"${USERNAME}"/.zshrc

# Copy own config files
COPY ./scripts/.zshrc ./scripts/.bashrc /home/"${USERNAME}"/

# Run arch package install
RUN pacman -Syu --noconfirm
RUN bash /tmp/library-scripts/common-arch.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}"

# Install Love2D and development tools
RUN pacman -S --noconfirm love luarocks nodejs npm git

# Install lovejs globally
RUN npm install -g love.js

# Run python install
ENV PIPX_HOME=/usr/local/py-utils
ENV PIPX_BIN_DIR=${PIPX_HOME}/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}

RUN bash /tmp/library-scripts/python-arch.sh "${USERNAME}" "${PIPX_HOME}" "${PIPX_BIN_DIR}"

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# Create config directories
RUN mkdir -p /home/"${USERNAME}"/.scripts /home/"${USERNAME}"/fzf-git

# Copy own config files
COPY ./scripts/.tmux.conf /home/"${USERNAME}"/
COPY ./scripts/tmux-cht-command ./scripts/tmux-cht-languages /home/"${USERNAME}"/.tmux/
COPY ./scripts/tmux-cht.sh ./scripts/tmux-sessionizer ./scripts/tmux-open.sh /home/"${USERNAME}"/.scripts/
COPY ./scripts/nvim /home/"${USERNAME}"/.config/nvim
COPY ./scripts/fzf-git.sh /home/"${USERNAME}"/.config/fzf-git/fzf-git.sh
COPY ./scripts/shibby.zsh-theme /home/"${USERNAME}"/.oh-my-zsh/custom/themes/shibby.zsh-theme
COPY ./scripts/venv-info.zsh ./scripts/venv-info.plugin.zsh /home/${USERNAME}/.oh-my-zsh/custom/plugins/venv-info/

# Create Love2D project template directory
RUN mkdir -p /home/"${USERNAME}"/.config/love2d-templates
COPY ./scripts/love2d-templates/ /home/"${USERNAME}"/.config/love2d-templates/

RUN chown -R "${USERNAME}":"${USERNAME}" /home/"${USERNAME}"
RUN chmod +x /home/"${USERNAME}"/.scripts/tmux-cht.sh /home/"${USERNAME}"/.config/fzf-git/fzf-git.sh

USER "${USERNAME}"
SHELL [ "/usr/bin/zsh" ]
VOLUME [ "/workspaces" ]
WORKDIR /workspaces

# Expose port for Love.js development server
EXPOSE 8080

CMD ["tail", "-f", "/dev/null"] 