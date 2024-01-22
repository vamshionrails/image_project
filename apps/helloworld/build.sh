#!/bin/bash

# Define your GitHub Container Registry username
GHCR_USERNAME=vamshionrails
GHCR_TOKEN=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
# Define your Docker image name
IMAGE_NAME=hello_world

# Define the tag for your Docker image
TAG=v1

# Build the Docker image
docker build -t $GHCR_USERNAME/$IMAGE_NAME:$TAG .

# Tag the Docker image for GitHub Container Registry
docker tag $GHCR_USERNAME/$IMAGE_NAME:$TAG ghcr.io/$GHCR_USERNAME/$IMAGE_NAME:$TAG

# Authenticate with GitHub Container Registry using a Personal Access Token (PAT)
# Make sure to replace <your-token> with your actual GitHub PAT
echo "ghcr.io -u $GHCR_USERNAME -p $GHCR_TOKEN" | docker login ghcr.io -u $GHCR_USERNAME --password-stdin

# Push the Docker image to GitHub Container Registry
docker push ghcr.io/$GHCR_USERNAME/$IMAGE_NAME:$TAG

