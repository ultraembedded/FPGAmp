## Scripts

Convert various video input file formats to a MJPEG container format supported by FPGAmp (requires ffmpeg and jpegtran)

```
# Convert input video file (input.avi) to required resolution and convert to MJPEG container
./convert.py -i input.avi -o output.mjpg

# ... Copy output.mjpg to the SD/MMC card so that it is playable...
```
