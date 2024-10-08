# Stage 1: Builder
FROM docker:26.1.3-dind-alpine3.19 AS builder

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Create GEM_HOME directory
RUN mkdir -p /usr/local/bundle

# Install build dependencies and Ruby gems
RUN apk update && \
    apk add --no-cache \
    build-base \
    ruby-dev && \
    gem install kamal --no-document && \
    # Clean up build dependencies and APK cache to reduce image size
    apk del build-base ruby-dev && \
    rm -rf /var/cache/apk/*

# Stage 2: Final Image
FROM docker:26.1.3-dind-alpine3.19
LABEL org.opencontainers.image.authors="arman@icasia.id"

# Set environment variables for Ruby gems
ENV GEM_HOME=/usr/local/bundle
ENV PATH=$GEM_HOME/bin:$PATH

# Create GEM_HOME directory
RUN mkdir -p /usr/local/bundle

# Install runtime dependencies and Ruby runtime
RUN apk update && \
    apk add --no-cache \
    ruby \
    aws-cli \
    git \
    curl && \
    # Clean up APK cache to reduce image size
    rm -rf /var/cache/apk/*

# Copy the Ruby gems from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
