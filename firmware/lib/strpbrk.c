#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// strpbrk: Find the first occurrence in s1 of a character in s2
//-----------------------------------------------------------------
char * strpbrk(const char* s1, const char* s2)
{
    const char *s;
    int c, sc;

    while ((c = *s1++) != 0) 
    {
        for (s = s2; (sc = *s++) != 0; )
            if (sc == c)
                return ((char *)(s1 - 1));
    }

    return 0;
}
