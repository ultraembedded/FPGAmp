#include "uart_sim.h"

// Simulator only fast putchar()
#ifdef CONFIG_SIMUART
#include "csr.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define CSR_SIM_CTRL_EXIT (0 << 24)
#define CSR_SIM_CTRL_PUTC (1 << 24)
#define CSR_SIM_CTRL_GETC (2 << 24)

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static int _rx_char = -1;

//-----------------------------------------------------------------
// uartsim_init:
//-----------------------------------------------------------------
void uartsim_init(void)
{
    _rx_char = -1;
}
//-----------------------------------------------------------------
// uartsim_putc: Polled putchar to virtual UART
//-----------------------------------------------------------------
int uartsim_putc(char ch)
{
    uint32_t arg = CSR_SIM_CTRL_PUTC | (ch & 0xFF);
    csr_write(dscratch, arg);
    return 0;
}
//-----------------------------------------------------------------
// uartsim_haschar:
//-----------------------------------------------------------------
int uartsim_haschar(void)
{
    uint32_t val = CSR_SIM_CTRL_GETC;
    _rx_char     = (int)csr_swap(dscratch, val);

    return _rx_char != -1;
}
//-----------------------------------------------------------------
// uartsim_getchar: Read character from virtual UART
//-----------------------------------------------------------------
int uartsim_getchar(void)
{
    if (uartsim_haschar())
        return _rx_char;
    else
        return -1;
}
#ifdef CONFIG_SIMUART_CONSOLE
//-----------------------------------------------------------------
// console_init:
//-----------------------------------------------------------------
void console_init(uint32_t baud)
{
    uartsim_init();
}
//-----------------------------------------------------------------
// console_putchar:
//-----------------------------------------------------------------
void console_putchar(int ch)
{
    uartsim_putc(ch);
}
//-----------------------------------------------------------------
// console_getchar: Get input or return -1 if none available
//-----------------------------------------------------------------
int console_getchar(int ch)
{ 
    return uartsim_getchar();
}
#endif
#endif
