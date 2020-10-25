#!/usr/bin/env python3
import sys
import argparse
import os
from subprocess import run, PIPE

##################################################################
# Main
##################################################################
def main(argv):
    
    input_files = []

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', dest='input',  required=True,  help='Input file')
    parser.add_argument('-o', dest='output', required=True,  help='Output file')
    parser.add_argument('--width',  dest='width',  type=int, default=800, help='Video output width')
    parser.add_argument('--height', dest='height', type=int, default=600, help='Video output height')
    parser.add_argument('--fps',    dest='fps',    type=int, default=25,  help='Video source FPS')
    args = vars(parser.parse_args())

    input_file = args['input']
    output_file = args['output']

    # Calculate audio samples per frame
    frames_per_block        = 128
    audio_samples_per_frame = 44100 / args['fps']

    # Audio samples per frame not exact (this is meant to support 25 or 24 FPS)
    partial_audio = False
    if int(audio_samples_per_frame) != audio_samples_per_frame:
        partial_audio = True

    # 16-bit x 2
    audio_block_size = int(audio_samples_per_frame) * 4

    # Remove old temp files
    os.system("rm -rf output.video")
    os.system("rm -rf output.audio")
    os.system("rm -rf output.mp4")

    geometry = "%dx%d" % (args['width'], args['height'])
    print("# Convert to MP4 (scaled to %s)" % geometry)
    os.system("ffmpeg -i %s -vf scale=%s output.mp4" % (input_file, geometry))

    print("# Convert video to JPEG stream")
    os.system("ffmpeg -i output.mp4 -qscale:v 2 -f singlejpeg pipe:1 > output.video")

    print("# Convert audio to PCM")
    os.system("ffmpeg -i output.mp4 -f s16le -acodec pcm_s16le -ar 44100 output.audio")

    video_file  = 'output.video'
    audio_file  = 'output.audio'    

    print("# Transcoding to MJPEG")

    fout    = open(output_file, 'wb')
    f_video = open(video_file, "rb")
    f_audio = open(audio_file, "rb")

    # Convert to supported file format
    data       = f_video.read(1)
    last_b     = None
    found_soi  = False
    jpeg       = bytearray()
    jpeg_group = []
    frame_count= 0
    audio_idx  = 0
    print ("Starting conversion")
    while data:
        jpeg.append(data[0])

        # Detect SOI
        if not found_soi and data == b'\xd8' and last_b == b'\xff':
            found_soi = True
        # Detect EOI
        elif found_soi and data == b'\xd9' and last_b == b'\xff':
            found_soi = False

            # Transcode to baseline JPEG
            p = run(['jpegtran'], stdout=PIPE, input=bytes(jpeg))
            jpeg = bytearray(p.stdout)

            # Read an audio blob to go with video frame
            if partial_audio and (audio_idx % 2) == 1:
                audio_blob = f_audio.read(audio_block_size+4)
            else:
                audio_blob = f_audio.read(audio_block_size)
            audio_idx += 1

            # Add video + audio frame tuple to list
            jpeg_group.append((jpeg,audio_blob))

            # Reset JPEG handler
            jpeg = bytearray()

            # Progress print
            frame_count += 1
            if frame_count % 25 == 0:
                print ("\rFrame: %d" % frame_count, end='', flush=True)

        last_b = data

        # Read next JPEG stream byte
        data = f_video.read(1)

        # End of video stream or 128 video frames reached
        if len(jpeg_group) == frames_per_block or not data:
            # Build a directory of up-to 512 frames
            table = bytearray(frames_per_block*4)
            for i in range(len(jpeg_group)):
                item     = jpeg_group[i][0]
                table[(i*4)+0] = (len(item) >> 0)  & 0xFF
                table[(i*4)+1] = (len(item) >> 8)  & 0xFF
                table[(i*4)+2] = (len(item) >> 16) & 0xFF
                table[(i*4)+3] = (len(item) >> 24) & 0xFF

            # Write directory sector
            fout.write(table)

            # Write each frame out with padding and audio
            for (jpg_frame, aud_frame) in jpeg_group:
                # Video frame
                fout.write(jpg_frame)

                # Pad to nearest 512 byte multiple
                size = len(jpg_frame)
                pad  = size % 512
                if pad > 0:
                    pad = 512 - pad
                    fout.write(bytearray(pad))

                # Audio frame
                fout.write(aud_frame)

                # Pad to nearest 512 byte multiple
                audio_padded_size = (int((audio_block_size + 511) / 512) * 512)
                pad = audio_padded_size - len(aud_frame)
                if pad > 0:
                    fout.write(bytearray(pad))

            jpeg_group = []

    print ("\nEnd of conversion")

if __name__ == "__main__":
   main(sys.argv[1:])