#include <stdio.h>
#include "gpio.h"
#include "hr_timer.h"
#include "irq_ctrl.h"
#include "ir_decode.h"
#include "assert.h"

#include "kernel/critical.h"
#include "kernel/os_assert.h"
#include "kernel/list.h"
#include "kernel/thread.h"
#include "kernel/mutex.h"
#include "kernel/semaphore.h"
#include "kernel/event.h"
#include "kernel/mutex.h"
#include "kernel/mailbox.h"

#define GPIO_EDGE_FALLING(pin) gpio_configure_int(pin, 1, 1, 0)
#define GPIO_EDGE_RISING(pin)  gpio_configure_int(pin, 1, 1, 1)

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static struct semaphore m_sema;
static int    m_irq_num;
static int    m_pin;

MAILBOX_DECL(ir_cmd, 4);

static uint32_t m_last_time = 0;
static int      m_last_pin  = 1;
static int      m_bit_count = 0;
static uint32_t m_ir_code;
static int      m_last_delta = 0;
static uint32_t m_last_cmd_time = 0;
static uint32_t m_last_ir_code  = 0;

//-----------------------------------------------------------------
// ir_irq_handler: IR pin transition
//-----------------------------------------------------------------
static void* ir_irq_handler(void *ctx, int irq_number)
{
    int      pin_val  = gpio_input_bit(m_pin);
    uint32_t now      = hrtimer_now();
    int      delta_us = hrtimer_diffus(now, m_last_time);
    m_last_time = now;

    if (m_last_pin)
    {
        assert(pin_val == 0);

        // Leader code
        if (delta_us >= 4000)
        {
            m_bit_count = 0;
            m_ir_code   = 0;
        }
        else
            m_bit_count++;

        // Shift data PCM data in
        int v = (delta_us <= 1000) ? 0 : 1;
        m_ir_code <<= 1;
        m_ir_code |= v;

        // Full IR code received
        if (m_bit_count == 32)
        {
            m_last_cmd_time = now;
            m_last_ir_code  = m_ir_code;
            semaphore_post_irq(&m_sema);
        }
        // Detect repeat code
        else if (m_bit_count == 1 && m_last_delta >= 9000 && delta_us >= 2000 && hrtimer_diffus(now, m_last_cmd_time) > 100000)
        {
            m_ir_code = m_last_ir_code;
            m_last_cmd_time = now;
            semaphore_post_irq(&m_sema);
        }

        // Detect rising edge
        GPIO_EDGE_RISING(m_pin);
        gpio_interrupt_ack(1 << m_pin);
        irqctrl_acknowledge(m_irq_num);
    }
    else
    {
        assert(pin_val == 1);

        // Detect falling edge
        GPIO_EDGE_FALLING(m_pin);
        gpio_interrupt_ack(1 << m_pin);
        irqctrl_acknowledge(m_irq_num);
        irqctrl_enable_irq(m_irq_num, 1);
    }
    m_last_pin   = pin_val;
    m_last_delta = delta_us;

    return ctx;
}
//-----------------------------------------------------------------
// ir_decode_init: 
//-----------------------------------------------------------------
void ir_decode_init(int pin, int irq_number)
{
    m_pin     = pin;
    m_irq_num = irq_number;

    gpio_enable_outputs(0);
    GPIO_EDGE_FALLING(m_pin);
    gpio_interrupt_ack(1 << m_pin);

    // Hookup GPIO interrupt handler
    irqctrl_set_handler(m_irq_num, ir_irq_handler);

    // Reset and enable
    irqctrl_acknowledge(m_irq_num);
    irqctrl_enable_irq(m_irq_num, 1);
}
//-----------------------------------------------------------------
// ir_decode_thread: 
//-----------------------------------------------------------------
void *ir_decode_thread(void *arg)
{
    while (1)
    {
        // Wait for IRQ
        semaphore_pend(&m_sema);
        mailbox_post(&mbox_ir_cmd, (void*)(uint32_t)m_ir_code);
    }
}
//-----------------------------------------------------------------
// ir_ready: 
//-----------------------------------------------------------------
int ir_ready(void)
{
    return mbox_ir_cmd.count != 0;
}
//-----------------------------------------------------------------
// ir_pop: 
//-----------------------------------------------------------------
uint32_t ir_pop(void)
{
    uint32_t value = 0;
    mailbox_pend(&mbox_ir_cmd, (void*)&value);
    return value;
}