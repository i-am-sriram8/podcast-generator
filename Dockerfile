FROM ubuntu:22.04

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

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

# Set python3 and pip3 to point to python3.10 and pip3 respectively
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1

# Upgrade pip, setuptools, and wheel
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install PyYAML
RUN pip3 install --no-cache-dir PyYAML

# Copy your scripts
COPY feed.py /usr/bin/feed.py
COPY entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
