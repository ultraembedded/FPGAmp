#ifndef __IR_DECODE_H__
#define __IR_DECODE_H__

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
// Specific to particular remote control
#define IR_CMD_RIGHT    0x20df609f
#define IR_CMD_LEFT     0x20dfe01f
#define IR_CMD_DOWN     0x20df827d
#define IR_CMD_UP       0x20df02fd
#define IR_CMD_BACK     0x20df14eb

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void     ir_decode_init(int pin, int irq_number);
void *   ir_decode_thread(void *arg);
int      ir_ready(void);
uint32_t ir_pop(void);

#endif
