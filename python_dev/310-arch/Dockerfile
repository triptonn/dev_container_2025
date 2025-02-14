FROM archlinux:latest

COPY ./library-scripts/*.sh ./library-scripts/*.env /tmp/library-scripts/

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN pacman -Yu \
    && bash /tmp/library-scripts/common-arch.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"
    # TODO: Clean after pacman

ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash /tmp/library-scripts/python-arch.sh "none" "/usr/local" "${PIPX_HOME}" "${USERNAME}"
    # TODO: Clean after pacman

ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node-arch.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"
    # TODO: Clean after pacman

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

COPY ./dotfiles/.tmux.conf /home/vscode/.tmux.conf
COPY ./dotfiles/.zshrc /home/vscode/.zshrc
COPY ./dotfiles/tmux-cht-command /home/vscode/tmux-cht-command
COPY ./dotfiles/tmux-cht-languages /home/vscode/tmux-cht-languages
COPY ./scripts/tmux-cht.sh /home/vscode/.scripts/tmux-cht.sh
COPY ./scripts/tmux-sessionizer /home/vscode/.scripts/tmux-sessionizer

RUN chown -R vscode:vscode /home/vscode \
    && chmod +x /home/vscode/.scripts/tmux-cht.sh

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]