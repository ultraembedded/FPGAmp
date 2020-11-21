# FPGA Media Player

This project is a FPGA based media player which is capable of playing [Motion JPEG](https://en.wikipedia.org/wiki/Motion_JPEG) encoded video over HDMI or VGA on commonly available FPGA boards.

![](docs/demo.png)

## Features
* 1280x720 [720p50 / 'standard HD'] 25fps video (also supports 24fps)
* 44.1KHz stereo audio (I2S or SPDIF)
* Hardware accelerated JPEG decoding
* SD/MMC card interface (FAT16/32 support)
* MP3 playback (SW codec)
* JPEG stills display
* IR remote control

## Rationale
*Why?* For the fun of it!  
This project was an interesting test case for a number of my open-source digital IPs (RISC-V CPU, audio+video controllers), and also brings together various SW projects that I had written in years past (RTOS, FAT32 library).

## Supported Hardware
* [Digilent Arty A7](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/start) + [PMOD I2S2](https://reference.digilentinc.com/reference/pmod/pmodi2s2/start) + [PMOD MicroSD](https://reference.digilentinc.com/reference/pmod/pmodmicrosd/start) + [PMOD VGA](https://reference.digilentinc.com/reference/pmod/pmodvga/start) or PMOD2HDMI Breakout Cable + IR receiver

![ArtyA7](docs/arty.png)

## Cloning

This repo contains submodules.  
Make sure to clone them all with the following command;

```
git clone --recursive https://github.com/ultraembedded/FPGAmp.git

```

## Block Diagram
![Block Diagram](docs/block_diagram.png)

## Project Files

The FPGA gateware for this project is constructed from various sub-projects;
* [CPU - RISC-V](https://github.com/ultraembedded/riscv)
* [Peripherals](https://github.com/ultraembedded/core_soc)
* [UART -> AXI Debug Bridge](https://github.com/ultraembedded/core_dbg_bridge)
* [SD/MMC interface](https://github.com/ultraembedded/core_mmc)
* [JPEG decoder](https://github.com/ultraembedded/core_jpeg_decoder)
* [Audio controller](https://github.com/ultraembedded/core_audio)
* [DVI framebuffer](https://github.com/ultraembedded/core_dvi_framebuffer)

On the firmware side, this project uses;
* [Custom RTOS](https://github.com/ultraembedded/librtos)
* [FAT32 Library](https://github.com/ultraembedded/fat_io_lib)
* [MP3 decoder](https://github.com/ultraembedded/libhelix-mp3)
* [LVGL User Interface](https://github.com/lvgl/lvgl)

## Getting Started

The firmware needs to be built with the 32-bit RISC-V (RVIM) GCC;
```
# 1. Build firmware
cd firmware/app
make

# 2. Copy firmware/app/build.riscv.boot/boot.bin to a FAT32 SD card
```

The bootROM in the FPGA fabric will automatically load 'boot.bin' from the SD card root directory.  
**NOTE**: The SD card must be formatted as FAT16 or FAT32 and not EXFAT!

Debug messages will be comming out of the ArtyA7 USB-UART @ 1M baud (8N1).

## IR Remote
The project can be controlled via an IR remote (NEC protocol, currently).  
The IR codes are device-specific but can be changed here;
```
// firmware/app/ir_decode.h
#define IR_CMD_RIGHT    0x20df609f
#define IR_CMD_LEFT     0x20dfe01f
#define IR_CMD_DOWN     0x20df827d
#define IR_CMD_UP       0x20df02fd
#define IR_CMD_BACK     0x20df14eb
```

Handily, the UART outputs any received IR codes so it is relatively straight forward to tune the controls to a new remote.

![IR Connection](docs/ir_conn.png)
