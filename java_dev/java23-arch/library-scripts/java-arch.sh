#!/usr/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) 2025 Nicolas Selig
#
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

set -e

USERNAME=${1:-"automatic"}

# Install Java Development Kit and related tools
pacman -Syu --noconfirm \
    jdk-openjdk \
    jre-openjdk \
    maven \
    gradle \
    junit \
    visualvm \
    jdb

# Install additional development tools
pacman -S --noconfirm \
    checkstyle \
    shellcheck \
    man-pages

# Install build tools and debugging support
pacman -S --noconfirm \
    make \
    unzip

# Set JAVA_HOME environment variable
echo "export JAVA_HOME=/usr/lib/jvm/default" >> /etc/profile.d/java_home.sh
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/java_home.sh

# Create Maven settings directory
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /home/${USERNAME}/.m2
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.m2
fi

# Create Gradle settings directory
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /home/${USERNAME}/.gradle
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.gradle
fi

# Install LSP server (jdtls)
pacman -S --noconfirm \
    java-language-server

# Create workspace directory
mkdir -p /workspaces
chown -R ${USERNAME}:${USERNAME} /workspaces

echo "Done!"