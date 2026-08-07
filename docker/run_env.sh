#!/usr/bin/env bash
set -euo pipefail

MULTIPLEXER="${1:-}"

if [[ -z "$MULTIPLEXER" || ! "$MULTIPLEXER" =~ ^(screen|tmux|shpool|herdr)$ ]]; then
    echo "Usage: $0 <screen|tmux|shpool|herdr> [test|bash]"
    exit 1
fi

MODE="${2:-bash}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

IMAGE_TAG="liquidprompt-test:${MULTIPLEXER}"

echo "==> Building Docker image for ${MULTIPLEXER} on Fedora 44..."
podman build -t "$IMAGE_TAG" -f "$SCRIPT_DIR/Dockerfile.${MULTIPLEXER}" "$REPO_DIR" || \
docker build -t "$IMAGE_TAG" -f "$SCRIPT_DIR/Dockerfile.${MULTIPLEXER}" "$REPO_DIR"

if [[ "$MODE" == "test" ]]; then
    echo "==> Running test suite in isolated ${MULTIPLEXER} container..."
    podman run --rm -it "$IMAGE_TAG" ./tests.sh bash || \
    docker run --rm -it "$IMAGE_TAG" ./tests.sh bash
else
    echo "==> Entering interactive shell in ${MULTIPLEXER} container..."
    podman run --rm -it "$IMAGE_TAG" /bin/bash || \
    docker run --rm -it "$IMAGE_TAG" /bin/bash
fi
