#!/usr/bin/env bash
# Usage: deploy.sh <image_name> <tag>
set -euo pipefail

IMAGE="${1?image}"
TAG="${2?tag}"
CONTAINER_NAME="sample-java-app"

echo "Pulling ${IMAGE}:${TAG} ..."
docker pull ${IMAGE}:${TAG}

echo "Stopping existing container (if any)..."
if docker ps -q --filter "name=${CONTAINER_NAME}" | grep -q .; then
  docker stop ${CONTAINER_NAME} || true
fi
if docker ps -aq --filter "name=${CONTAINER_NAME}" | grep -q .; then
  docker rm ${CONTAINER_NAME} || true
fi

echo "Starting container..."
docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --restart unless-stopped ${IMAGE}:${TAG}

echo "Deployment complete."
