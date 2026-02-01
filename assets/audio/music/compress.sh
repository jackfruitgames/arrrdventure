#!/bin/bash
# compress_wav.sh

for file in ./*.wav; do
  filename=$(basename "$file" .wav)
  ffmpeg -i "$file" \
    -acodec adpcm_ima_wav \
    -ar 44100 \
    -ac 2 \
    -y "${filename}.wav"
done
