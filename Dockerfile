FROM ubuntu:21.04

# Set the reset cache variable
ENV REFRESHED_AT 2021-09-03

# Update the repositories list and install software to add a PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y git \
                       mercurial \
                       xvfb \
                       xfonts-base \
                       xfonts-75dpi \
                       xfonts-100dpi \
                       xfonts-cyrillic \
                       gource \
                       screen \
                       ffmpeg

# Add the init script
ADD ./init.sh /tmp/init.sh

# Set the default title
ENV TITLE "Example title"

# Mount volumes
VOLUME ["/repoRoot", "/avatars", "/results"]

# Set the working directory to where the git repository is stored
WORKDIR /repoRoot

# Run the init script by default
CMD [""]
ENTRYPOINT ["/tmp/init.sh"]
