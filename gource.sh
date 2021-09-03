#!/usr/bin/env bash

trap build_and_retry ERR

build_and_retry() {
    if [ $? -eq 125 ] && [ -z "$TRAPPED" ]; then
        export TRAPPED=true
        docker build -t "${CONTAINER_NAME}" .
        exec $0 $ARGS
    fi
}

set -eo pipefail

ARGS=$@

CONTAINER_NAME=${CONTAINER_NAME:-local/gource}
BIND_VOLUMES="-v $(pwd)/results:/results -v $(pwd)/avatars:/avatars:ro"
DOCKER_ARGS=

for REPO in "$@"; do
    # Bind directories as volumes in /repoRoot
    # Otherwise pass to the container as github repos to clone
    if [ -d "$REPO" ]; then
        BIND_VOLUMES="-v $(realpath ${REPO}):/repoRoot/$(basename ${REPO}):ro ${BIND_VOLUMES}"
    else
        DOCKER_ARGS="${REPO} ${DOCKER_ARGS}"
    fi
done

mkdir -p "$(pwd)/results" "$(pwd)/avatars"

time docker run --rm --name gource \
           $BIND_VOLUMES \
           --env DEPTH="$DEPTH" \
           --env RES="$RES" \
           --env TITLE="$TITLE" \
           --env HIDE="$HIDE" \
           --env HIDE_REPO="$HIDE_REPO" \
           --env PRESET="$PRESET" \
           "$CONTAINER_NAME" $DOCKER_ARGS
