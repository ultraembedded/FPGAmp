# FPGA Media Player Project

This project is a FPGA based media player which is capable of playing [Motion JPEG](https://en.wikipedia.org/wiki/Motion_JPEG) encoded video over HDMI or VGA on commonly available FPGA boards.

![](docs/demo.png)

## Features
* 800x600 25fps video (higher resolutions may also be possible)
* 44.1KHz stereo audio (I2S or SPDIF)
* Hardware accelerated JPEG decoding
* SD/MMC card interface
* MP3 playback
* IR remote control

## Supported Hardware
* [Digilent Arty A7](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/start)

## Cloning

This repo contains submodules.  
Make sure to clone them all with the following command;

```
git clone --recursive https://github.com/ultraembedded/FPGAmp.git

```

## Project Files

The FPGA gateware for this project is constructed from various sub-projects;
* [CPU - RISC-V](https://github.com/ultraembedded/riscv)
* [Peripherals](https://github.com/ultraembedded/core_soc)
* [UART -> AXI Debug Bridge](https://github.com/ultraembedded/core_dbg_bridge)
* [SD/MMC interface](https://github.com/ultraembedded/core_mmc)
* [JPEG decoder](https://github.com/ultraembedded/core_jpeg_decoder)
* [Audio controller](https://github.com/ultraembedded/core_audio)

On the firmware side, this project uses;
* [RTOS](https://github.com/ultraembedded/librtos)
* [FAT32 Library](https://github.com/ultraembedded/fat_io_lib)
* [MP3 decoder](https://github.com/ultraembedded/libhelix-mp3)
* [LVGL User Interface](https://github.com/lvgl/lvgl)
