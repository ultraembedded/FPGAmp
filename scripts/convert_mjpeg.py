#!/usr/bin/env python3
import sys
import argparse
import os

##################################################################
# Main
##################################################################
def main(argv):
    
    input_files = []

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', dest='video',  required=True,  help='Input JPEG stream')
    parser.add_argument('-a', dest='audio',  required=True,  help='Input audio stream')
    parser.add_argument('-o', dest='output', required=True,  help='Output file')
    args = vars(parser.parse_args())

    video_file  = args['video']
    audio_file  = args['audio']
    output_file = args['output']

    frames_per_block = 128
    audio_samples_per_frame = 44100 / 25

    # 16-bit x 2
    audio_block_size = int(audio_samples_per_frame * 4)

    # Round up to sector multiple
    audio_padded_size = (int((audio_block_size + 511) / 512) * 512)

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
    print ("Starting conversion")
    while data:
        jpeg.append(data[0])

        # Detect SOI
        if not found_soi and data == b'\xd8' and last_b == b'\xff':
            found_soi = True
        # Detect EOI
        elif found_soi and data == b'\xd9' and last_b == b'\xff':
            found_soi = False

            # Read an audio blob to go with video frame
            audio_blob = f_audio.read(audio_block_size)

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
                pad = audio_padded_size - len(aud_frame)
                if pad > 0:
                    fout.write(bytearray(pad))

            jpeg_group = []

    print ("\nEnd of conversion")

if __name__ == "__main__":
   main(sys.argv[1:])
