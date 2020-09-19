#ifndef __GPIO_H__
#define __GPIO_H__

#include <stdint.h>

#ifndef GPIO_BASE
    #define GPIO_BASE       0x94000000
#endif

//-----------------------------------------------------------------
// GPIO Registers
//-----------------------------------------------------------------
#define GPIO_DIRECTION    0x0
    #define GPIO_DIRECTION_OUTPUT_SHIFT          0
    #define GPIO_DIRECTION_OUTPUT_MASK           0xffffffff

#define GPIO_INPUT        0x4
    #define GPIO_INPUT_VALUE_SHIFT               0
    #define GPIO_INPUT_VALUE_MASK                0xffffffff

#define GPIO_OUTPUT       0x8
    #define GPIO_OUTPUT_DATA_SHIFT               0
    #define GPIO_OUTPUT_DATA_MASK                0xffffffff

#define GPIO_OUTPUT_SET   0xc
    #define GPIO_OUTPUT_SET_DATA_SHIFT           0
    #define GPIO_OUTPUT_SET_DATA_MASK            0xffffffff

#define GPIO_OUTPUT_CLR   0x10
    #define GPIO_OUTPUT_CLR_DATA_SHIFT           0
    #define GPIO_OUTPUT_CLR_DATA_MASK            0xffffffff

#define GPIO_INT_MASK     0x14
    #define GPIO_INT_MASK_ENABLE_SHIFT           0
    #define GPIO_INT_MASK_ENABLE_MASK            0xffffffff

#define GPIO_INT_SET      0x18
    #define GPIO_INT_SET_SW_IRQ_SHIFT            0
    #define GPIO_INT_SET_SW_IRQ_MASK             0xffffffff

#define GPIO_INT_CLR      0x1c
    #define GPIO_INT_CLR_ACK_SHIFT               0
    #define GPIO_INT_CLR_ACK_MASK                0xffffffff

#define GPIO_INT_STATUS   0x20
    #define GPIO_INT_STATUS_RAW_SHIFT            0
    #define GPIO_INT_STATUS_RAW_MASK             0xffffffff

#define GPIO_INT_LEVEL    0x24
    #define GPIO_INT_LEVEL_ACTIVE_HIGH_SHIFT     0
    #define GPIO_INT_LEVEL_ACTIVE_HIGH_MASK      0xffffffff

#define GPIO_INT_MODE     0x28
    #define GPIO_INT_MODE_EDGE_SHIFT             0
    #define GPIO_INT_MODE_EDGE_MASK              0xffffffff

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------

// Write word to GPIO outputs
static inline void gpio_output_write(uint32_t value)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    gpio[GPIO_OUTPUT/4] = value;
}

// Set (high) specific pins (1 = high, 0 = unchanged)
static inline void gpio_output_set(uint32_t mask)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    gpio[GPIO_OUTPUT_SET/4] = mask;
}

// Clear (low) specific pins (1 = low, 0 = unchanged)
static inline void gpio_output_clr(uint32_t mask)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    gpio[GPIO_OUTPUT_CLR/4] = mask;
}

// Read GPIO inputs
static inline uint32_t gpio_input_read(void)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    return gpio[GPIO_INPUT/4];
}

// Read specific GPIO pin (0 - 31)
static inline uint32_t gpio_input_bit(int bit)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    return (gpio[GPIO_INPUT/4] & (1 << bit)) != 0;
}

// Configure GPIO direction (1 = output, 0 = input)
static inline void gpio_enable_outputs(uint32_t mask)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    gpio[GPIO_DIRECTION/4] = mask;
}

// Configure GPIO interrupts
static inline void gpio_configure_int(int bit, int enabled, int edge_not_level, int active_high_rising)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    uint32_t current;

    // Enable
    current = gpio[GPIO_INT_MASK/4];
    if (enabled)
        current |= (1 << bit);
    else
        current &= ~(1 << bit);
    gpio[GPIO_INT_MASK/4] = current;

    current = gpio[GPIO_INT_LEVEL/4];
    if (active_high_rising)
        current |= (1 << bit);
    else
        current &= ~(1 << bit);
    gpio[GPIO_INT_LEVEL/4] = current;

    current = gpio[GPIO_INT_MODE/4];
    if (edge_not_level)
        current |= (1 << bit);
    else
        current &= ~(1 << bit);
    gpio[GPIO_INT_MODE/4] = current;
}

// Clear bitmap of interrupts
static inline void gpio_interrupt_ack(uint32_t mask)
{
    volatile uint32_t * gpio = (volatile uint32_t * )GPIO_BASE;
    gpio[GPIO_INT_CLR/4] = mask;
}

#endif
