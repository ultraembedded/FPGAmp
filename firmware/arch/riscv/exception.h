#ifndef __EXCEPTION_H__
#define __EXCEPTION_H__

#include <stdint.h>
#include "csr.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define REG_RA                         1
#define REG_SP                         2
#define REG_ARG0                       10
#define REG_RET                        REG_ARG0
#define NUM_GP_REG                     32
#define NUM_CSR_REG                    3

#define CAUSE_MISALIGNED_FETCH         0
#define CAUSE_FAULT_FETCH              1
#define CAUSE_ILLEGAL_INSTRUCTION      2
#define CAUSE_BREAKPOINT               3
#define CAUSE_MISALIGNED_LOAD          4
#define CAUSE_FAULT_LOAD               5
#define CAUSE_MISALIGNED_STORE         6
#define CAUSE_FAULT_STORE              7
#define CAUSE_ECALL_U                  8
#define CAUSE_ECALL_S                  9
#define CAUSE_ECALL_M                  11
#define CAUSE_PAGE_FAULT_INST          12
#define CAUSE_PAGE_FAULT_LOAD          13
#define CAUSE_PAGE_FAULT_STORE         15
#define CAUSE_INTERRUPT                (1 << 31)

//-----------------------------------------------------------------
// Types:
//-----------------------------------------------------------------
struct irq_context
{
    uint32_t pc;
    uint32_t status;
    uint32_t cause;
    uint32_t reg[NUM_GP_REG];
};

typedef struct irq_context *(*fp_exception)(struct irq_context *ctx);
typedef struct irq_context *(*fp_irq)(struct irq_context *ctx);
typedef struct irq_context *(*fp_syscall)(struct irq_context *ctx);

//-----------------------------------------------------------------
// context_irq_enable: Set future interrupt enable
//-----------------------------------------------------------------
static void context_irq_enable(struct irq_context *ctx, int enable)
{
    // MPIE becomes MIE on return from exception
    ctx->status &= ~SR_MPIE;
    ctx->status |= (enable ? SR_MPIE : 0);
}

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
struct irq_context * exception_handler(struct irq_context *ctx);
void                 exception_set_irq_handler(fp_irq irq_handler);
fp_irq               exception_get_irq_handler(void);
void                 exception_set_timer_handler(fp_irq irq_handler);
void                 exception_set_syscall_handler(fp_syscall syscall_handler);
void                 exception_set_handler(int cause, fp_exception handler);
void                 exception_dump_ctx(struct irq_context *ctx);
struct irq_context * exception_makecontext(uint32_t *stack, uint32_t stack_size, void (*func)(), void *arg);
void                 exception_return(struct irq_context *ucp);
void                 exception_syscall(uint32_t arg, ...);

#endif

