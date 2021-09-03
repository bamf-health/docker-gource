# Docker Gource Image

[Docker](https://www.docker.com) container that has the capability to generate [Gource](https://code.google.com/p/gource) videos in a headless environment.

## Changes in this fork

- Update to ubuntu 21.04
- Process multiple repositories into one video

## Customizable Environment Variables

+ RES (default: 1920x1080)
+ DEPTH (default: 24)
+ TITLE (default: "")
+ HIDE - Gource --hide parameter (default: mouse)
+ PRESET - ffmpeg encoding preset (default: ultrafast)
+ HIDE_REPO - set to true to not add repo dir to paths (default: "")

## Base Docker Image

- [ubuntu:21.04](https://registry.hub.docker.com/_/ubuntu/)

## Requirements:

- [Docker](http://www.docker.com/)

## Usage

### Build Image

Build an image from the `Dockerfile` in this repository:

``` sh
docker build -t local/gource .
```

### Running

The `gource.sh` script automates running the docker container with appropriate env vars and bind mounts.

It mounts `./avatars` for providing user avatars in the visualization and `./results` to output the finished `gource.mp4`.

The customizable environment variables above can be set when running `gource.sh` to configure Gource.

### Visualizing local repositories

``` sh
./gource.sh /path/to/repo1 /path/to/repo2
```

### Visualizing Github repositories

``` sh
./gource.sh acaudwell/gource
```

### Visualizing a mix of local & Github repositories

``` sh
./gource.sh acaudwell/gource /path/to/local-repo
```
