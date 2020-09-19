#ifndef __MMC_ASYNC_IO_H__
#define __MMC_ASYNC_IO_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void mmc_async_io_init(int irq_num, int max_sectors);
int  mmc_async_io_read(uint32_t start_block, uint8_t *buffer, uint32_t sector_count);

#endif
