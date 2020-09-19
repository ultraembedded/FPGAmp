#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// memchr:
//-----------------------------------------------------------------
#ifdef MEMCHAR_LEGACY
void * memchr(const void *s, unsigned char c, int n)
#else
void * memchr(const void *s, int c, size_t n)
#endif
{
    if (n != 0) 
    {
        const unsigned char *p = (const unsigned char*)s;

        do 
        {
            if (*p++ == c)
                return ((void *)(p - 1));
        } 
        while (--n != 0);
    }

    return 0;
}
