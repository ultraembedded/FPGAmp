#ifndef __SD_H__
#define __SD_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------

// sd_init: Return 0 on success, non zero of failure 
int sd_init(void);

// sd_writesector: Return 1 on success, 0 on failure
int sd_writesector(uint32_t sector, uint8_t *buffer, uint32_t sector_count);

// sd_readsector: Return 1 on success, 0 on failure
int sd_readsector(uint32_t sector, uint8_t *buffer, uint32_t sector_count);

// Async IO reads
int  sd_readsector_dma_start(uint32_t start_block, uint8_t *buffer, uint32_t sector_count);
int  sd_readsector_dma_end(void);
void sd_readsector_dma_reset(void);

#endif
