# This is the Dockerfile the mirrors a CD agent

# Global Build Arguments
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#
# Multi Stage: Dev Image
#
FROM debian:stable-slim as dev

# Arguments associated with the non-root user
ARG USERNAME
ARG USER_UID
ARG USER_GID

# Set envrionmental variables
ENV DEBIAN_FRONTEND=noninteractive

# Add the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    bash \
    sudo \
    wget \
    gpg \
    # To read packer manifest
    jq \
    lsb-release \
    # To avoid an ansible error
    locales-all \
    # To enable IaC tool to access a remote instance
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Copy system dependency installation shell scripts over
COPY scripts/ /tmp/install-scripts/

# Make them executable
RUN chmod +X /tmp/install-scripts/*.sh

# Install system dependencies not available in the package manager
RUN /tmp/install-scripts/install-opentofu.sh \
    && /tmp/install-scripts/install-ansible.sh \
    && /tmp/install-scripts/install-packer.sh \
    && rm -rf /tmp/install-scripts

# Switch to the non-root user to install applications on the user level
USER ${USERNAME}
