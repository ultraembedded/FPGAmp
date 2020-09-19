#include "hr_timer.h"

static uint32_t _ticks_per_ms = MCU_CLK / 1000;
static uint32_t _ticks_per_us = MCU_CLK / 1000000;

//--------------------------------------------------------------------------
// hrtimer_diffms:
//--------------------------------------------------------------------------
int32_t hrtimer_diffms(t_tick a, t_tick b)
{
    return hrtimer_diff(a, b) / _ticks_per_ms;
}
//--------------------------------------------------------------------------
// hrtimer_diffus:
//--------------------------------------------------------------------------
int32_t hrtimer_diffus(t_tick a, t_tick b)
{
    return hrtimer_diff(a, b) / _ticks_per_us;
}
//--------------------------------------------------------------------------
// hrtimer_delayms:
//--------------------------------------------------------------------------
void hrtimer_delayms(int time_ms)
{
    t_tick t = hrtimer_now() + (_ticks_per_ms * time_ms);

    while (hrtimer_now() < t)
        ;
}
//--------------------------------------------------------------------------
// hrtimer_delayus:
//--------------------------------------------------------------------------
void hrtimer_delayus(int time_us)
{
    t_tick t = hrtimer_now() + (_ticks_per_us * time_us);

    while (hrtimer_now() < t)
        ;
}
//--------------------------------------------------------------------------
// hrtimer_ms_to_ticks:
//--------------------------------------------------------------------------
t_tick hrtimer_ms_to_ticks(uint32_t time_ms)
{
    return (_ticks_per_ms * time_ms);
}
//--------------------------------------------------------------------------
// hrtimer_us_to_ticks:
//--------------------------------------------------------------------------
t_tick hrtimer_us_to_ticks(uint32_t time_us)
{
    return (_ticks_per_us * time_us);
}
//--------------------------------------------------------------------------
// hrtimer_ticks_to_us:
//--------------------------------------------------------------------------
int32_t hrtimer_ticks_to_us(t_tick ticks)
{
    return (ticks / _ticks_per_us);
}
//--------------------------------------------------------------------------
// hrtimer_ticks_to_ms:
//--------------------------------------------------------------------------
int32_t hrtimer_ticks_to_ms(t_tick ticks)
{
    return (ticks / _ticks_per_ms);
}
