#ifndef __HR_TIMER_H__
#define __HR_TIMER_H__

#include <stdint.h>
#include "timer.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
typedef int32_t t_tick;

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
static t_tick   hrtimer_now(void) { return timer_get_mtime(); }
static int32_t  hrtimer_diff(t_tick a, t_tick b) { return (int32_t)(a - b); } 
int32_t         hrtimer_diffms(t_tick a, t_tick b);
int32_t         hrtimer_diffus(t_tick a, t_tick b);
void            hrtimer_delayms(int time_ms);
void            hrtimer_delayus(int time_us);
t_tick          hrtimer_ms_to_ticks(uint32_t time_ms);
t_tick          hrtimer_us_to_ticks(uint32_t time_us);
int32_t         hrtimer_ticks_to_us(t_tick ticks);
int32_t         hrtimer_ticks_to_ms(t_tick ticks);

#endif
