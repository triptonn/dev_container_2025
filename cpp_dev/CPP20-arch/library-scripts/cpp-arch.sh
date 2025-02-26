#!/usr/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) 2025 Nicolas Selig
#
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

set -e

USERNAME=${1:-"automatic"}
CMAKE_VERSION=${2:-"latest"}

# Install C++ related packages
pacman -Syu --noconfirm \
    gcc \
    gdb \
    cmake \
    ninja \
    clang \
    llvm \
    lldb \
    clang-tools-extra \
    boost \
    fmt \
    gtest \
    benchmark \
    ccache \
    bear \
    cppcheck \
    man-pages

# Create symbolic links for clangd
ln -sf /usr/bin/clangd /usr/local/bin/clangd

# Set up ccache
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /home/${USERNAME}/.ccache
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ccache
fi

# Create common build directories
mkdir -p /workspaces/build
chown -R ${USERNAME}:${USERNAME} /workspaces

echo "Done!"