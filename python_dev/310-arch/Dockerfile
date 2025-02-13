FROM archlinux:latest

COPY ./library-scripts/*.sh ./library-scripts/*.env /tmp/library-scripts/

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID


RUN pacman -Yu \
    && bash /tmp/library-scripts/common-arch.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"



WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]