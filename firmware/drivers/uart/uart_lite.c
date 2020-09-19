#include "uart_lite.h"

// Compatible with Xilinx AXI UART Lite IP
#ifdef CONFIG_UARTLITE

#ifndef CONFIG_UARTLITE_BASE
#define CONFIG_UARTLITE_BASE 0x92000000
#endif

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
#define ULITE_RX          0x0
    #define ULITE_RX_DATA_SHIFT                  0
    #define ULITE_RX_DATA_MASK                   0xff

#define ULITE_TX          0x4
    #define ULITE_TX_DATA_SHIFT                  0
    #define ULITE_TX_DATA_MASK                   0xff

#define ULITE_STATUS      0x8
    #define ULITE_STATUS_IE                      4
    #define ULITE_STATUS_IE_SHIFT                4
    #define ULITE_STATUS_IE_MASK                 0x1

    #define ULITE_STATUS_TXFULL                  3
    #define ULITE_STATUS_TXFULL_SHIFT            3
    #define ULITE_STATUS_TXFULL_MASK             0x1

    #define ULITE_STATUS_TXEMPTY                 2
    #define ULITE_STATUS_TXEMPTY_SHIFT           2
    #define ULITE_STATUS_TXEMPTY_MASK            0x1

    #define ULITE_STATUS_RXFULL                  1
    #define ULITE_STATUS_RXFULL_SHIFT            1
    #define ULITE_STATUS_RXFULL_MASK             0x1

    #define ULITE_STATUS_RXVALID                 0
    #define ULITE_STATUS_RXVALID_SHIFT           0
    #define ULITE_STATUS_RXVALID_MASK            0x1

#define ULITE_CONTROL     0xc
    #define ULITE_CONTROL_IE                     4
    #define ULITE_CONTROL_IE_SHIFT               4
    #define ULITE_CONTROL_IE_MASK                0x1

    #define ULITE_CONTROL_RST_RX                 1
    #define ULITE_CONTROL_RST_RX_SHIFT           1
    #define ULITE_CONTROL_RST_RX_MASK            0x1

    #define ULITE_CONTROL_RST_TX                 0
    #define ULITE_CONTROL_RST_TX_SHIFT           0
    #define ULITE_CONTROL_RST_TX_MASK            0x1

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static volatile uint32_t *m_uart;

//-----------------------------------------------------------------
// uartlite_init: Initialise UART peripheral
//-----------------------------------------------------------------
void uartlite_init(uint32_t base_addr, uint32_t baud_rate)           
{
    uint32_t cfg = 0;
    m_uart = (volatile uint32_t *)base_addr;

    // Soft reset
    cfg += (1 << ULITE_CONTROL_RST_RX_SHIFT);
    cfg += (1 << ULITE_CONTROL_RST_TX_SHIFT);
    cfg += (1 << ULITE_CONTROL_IE_SHIFT);

    m_uart[ULITE_CONTROL/4]  = cfg;
}
//-----------------------------------------------------------------
// uartlite_putc: Polled putchar
//-----------------------------------------------------------------
int uartlite_putc(char c)
{
    // While TX FIFO full
    while (m_uart[ULITE_STATUS/4] & (1 << ULITE_STATUS_TXFULL_SHIFT))
        ;

    m_uart[ULITE_TX/4] = c;

    return 0;
}
//-----------------------------------------------------------------
// uartlite_haschar:
//-----------------------------------------------------------------
int uartlite_haschar(void)
{
    return (m_uart[ULITE_STATUS/4] & (1 << ULITE_STATUS_RXVALID_SHIFT)) != 0;
}
//-----------------------------------------------------------------
// uartlite_getchar: Read character from UART
//-----------------------------------------------------------------
int uartlite_getchar(void)
{
    if (uartlite_haschar())
        return (uint8_t)m_uart[ULITE_RX/4];
    else
        return -1;
}
#ifdef CONFIG_UARTLITE_CONSOLE
//-----------------------------------------------------------------
// console_init:
//-----------------------------------------------------------------
void console_init(uint32_t baud)
{
    uartlite_init(CONFIG_UARTLITE_BASE, baud);    
}
//-----------------------------------------------------------------
// console_putchar:
//-----------------------------------------------------------------
void console_putchar(int ch)
{
    uartlite_putc(ch);
}
//-----------------------------------------------------------------
// console_getchar: Get input or return -1 if none available
//-----------------------------------------------------------------
int console_getchar(int ch)
{ 
    return uartlite_getchar();
}
#endif

#endif
