# -------------------------------------------------------------
# Base Image
# -------------------------------------------------------------
# Use a specific stable version of Debian (Bookworm) for reliability
FROM debian:bookworm

# -------------------------------------------------------------
# Username Variable
# -------------------------------------------------------------
# Define a single username variable for easy modification
ARG USERNAME=rashed
ENV USERNAME=${USERNAME}

# -------------------------------------------------------------
# Environment Setup
# -------------------------------------------------------------
# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------------
# System Update & Package Installation
# -------------------------------------------------------------
# Update package lists, upgrade existing packages, and install essential tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    # Basic shell utilities
    bash vim nano curl git bash-completion unzip tar gzip bzip2 xz-utils \
    htop less man dialog \
    # Networking and SSH
    openssh-server openssh-client net-tools iputils-ping \
    # Development tools
    cmake build-essential software-properties-common gnupg lsb-release rsync gdb \
    # Certificates, locales, system utilities
    ca-certificates locales mlocate systemd sudo \
    # Python 3.11 and development packages
    python3.11 python3.11-venv python3.11-distutils python3-pip

# -------------------------------------------------------------
# Install clangd-17 (Debian 12 / Bookworm)
# -------------------------------------------------------------
RUN mkdir -p /etc/apt/keyrings && \
    # Download LLVM APT repository GPG key and store it as a keyring
    curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/llvm.gpg && \
    # Add the official LLVM 17 repository for Debian Bookworm
    echo "deb [signed-by=/etc/apt/keyrings/llvm.gpg] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-17 main" \
        > /etc/apt/sources.list.d/llvm.list && \
    # Update package lists after adding the new LLVM repository
    apt-get update && \
    # Install clangd-17 (language server)
    apt-get install -y clangd-17 && \
    # Make clang-17 the default 'clang' compiler on the system
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-17 100 && \
    # Clean up APT cache to reduce image size
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------------
# Locale Configuration
# -------------------------------------------------------------
# Enable en_US.UTF-8 locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Set environment variables to use UTF-8 by default
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# -------------------------------------------------------------
# User Configuration
# -------------------------------------------------------------
# Add a new user with sudo privileges
RUN useradd -ms /bin/bash ${USERNAME} && \
    echo "${USERNAME}:${USERNAME}" | chpasswd && \
    adduser ${USERNAME} sudo

# make sure PATH is correct inside user login shells
RUN echo 'export PATH="/sbin:/usr/sbin:$PATH"' >> /home/${USERNAME}/.profile && \
    echo 'export PATH="/sbin:/usr/sbin:$PATH"' >> /home/${USERNAME}/.bashrc && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.profile /home/${USERNAME}/.bashrc

# -------------------------------------------------------------
# SSH Configuration
# -------------------------------------------------------------
# Create necessary directory for SSH daemon
RUN mkdir /var/run/sshd

# Enable password authentication for SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Disable root login over SSH for security
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# -------------------------------------------------------------
# Working Directory
# -------------------------------------------------------------
# Set default working directory to the user's home
WORKDIR /home/${USERNAME}

# -------------------------------------------------------------
# Default Command
# -------------------------------------------------------------
# Start SSH daemon in the foreground when container starts
CMD ["/usr/sbin/sshd", "-D"]