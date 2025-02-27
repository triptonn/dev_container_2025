#!/usr/bin/bash
set -e

USERNAME=${1:-"automatic"}

# Install Flutter dependencies
pacman -Syu --noconfirm \
    android-tools \
    dart \
    unzip \
    xz \
    zip \
    which \
    cmake \
    ninja \
    clang \
    pkg-config \
    gtk3 \
    man-pages

# Download and install Flutter SDK
FLUTTER_VERSION="stable"
FLUTTER_HOME="/usr/local/flutter"
git clone https://github.com/flutter/flutter.git -b ${FLUTTER_VERSION} ${FLUTTER_HOME}

# Add Flutter to PATH
echo "export PATH=\$PATH:${FLUTTER_HOME}/bin" >> /etc/profile.d/flutter.sh

# Set environment variables for headless operation
echo "export CHROME_EXECUTABLE=/usr/bin/chrome" >> /etc/profile.d/flutter.sh
echo "export FLUTTER_WEB_PORT=8080" >> /etc/profile.d/flutter.sh

# Configure Flutter for headless environment
${FLUTTER_HOME}/bin/flutter config --no-analytics
${FLUTTER_HOME}/bin/flutter config --enable-web
${FLUTTER_HOME}/bin/flutter precache

# Create Flutter cache directory
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /home/${USERNAME}/.pub-cache
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.pub-cache
fi

# Create workspace directory
mkdir -p /workspaces
chown -R ${USERNAME}:${USERNAME} /workspaces

echo "Done!"