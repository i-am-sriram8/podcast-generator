# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Clean apt cache, update, and install Python 3.10, pip, dev tools and dependencies
RUN apt-get clean && rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       python3.10 \
       python3.10-venv \
       python3-pip \
       python3.10-dev \
       build-essential \
       libyaml-dev \
       git \
    && rm -rf /var/lib/apt/lists/*

# Set python3 and pip3 alternatives to point to python3.10 and pip3.10 respectively
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.10 1

# Upgrade pip, setuptools, and wheel to latest versions
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install PyYAML Python package
RUN pip3 install --no-cache-dir PyYAML

# Copy your Python script and entrypoint shell script
COPY feed.py /usr/bin/feed.py
COPY entrypoint.sh /entrypoint.sh

# Make sure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Set the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]
