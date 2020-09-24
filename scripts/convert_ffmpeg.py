#!/usr/bin/env python3
import os
import sys

##################################################################
# Main
##################################################################
def main(argv):

    inputfile = ''
    try:
        inputfile = argv[0]
    except:
        print('No files specified')
        sys.exit(2)

    print("# Convert to MP4 (scaled to 800x600)")
    os.system("ffmpeg -i %s -vf scale=800x600 output.mp4" % inputfile)

    print("# Convert video to JPEG stream")
    os.system("ffmpeg -i output.mp4 -vcodec mjpeg -f mjpeg pipe:1 > output.video")

    print("# Convert audio to PCM")
    os.system("ffmpeg -i output.mp4 -f s16le -acodec pcm_s16le -ar 44100 output.audio")

if __name__ == "__main__":
   main(sys.argv[1:])
