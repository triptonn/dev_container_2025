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
    maven \
    gradle \
    junit \
    man-pages \
    make \
    unzip

# Removed visualvm from container --> install on host
# expose prot 9010:9010 in the container to connect via JMX port
# start application with the following command options:
# java -Dcom.sun.management.jmxremote \
#      -Dcom.sun.management.jmxremote.port=9010 \
#      -Dcom.sun.management.jmxremote.local.only=false \
#      -Dcom.sun.management.jmxremote.authenticate=false \
#      -Dcom.sun.management.jmxremote.ssl=false \
#      -jar your-app.jar

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

# Create workspace directory
mkdir -p /workspaces
chown -R ${USERNAME}:${USERNAME} /workspaces

echo "Done!"