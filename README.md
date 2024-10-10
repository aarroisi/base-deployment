# base-deployment

A simple Dockerfile project that sets up a deployment environment based on Debian, including Kamal, Docker, and other useful tools.

## Overview

This project provides a Dockerfile that creates an image with the following components:

- Debian (base image)
- [Kamal](https://github.com/basecamp/kamal) - A deployment tool by Basecamp
- Docker
- AWS CLI
- Git
- curl

This image can be used as a base for deployment processes or as a CI/CD environment.

## Prerequisites

- Docker installed on your local machine
- Docker Hub account (for storing the built image)

## Usage

1. Clone this repository:

   ```
   git clone https://github.com/aarroisi/base-deployment.git
   cd base-deployment
   ```

2. Build the Docker image using the provided script:

   ```
   USERNAME=<username>  # Your Docker Hub username
   chmod +x build.sh
   ./build.sh
   ```

   This script builds the image for the linux/amd64 platform and pushes it to Docker Hub.

3. Once built and pushed, you can pull and run the container using:
   ```
   docker pull <username>/base-deployment:latest
   docker run -it <username>/base-deployment:latest /bin/bash
   ```
4. You can also use this for Github Actions, Gitlab CI/CD, or any other CI/CD tool.

## Automatic Builds

This project uses GitHub Actions to automatically build and push the Docker image to Docker Hub whenever changes are pushed to the `main` branch.

### Setup

1. Fork this repository to your GitHub account.

2. Set up the following secrets in your GitHub repository (Settings > Secrets and variables > Actions):

   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: A Docker Hub access token (not your password)

3. Ensure you have a repository on Docker Hub named `base-deployment` under your account.

4. Push changes to the `main` branch to trigger the build:
   ```
   git push origin main
   ```

The GitHub Actions workflow will automatically run the `build.sh` script to build the Docker image and push it to your Docker Hub repository.

## Customization

You can modify the Dockerfile to add or remove components as needed for your specific deployment requirements. If you make changes, push them to the `main` branch, and the GitHub Actions workflow will automatically build and push the updated image using the `build.sh` script.
