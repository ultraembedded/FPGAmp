#ifndef __JPEG_HW_H__
#define __JPEG_HW_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void jpeg_hw_reset(void);
void jpeg_hw_start(uint32_t src_addr, uint32_t dst_addr, uint32_t image_size);
int  jpeg_hw_busy(void);
void jpeg_hw_decode(uint32_t src_addr, uint32_t dst_addr, uint32_t image_size);

#endif
