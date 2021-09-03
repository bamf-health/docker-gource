#!/bin/bash

# Stop on first error
set -e

# Remove previous results
rm -f /results/{gource.ppm,gource.mp4}

# Define defaults
RES="${RES:-1920x1080}"
DEPTH="${DEPTH:-24}"

github_user=''
github_repository=''

# Parse the Github repository string passed as argument and download the repository
prepare_github_repository () {
  repository_string=$1

  IFS='/' read -ra repository_split <<< "$repository_string"

  counter=2
  for i in "${repository_split[@]}"; do
    ((counter--))
  done

  if [ "${counter}" -eq "0" ]; then
    github_user=${repository_split[0]}
    github_repository=${repository_split[1]}
  else
    echo ERROR: Failed to parse the Github repository string
    # Terminate and indicate error
    exit 1
  fi

  # Download git repository
  git clone "https://github.com/$repository_string.git" "${github_user}-${github_repository}"
}

render () {
  for repo in */; do
    repo=$(basename ${repo})
    echo Processing "$repo"

    gource --output-custom-log "${repo}.txt" "$repo"
    # Unless HIDE_REPO is non-empty, include the repo dir in the log
    if [ -z "$HIDE_REPO" ]; then
      echo inserting repo dirname
      sed -ibak -r "s#(.+)\|#\1|/${repo}#" "${repo}.txt"
    fi
  done

  cat -- *.txt | sort -n > combined.log

  render_final
}

render_final () {
  if [ -s combined.log ]; then
    HIDE=${HIDE:-mouse}
    TITLE="${TITLE:- }"

    xvfb-run -a -s "-screen 0 ${RES}x${DEPTH}" \
        gource "-$RES" \
          -r 30 \
          --title "$TITLE" \
          --user-image-dir /avatars/ \
          --highlight-all-users \
          --hide "$HIDE" \
          -s 0.5 \
          --seconds-per-day .4 \
          --font-size 25 \
          --font-colour FFFF00 \
          --user-scale 4.0 \
          --auto-skip-seconds 1 \
          -o -  combined.log \
          | ffmpeg -y -r 30 -f image2pipe \
          -loglevel info \
          -vcodec ppm \
          -i - \
          -vcodec libx264 \
          -preset ultrafast \
          -pix_fmt yuv420p \
          -crf 1 \
          -threads 0 \
          -bf 0 /results/gource.mp4

  fi
}

# Check if any arguments were passed or if the passed argument is empty
if [ $# -eq 0 -o -z "$1" ]; then
  echo "No arguments supplied. Expecting a volume mounted with the repository."
else
  # Parse the Github repository string(s) and download them
  for repo in "$@"; do
    prepare_github_repository $repo
  done
fi

# Start the rendering process
render
