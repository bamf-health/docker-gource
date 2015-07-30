# Docker Gource Image

[Docker](https://www.docker.com) container that has the capability to generate [Gource](https://code.google.com/p/gource) videos in a headless environment.  

## Base Docker Image

- [ubuntu:14.04](https://registry.hub.docker.com/_/ubuntu/)

## Requirements:

- [Docker](http://www.docker.com/)

## Usage

### Build or Download Image

Download [automated build](https://registry.hub.docker.com/u/czerasz/gource/) from public [Docker Hub Registry](https://registry.hub.docker.com/):

    docker pull czerasz/gource

Alternatively, you can build an image from the `Dockerfile`:

    git clone git@github.com:czerasz/docker-gource.git
    cd docker-gource
    docker build -t czerasz/gource .  

### Running

    docker run --rm --name gource \
               -v REPO_ROOT:/repoRoot \
               -v RESULTS_FOLDER:/results \
               -v AVATARS_FOLDER:/avatars \
               --env TITLE="My overridden title text" \
               czerasz/gource

If you want repository usernames to be replaced with images then put images to avatars folder.  
Name for the avatar image must match the username (e.g taivokasper.png).

### Example: Automatically download Github repository

    docker run --rm --name gource \
               -v $HOME/Videos/gource:/results \
               --env TITLE="Docker Evolution" \
               czerasz/gource docker/docker
