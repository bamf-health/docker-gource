# Docker Gource Image

[Docker](https://www.docker.com) container that has the capability to generate [Gource](https://code.google.com/p/gource) videos in a headless environment.

## Changes in this fork

- Generate video on the fly from gource output without storing the huge intermediary ppm file, requires much less storage space.
- Update to ubuntu 16.04 and fix broken install commands

## Customizable Environment Variables
Let me know if you would like more to be customizeable.

+ RES (default: 1920x1080)
+ DEPTH (default: 24)
+ TITLE (default: "")

## Base Docker Image

- [ubuntu:16.04](https://registry.hub.docker.com/_/ubuntu/)

## Requirements:

- [Docker](http://www.docker.com/)

## Usage

### Build or Download Image

Download [automated build](https://hub.docker.com/r/levsa/gource/) from public [Docker Hub Registry](https://hub.docker.com/):

    docker pull levsa/gource

Alternatively, you can build an image from the `Dockerfile`:

    git clone git@github.com:levsa/docker-gource.git
    cd docker-gource
    docker build -t levsa/gource .

### Running

    docker run --rm --name gource \
               -v REPO_ROOT:/repoRoot \
               -v RESULTS_FOLDER:/results \
               -v AVATARS_FOLDER:/avatars \
               --env TITLE="My overridden title text" \
               levsa/gource

If you want repository usernames to be replaced with images then put images to avatars folder.
Name for the avatar image must match the username (e.g taivokasper.png).

### Example: Automatically download Github repository

    docker run --rm --name gource \
               -v $HOME/Videos/gource:/results \
               --env TITLE="Docker Evolution" \
               levsa/gource docker/docker
