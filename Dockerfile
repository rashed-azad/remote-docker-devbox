# Use specific Debian stable
FROM debian:bookworm

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        bash \
        vim nano \
        curl \
        git \
        unzip tar gzip bzip2 xz-utils \
        htop less man dialog \
        openssh-server openssh-client \
        net-tools iputils-ping \
        cmake build-essential software-properties-common gnupg lsb-release \
        ca-certificates locales systemd sudo \
        python3.11 python3.11-venv python3.11-distutils python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Add user 'rashed' with sudo privileges
RUN useradd -ms /bin/bash rashed && echo "rashed:rashed" | chpasswd && adduser rashed sudo

# Configure SSH: allow password authentication
RUN mkdir /var/run/sshd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Set working directory to the user home
WORKDIR /home/rashed

# Start SSH service by default
CMD ["/usr/sbin/sshd", "-D"]
