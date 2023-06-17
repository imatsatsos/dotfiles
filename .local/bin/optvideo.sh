#!/bin/sh

# Script accepts four arguments: input file, width in pixels of output video, encoder, and output folder
# Check that all arguments are passed

if [ $# -ne 4 ]; then
    echo "Usage: optvideo <input_file> <out_width> <encoder>          <out_folder>"
    echo "Ex:    optvideo input.mp4    1920        x265|x264|vp9|av1  ~/Videos"
    exit 1
fi

# Get the filename without the file extension
FILENAME=${1%%.*}
ENCODER=$3

echo "Transcode $1 to $4/, output width: $2, using: $3 ?  [Y/n]"
read -r ans
[ "$ans" = "N" ] || [ "$ans" = "n" ] && echo "Aborting.." && exit 1

case $ENCODER in
    x264)
        # default 264 crf: 23,
        ffmpeg -i "$1" -c:v libx264    -vf scale=$2:-2 -preset slow -crf 24 		    -c:a copy "$4/${FILENAME}_h264.mp4" ;;
    x265)
        # default 265 crf:28, hvc1 tags are to support Apple devices
        ffmpeg -i "$1" -c:v libx265	   -vf scale=$2:-2 -preset slow -crf 29 -tag:v hvc1 -c:a copy "$4/${FILENAME}_h265.mp4" ;;
    vp9)
        # crf 31 recommended for 1080p, b:v 0 needs to be used to trigger crf mode
        ffmpeg -i "$1" -c:v libvpx-vp9 -vf scale=$2:-2		        -crf 32 -b:v 0      -c:a copy "$4/${FILENAME}_vp9.webm" ;;
    av1)
        # default svt-av1 crf:50
        ffmpeg -i "$1" -c:v libsvtav1  -vf scale=$2:-2 -preset 5    -crf 50             -c:a libopus -b:a 128k "$4/${FILENAME}_av1.mkv" ;;
    *)
        echo "Available encoders: x264, x265, vp9, av1" ;;
esac
