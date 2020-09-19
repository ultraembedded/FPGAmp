#include <stdint.h>
#include "assert.h"

#ifdef CONFIG_JPEG_HW
#include "jpeg_hw.h"

#ifndef CONFIG_JPEG_HW_BASE
#define CONFIG_JPEG_HW_BASE  0x97000000
#endif

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
#define JPEG_CTRL         0x0
    #define JPEG_CTRL_START                      31
    #define JPEG_CTRL_START_SHIFT                31
    #define JPEG_CTRL_START_MASK                 0x1

    #define JPEG_CTRL_ABORT                      30
    #define JPEG_CTRL_ABORT_SHIFT                30
    #define JPEG_CTRL_ABORT_MASK                 0x1

    #define JPEG_CTRL_LENGTH_SHIFT               0
    #define JPEG_CTRL_LENGTH_MASK                0xffffff

#define JPEG_STATUS       0x4
    #define JPEG_STATUS_UNDERRUN                 0
    #define JPEG_STATUS_UNDERRUN_SHIFT           0
    #define JPEG_STATUS_UNDERRUN_MASK            0x1

    #define JPEG_STATUS_OVERFLOW                 0
    #define JPEG_STATUS_OVERFLOW_SHIFT           0
    #define JPEG_STATUS_OVERFLOW_MASK            0x1

    #define JPEG_STATUS_BUSY                     0
    #define JPEG_STATUS_BUSY_SHIFT               0
    #define JPEG_STATUS_BUSY_MASK                0x1

#define JPEG_SRC          0x8
    #define JPEG_SRC_ADDR_SHIFT                  0
    #define JPEG_SRC_ADDR_MASK                   0xffffffff

#define JPEG_DST          0xc
    #define JPEG_DST_ADDR_SHIFT                  0
    #define JPEG_DST_ADDR_MASK                   0xffffffff

//-----------------------------------------------------------------
// HW access
//-----------------------------------------------------------------
static inline void jpeg_hw_write(uint32_t addr, uint32_t value)
{
    volatile uint32_t * cfg = (volatile uint32_t * )CONFIG_JPEG_HW_BASE;
    cfg[addr/4] = value;
}
static inline uint32_t jpeg_hw_read(uint32_t addr)
{
    volatile uint32_t * cfg = (volatile uint32_t * )CONFIG_JPEG_HW_BASE;
    return cfg[addr/4];
}
//-----------------------------------------------------------------
// jpeg_hw_reset: Reset HW decoder
//-----------------------------------------------------------------
void jpeg_hw_reset(void)
{
    // Reset JPEG HW state
    jpeg_hw_write(JPEG_CTRL, (1 << JPEG_CTRL_ABORT_SHIFT));
}
//-----------------------------------------------------------------
// jpeg_hw_start: Start HW decode
//-----------------------------------------------------------------
void jpeg_hw_start(uint32_t src_addr, uint32_t dst_addr, uint32_t image_size)
{
    // Reset JPEG HW state
    jpeg_hw_write(JPEG_CTRL, (1 << JPEG_CTRL_ABORT_SHIFT));

    // Set compressed source buffer details
    assert((src_addr & 0x1f) == 0);
    jpeg_hw_write(JPEG_SRC, src_addr);

    // Set uncompressed target details
    assert((dst_addr & 0x3) == 0);
    jpeg_hw_write(JPEG_DST, dst_addr);

    // Go
    jpeg_hw_write(JPEG_CTRL, (1 << JPEG_CTRL_START_SHIFT) | image_size);
}
//-----------------------------------------------------------------
// jpeg_hw_start: Start HW decode
//-----------------------------------------------------------------
int jpeg_hw_busy(void)
{
    return (jpeg_hw_read(JPEG_STATUS) & (1 << JPEG_STATUS_BUSY_SHIFT)) != 0;
}
//-----------------------------------------------------------------
// jpeg_hw_decode: Blocking JPEG decode
//-----------------------------------------------------------------
void jpeg_hw_decode(uint32_t src_addr, uint32_t dst_addr, uint32_t image_size)
{
    jpeg_hw_start(src_addr, dst_addr, image_size);
    while (jpeg_hw_busy())
        ;
}
#endif