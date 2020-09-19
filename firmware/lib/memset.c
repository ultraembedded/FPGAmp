#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// memset:
//-----------------------------------------------------------------
void *memset(void *p, int c, size_t n)
{
    char *pb = (char *) p;
    char *pbend = pb + n;

    while (pb != pbend) 
        *pb++ = c;
    return p;
}
