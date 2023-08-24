#!/bin/env sh
#
# some ffmpeg commands that produce random noise videos

# white noise [1Gb]
ffmpeg -filter_complex "nullsrc=s=1280x720,geq=random(1)*255:128:128[vout]" -map "[vout]" -fs 1G -c:v libx264 white-noise.mp4

# colored noise + sound [60s]
ffmpeg -f rawvideo -video_size 1280x720 -pixel_format yuv420p -framerate 30 -i /dev/urandom -ar 48000 -ac 2 -f s16le -i /dev/urandom -codec:a copy -t 60 color-noise.mov
