## Scripts

Convert various video input file formats to a MJPEG container format supported by FPGAmp (requires ffmpeg)

```

# Convert input video file (input.avi) to 800x600 and split to JPEG stream (output.video) and audio PCM stream (output.audio)
./convert_ffmpeg.py input.avi

# Combine JPEG stream and audio PCM stream into MJPEG container
./convert_mjpeg.py -i output.video -a output.audio -o output.mjpg

# ... Copy output.mjpg to the SD/MMC card so that it is playable...
```
