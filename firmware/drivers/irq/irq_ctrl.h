#ifndef __IRQ_CTRL_H__
#define __IRQ_CTRL_H__

#include <stdint.h>
#include "exception.h"

//-----------------------------------------------------------------
// Types
//-----------------------------------------------------------------
typedef void* (*fp_irq_func)(void *ctx, int irq);

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void irqctrl_init(uint32_t base_addr);
int  irqctrl_get_irq(void);
void irqctrl_enable_irq(int irq, int enable);
void irqctrl_set_handler(int irq, fp_irq_func handler);
void irqctrl_acknowledge(int irq);
void irqctrl_sw_int(int irq);

struct irq_context * irqctrl_handler(struct irq_context *ctx);

#endif
