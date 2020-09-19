#include "csr.h"
#include "exception.h"
#ifdef CONFIG_UARTLITE
#include "uart_lite.h"
#endif
#ifdef CONFIG_IRQCTRL
#include "irq_ctrl.h"
#endif

#ifdef CONFIG_MALLOC
#include "malloc.h"
#endif

#ifdef CONFIG_MALLOC
static uint8_t _heap[CONFIG_MALLOC_SIZE];
#endif

//-----------------------------------------------------------------
// init:
//-----------------------------------------------------------------
void init(void)
{
#ifdef CONFIG_UARTLITE
    // Setup serial port
    uartlite_init(CONFIG_UARTLITE_BASE, 0);

    // Register serial driver with printf
    printf_register(uartlite_putc);
#endif

#if defined (CONFIG_MALLOC)
    malloc_init(_heap, CONFIG_MALLOC_SIZE, 0, 0);
#endif

#ifdef CONFIG_IRQCTRL
    irqctrl_init(CONFIG_IRQCTRL_BASE);
#endif
}
