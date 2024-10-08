# Stage 1: Builder
FROM docker:24-dind AS builder

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Install build dependencies and Ruby gems
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ruby-dev \
    ca-certificates && \
    gem install kamal --no-document && \
    # Clean up build dependencies to reduce image size
    apt-get remove -y build-essential ruby-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Stage 2: Final Image
FROM docker:24-dind

LABEL org.opencontainers.image.authors="arman@icasia.id"

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Install runtime dependencies and Ruby runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ruby \
    awscli \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Copy the Ruby gems from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Use the default entrypoint and command from the base image
