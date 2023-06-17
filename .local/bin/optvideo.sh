#!/bin/sh

# Script accepts four arguments: input file, width in pixels of output video, encoder, and output folder
# Check that all arguments are passed

if [ $# -ne 4 ]; then
    echo "Usage: optvideo <input_file> <out_width> <encoder>      <out_folder>"
    echo "Ex:    optvideo input.mp4    1920        x265|x264|vp9  ~/Videos"
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
        ffmpeg -i "$1" -c:v libx264 -preset slow -crf 24 -vf scale=$2:-2 			-c:a copy "$4/${FILENAME}_h264.mp4" ;;
    x265)
        ffmpeg -i "$1" -c:v libx265 			 -crf 28 -vf scale=$2:-2 -tag:v hvc1 -c:a copy "$4/${FILENAME}_h265.mp4" ;;
    av1)
        ffmpeg -i "$1" -c:v libsvtav1 -preset 4  -crf 28 -vf scale=$2:-2 -pix_fmt yuv420p10le -c:a libopus -b:a 128k "$4/${FILENAME}_av1.mkv" ;;
    vp9)
        ffmpeg -i "$1" -c:v libvpx-vp9 			 -crf 40 -vf scale=$2:-2 			-c:a copy "$4/${FILENAME}.webm" ;;
    *)
        echo "Available encoders: x264, x265, vp9, av1" ;;
esac
