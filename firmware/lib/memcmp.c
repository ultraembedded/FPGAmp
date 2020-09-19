#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#include <ctype.h>
#endif

//-----------------------------------------------------------------
// memcmp:
//-----------------------------------------------------------------
int memcmp(const void *dst, const void *src, size_t n)
{
    if (!n) return 0;

    while (--n && *(char *) dst == *(char *) src)
    {
        dst = (char *) dst + 1;
        src = (char *) src + 1;
    }

    return *((unsigned char *) dst) - *((unsigned char *) src);
}
//-----------------------------------------------------------------
// memicmp:
//-----------------------------------------------------------------
int memicmp(const void *buf1, const void *buf2, size_t count)
{
    int f = 0, l = 0;
    const unsigned char *dst = (const unsigned char*)buf1;
    const unsigned char *src = (const unsigned char*)buf2;

    while (count-- && f == l)
    {
        f = tolower(*dst++);
        l = tolower(*src++);
    }

    return f - l;
}
