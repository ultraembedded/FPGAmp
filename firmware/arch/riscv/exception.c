#include "exception.h"
#include "assert.h"
#include "csr.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define SR_MPP_SHIFT    11
#define SR_MPP_MASK     0x3
#define SR_MPP          (SR_MPP_MASK  << SR_MPP_SHIFT)
#define SR_MPP_M        (3 << SR_MPP_SHIFT)

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
#define CAUSE_MAX_EXC      (CAUSE_PAGE_FAULT_STORE + 1)
static fp_exception        _exception_table[CAUSE_MAX_EXC];

static fp_irq              _irq_handler     = 0;
static fp_irq              _timer_handler   = 0;

void exception_set_irq_handler(fp_irq handler)         { _irq_handler   = handler; }
fp_irq exception_get_irq_handler(void)                 { return _irq_handler; }
void exception_set_timer_handler(fp_irq handler)       { _timer_handler = handler; }
void exception_set_syscall_handler(fp_syscall handler) 
{ 
    _exception_table[CAUSE_ECALL_U] = handler;
    _exception_table[CAUSE_ECALL_S] = handler;
    _exception_table[CAUSE_ECALL_M] = handler;
}
void exception_set_handler(int cause, fp_exception handler)
{
    _exception_table[cause] = handler;
}
//-----------------------------------------------------------------
// exception_handler:
//-----------------------------------------------------------------
struct irq_context * exception_handler(struct irq_context *ctx)
{
#ifndef EXCEPTION_SP_FROM_MSCRATCH
    // Fix-up MPP so that we stay in machine mode
    ctx->status &= ~SR_MPP;
    ctx->status |= SR_MPP_M;
#endif

    // Timer interrupt
    if (ctx->cause == (CAUSE_INTERRUPT + IRQ_M_TIMER) && _timer_handler)
    {
        ctx = _timer_handler(ctx);
    }
    // External interrupt
    else if (ctx->cause & CAUSE_INTERRUPT)
    {
        if (_irq_handler)
            ctx = _irq_handler(ctx);
        else
            printf("Unhandled IRQ!\n");
    }
    // Exception
    else
    {
        switch (ctx->cause)
        {
            case CAUSE_ECALL_U:
            case CAUSE_ECALL_S:
            case CAUSE_ECALL_M:
                ctx->pc += 4;
                break;
        }

        if (ctx->cause < CAUSE_MAX_EXC && _exception_table[ctx->cause])
            ctx = _exception_table[ctx->cause](ctx);
        else if (ctx->cause == CAUSE_FAULT_LOAD || ctx->cause == CAUSE_FAULT_STORE ||
                 ctx->cause == CAUSE_MISALIGNED_LOAD || ctx->cause == CAUSE_MISALIGNED_STORE)
        {
            uint32_t addr = csr_read(0x343); // baddr
            switch (ctx->cause)
            {
                case CAUSE_FAULT_LOAD:
                    printf("ERROR: Load fault for access to addr 0x%08x\n", addr);
                    break;
                case CAUSE_FAULT_STORE:
                    printf("ERROR: Store fault for access to addr 0x%08x\n", addr);
                    break;
                case CAUSE_MISALIGNED_LOAD:
                    printf("ERROR: Misaligned load for access to addr 0x%08x\n", addr);
                    break;
                case CAUSE_MISALIGNED_STORE:
                    printf("ERROR: Misaligned store for access to addr 0x%08x\n", addr);
                    break;
            }
            exception_dump_ctx(ctx);
            assert(!"Unhandled exception");
        }
        else
        {
            printf("Unhandled exception: PC 0x%08x Cause %d!\n", ctx->pc, ctx->cause);
            assert(!"Unhandled exception");
        }
    }

    return ctx;
}
//-----------------------------------------------------------------
// exception_dump_ctx:
//-----------------------------------------------------------------
void exception_dump_ctx(struct irq_context *ctx)
{
    printf("Exception: PC=%08x Cause=%x Status=%08x\n", ctx->pc, ctx->cause, ctx->status);
    for (int i=0;i<NUM_GP_REG;i++)
    {
        printf("REG %.2d: %08x\n", i, ctx->reg[i]);
    }
}
//-----------------------------------------------------------------
// exception_makecontext: Create an execution context
//-----------------------------------------------------------------
struct irq_context * exception_makecontext(uint32_t *stack, uint32_t stack_size, void (*func)(), void *arg)
{
    uint32_t *sp = stack;
    struct irq_context *ucp;
    int i;

    assert(stack);
    assert(stack_size != 0);

    // Set current stack pointer to start (top) of stack
    sp += (stack_size-1);

    // Allocate reg file stack space
    sp -= (sizeof(struct irq_context)/4);
    ucp = (struct irq_context *)sp;

    // Fill register file with known pattern
    for (i=0;i<NUM_GP_REG;i++)
        ucp->reg[i] = i;

    // Record current stack pointer
    ucp->reg[REG_SP]   = (uint32_t)sp;

    // Entry function & argument
    ucp->pc            = (uint32_t)func;
    ucp->reg[REG_ARG0] = (uint32_t)arg;

    extern void _exit(int arg);
    ucp->reg[REG_RA]   = _exit;

    // Interrupts enabled (pushed version of EI, popped on scheduling)
    // Tick timer also enabled
    ucp->status = SR_MPP_M;  // Stay in machine mode
    ucp->cause  = 0;
    context_irq_enable(ucp, 1);

    return ucp;
}
