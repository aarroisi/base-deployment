# Stage 1: Builder
FROM ruby:slim-bullseye AS builder

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Install build dependencies and Ruby gems
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ruby-dev \
    ca-certificates \
    curl

RUN gem install kamal -v 2.4.0 --no-document

# Clean up build dependencies to reduce image size
RUN apt-get remove -y build-essential ruby-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Stage 2: Final Image
FROM ruby:slim-bullseye

LABEL org.opencontainers.image.authors="arman@icasia.id"

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Install runtime dependencies and Ruby runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    awscli \
    git \
    curl \
    ca-certificates \
    iptables \
    iproute2 \
    socat \
    tini \
    openssh-client \
    gnupg \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the stable repository
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bullseye stable" \
    > /etc/apt/sources.list.d/docker.list

# Install Docker Engine
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin && \
    rm -rf /var/lib/apt/lists/*

# Copy the Ruby gems from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy the dockerd-entrypoint.sh script
COPY dockerd-entrypoint.sh /usr/local/bin/

# Set executable permissions for the entrypoint script
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Set the entrypoint to use Tini and the Docker daemon
ENTRYPOINT ["tini", "--", "/usr/local/bin/dockerd-entrypoint.sh"]

# Default command
CMD ["sh"]
