#ifndef __FB_DEV_H__
#define __FB_DEV_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
// 24 bit RGB to 16 bit RGB565
#define RGB565(r,g,b) (((r & 0xF8) << 8) | ((g & 0xFC) << 3) | ((b & 0xF8) >> 3))

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void fbdev_init(uint32_t base_addr, uint32_t frame_buffer, int width, int height, int enable, int x2_mode);
void fbdev_wait_ready(void);
void fbdev_set_framebuffer(uint32_t frame_buffer);
void fbdev_draw_pixel(uint16_t *frame, int x, int y, uint16_t colour);
void fbdev_fill_screen(uint16_t *frame, uint16_t value);
void fbdev_clear_screen(uint16_t *frame);
void fbdev_draw_bitmap(uint16_t *frame, uint8_t* bitmap, int x, int y, int width, int height, uint16_t colour, uint16_t bg_colour);

#endif