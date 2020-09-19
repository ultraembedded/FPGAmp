#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// memcpy:
//-----------------------------------------------------------------
void *memcpy(void *dst, const void *src, size_t n)
{
    void *ret = dst;

    if (sizeof(unsigned long) == 4 && (n > 4) && (((unsigned long)dst) & 3) == 0 && (((unsigned long)src) & 3) == 0)
    {
        while (n >= 4)
        {
            *(unsigned long *)dst = *(unsigned long *)src;
            dst = (char *) dst + 4;
            src = (char *) src + 4;
            n -= 4;
        }
    }

    while (n--)
    {
        *(char *)dst = *(char *)src;
        dst = (char *) dst + 1;
        src = (char *) src + 1;
    }

    return ret;
}
//-----------------------------------------------------------------
// memccpy:
//-----------------------------------------------------------------
void *memccpy(void *dst, const void *src, int c, size_t count)
{
    while (count && (*((char *) (dst = (char *) dst + 1) - 1) =
        *((char *)(src = (char *) src + 1) - 1)) != (char) c)
    count--;

    return count ? dst : 0;
}
