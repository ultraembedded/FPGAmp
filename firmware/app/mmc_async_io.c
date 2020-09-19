#include <stdio.h>
#include <stdint.h>
#include "assert.h"
#include "csr.h"
#include "sd.h"

#include "kernel/critical.h"
#include "kernel/os_assert.h"
#include "kernel/list.h"
#include "kernel/thread.h"
#include "kernel/mutex.h"
#include "kernel/semaphore.h"
#include "kernel/event.h"
#include "kernel/mutex.h"
#include "kernel/mailbox.h"

#include "irq_ctrl.h"

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static struct semaphore m_mmc_sema;
static int              m_irq_num;
static int              m_max_sectors;

//-----------------------------------------------------------------
// mmc_irq_handler: Low level IRQ handler (operation complete)
//-----------------------------------------------------------------
static void* mmc_irq_handler(void *ctx, int irq)
{
    semaphore_post_irq(&m_mmc_sema);

    // Reset and disable
    irqctrl_acknowledge(m_irq_num);
    irqctrl_enable_irq(m_irq_num, 0);
    return ctx;
}
//-----------------------------------------------------------------
// mmc_async_io_init: Initialisation
//-----------------------------------------------------------------
void mmc_async_io_init(int irq_num, int max_sectors)
{
    semaphore_init(&m_mmc_sema, 0);
    m_irq_num     = irq_num;
    m_max_sectors = max_sectors;

    // Hookup SD/MMC interrupt handler
    irqctrl_set_handler(m_irq_num, mmc_irq_handler);

    // Reset and disable
    irqctrl_acknowledge(m_irq_num);
    irqctrl_enable_irq(m_irq_num, 0);
}
//-----------------------------------------------------------------
// mmc_async_io_read: MMC read using DMA with thread yield
//-----------------------------------------------------------------
int mmc_async_io_read(uint32_t start_block, uint8_t *buffer, uint32_t sector_count)
{
    uint32_t remain = sector_count;

    while (remain)
    {
        uint32_t count = remain;
        if (count >= m_max_sectors)
            count = m_max_sectors;

        // Reset and enable IRQ
        irqctrl_acknowledge(m_irq_num);
        irqctrl_enable_irq(m_irq_num, 1);

        // Start async transfer
        sd_readsector_dma_start(start_block, buffer, count);
        buffer      += (512 * count);
        start_block += count;
        remain      -= count;

        // Wait for completion
        if (!semaphore_timed_pend(&m_mmc_sema, 1000))
        {
            assert(!"ERROR: SD card timeout");
        }

        // Close async transfer after completion
        sd_readsector_dma_end();
    }

    return 1;
}
