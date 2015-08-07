#!/bin/bash

# Stop on first error
set -e

# Remove previous results
rm -f /results/{gource.ppm,gource.mp4}

# Define defaults
RES="${RES:-1280x720}"
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
  git clone "https://github.com/$repository_string.git" .
}

render () {
  screen -dmS recording xvfb-run -a -s "-screen 0 ${RES}x${DEPTH}" gource "-$RES" -r 30 --title "$TITLE" --user-image-dir /avatars/ --highlight-all-users -s 0.5 --seconds-per-day ${SEC_PER_DAY:-1} --hide filenames -o /results/gource.ppm

  # This hack is needed because gource process doesn't stop
  lastsize="0"
  filesize="0"

  while [[ "$filesize" -eq "0" || $lastsize -lt $filesize ]] ;
  do
      sleep 20
      lastsize="$filesize"
      filesize=$(stat -c '%s' /results/gource.ppm)
      echo 'Polling the size. Current size is' $filesize
  done

  echo 'Force stopping recording because file size is not growing'
  screen -S recording -X quit

  xvfb-run -a -s "-screen 0 ${RES}x${DEPTH}" ffmpeg -y -r 30 -f image2pipe -loglevel info -vcodec ppm -i /results/gource.ppm -vcodec libx264 -preset medium -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 /results/gource.mp4
  rm -f /results/gource.ppm
}

# Check if any arguments were passed or if the passed argument is empty
if [ $# -eq 0 -o -z "$1" ]; then
  echo "No arguments supplied. Expecting a volume mounted with the repository."

  # Start the rendering process
  render
else
  # Parse the Github repository string and download the repository
  prepare_github_repository $1

  # Start the rendering process
  render

  mv /results/gource.mp4 "/results/$github_user-$github_repository.mp4"
fi