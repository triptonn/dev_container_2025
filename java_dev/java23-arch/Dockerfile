#!/usr/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) 2025 Nicolas Selig
#
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

    FROM archlinux:latest

    COPY ./library-scripts/*.sh ./library-scripts/*.env /tmp/library-scripts/
    
    ARG INSTALL_ZSH="true"
    ARG UPGRADE_PACKAGES="true"
    ARG USERNAME=vscode
    ARG USER_UID=1000
    ARG USER_GID=1000
    
    # Run arch package install
    RUN pacman -Syu --noconfirm
    RUN bash /tmp/library-scripts/common-arch.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}"
    
    # Run Java development environment install
    RUN bash /tmp/library-scripts/java-arch.sh "${USERNAME}"
    
    # Remove library scripts for final image
    RUN rm -rf /tmp/library-scripts
    
    # Create config directories
    RUN mkdir /home/"${USERNAME}"/.scripts /home/"${USERNAME}"/.tmux /home/"${USERNAME}"/.config/nvim
    
    # Copy own config files
    COPY ./scripts/.tmux.conf /home/"${USERNAME}"/
    COPY ./scripts/tmux-cht-command ./scripts/tmux-cht-languages /home/"${USERNAME}"/.tmux/
    COPY ./scripts/tmux-cht.sh ./scripts/tmux-sessionizer ./scripts/tmux-open.sh /home/"${USERNAME}"/.scripts/
    COPY ./scripts/nvim /home/"${USERNAME}"/.config/nvim
    COPY ./scripts/fzf-git.sh /home/"${USERNAME}"/.config/fzf-git/fzf-git.sh
    COPY ./scripts/shibby.zsh-theme /home/"${USERNAME}"/.oh-my-zsh/custom/themes/shibby.zsh-theme
    COPY ./scripts/.zshrc ./scripts/.bashrc /home/"${USERNAME}"/
    
    RUN chown -R "${USERNAME}":"${USERNAME}" /home/"${USERNAME}"
    RUN chmod +x /home/"${USERNAME}"/.scripts/tmux-cht.sh /home/"${USERNAME}"/.scripts/tmux-sessionizer /home/"${USERNAME}"/.scripts/tmux-open.sh
    
    USER "${USERNAME}"
    SHELL [ "/usr/bin/zsh" ]
    VOLUME [ "/workspaces" ]
    WORKDIR /workspaces
    
    CMD ["tail", "-f", "/dev/null"]