#include "irq_ctrl.h"

#ifdef CONFIG_IRQCTRL
#include "exception.h"
#include "csr.h"
#include "assert.h"

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
#define IRQ_ISR           0x0
    #define IRQ_ISR_STATUS_SHIFT                 0
    #define IRQ_ISR_STATUS_MASK                  0xf

#define IRQ_IPR           0x4
    #define IRQ_IPR_PENDING_SHIFT                0
    #define IRQ_IPR_PENDING_MASK                 0xf

#define IRQ_IER           0x8
    #define IRQ_IER_ENABLE_SHIFT                 0
    #define IRQ_IER_ENABLE_MASK                  0xf

#define IRQ_IAR           0xc
    #define IRQ_IAR_ACK_SHIFT                    0
    #define IRQ_IAR_ACK_MASK                     0xf

#define IRQ_SIE           0x10
    #define IRQ_SIE_SET_SHIFT                    0
    #define IRQ_SIE_SET_MASK                     0xf

#define IRQ_CIE           0x14
    #define IRQ_CIE_CLR_SHIFT                    0
    #define IRQ_CIE_CLR_MASK                     0xf

#define IRQ_IVR           0x18
    #define IRQ_IVR_VECTOR_SHIFT                 0
    #define IRQ_IVR_VECTOR_MASK                  0xffffffff

#define IRQ_MER           0x1c
    #define IRQ_MER_ME                           0
    #define IRQ_MER_ME_SHIFT                     0
    #define IRQ_MER_ME_MASK                      0x1

//-----------------------------------------------------------------
// RISC-V Superdefs
//-----------------------------------------------------------------
#define IRQ_S_SOFT   1
#define IRQ_M_SOFT   3
#define IRQ_S_TIMER  5
#define IRQ_M_TIMER  7
#define IRQ_S_EXT    9
#define IRQ_M_EXT    11

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static volatile uint32_t *m_irq;

#define IRQ_MAX      32
static fp_irq_func        m_irq_table[IRQ_MAX];

//-----------------------------------------------------------------
// irqctrl_handler: Interrupt handler
//-----------------------------------------------------------------
struct irq_context * irqctrl_handler(struct irq_context *ctx)
{
    int irq_num = m_irq[IRQ_IVR/4];

    if (irq_num != -1)
    {
        assert(m_irq_table[irq_num]);
        ctx = (struct irq_context *)m_irq_table[irq_num](ctx, irq_num);

        // Ack IRQ
        m_irq[IRQ_IAR/4] = 1 << irq_num;
    }

    csr_irq_ack(1 << 11); // M_EXT
    return ctx;
}
//-----------------------------------------------------------------
// irqctrl_get_irq: Get highest priority pending IRQ
//-----------------------------------------------------------------
int irqctrl_get_irq(void)
{
    return m_irq[IRQ_IVR/4];
}
//-----------------------------------------------------------------
// irqctrl_enable_irq: Enable IRQ
//-----------------------------------------------------------------
void irqctrl_enable_irq(int irq, int enable)
{
    if (enable)
        m_irq[IRQ_SIE/4] = (1 << irq);
    else
        m_irq[IRQ_CIE/4] = (1 << irq);
}
//-----------------------------------------------------------------
// irqctrl_acknowledge: Acknowledge IRQ
//-----------------------------------------------------------------
void irqctrl_acknowledge(int irq)
{
    // Ack IRQ
    m_irq[IRQ_IAR/4] = 1 << irq;

    csr_irq_ack(1 << 11); // M_EXT
}
//-----------------------------------------------------------------
// irqctrl_sw_int: Generate SW IRQ
//-----------------------------------------------------------------
void irqctrl_sw_int(int irq)
{
    m_irq[IRQ_ISR/4] = (1 << irq);
}
//-----------------------------------------------------------------
// irqctrl_set_handler: Setup IRQ handler
//-----------------------------------------------------------------
void irqctrl_set_handler(int irq, fp_irq_func handler)
{
    m_irq_table[irq] = handler;
}
//-----------------------------------------------------------------
// irqctrl_init: Initialise IRQ peripheral
//-----------------------------------------------------------------
void irqctrl_init(uint32_t base_addr)
{
    uint32_t cfg = 0;
    m_irq = (volatile uint32_t *)base_addr;

    // Interrupt off
    m_irq[IRQ_CIE/4] = ~0;

    // Interrupts ack'd
    m_irq[IRQ_IAR/4] = ~0;

    // Register interrupt handler
    exception_set_irq_handler(irqctrl_handler);

    // Reset current state
    csr_irq_ack(~0);

    csr_set_irq_enable();

    // Enable external interrupts
    csr_set_irq_mask(1 << IRQ_M_EXT);

    // Global interrupt enable
    m_irq[IRQ_MER/4] = (1 << IRQ_MER_ME_SHIFT);
}
#endif
