#ifndef __UART_SIM_H__
#define __UART_SIM_H__

#include <stdint.h>

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void uartsim_init(void);
int  uartsim_putc(char c);
int  uartsim_haschar(void);
int  uartsim_getchar(void);

#endif
