#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// rindex:
//-----------------------------------------------------------------
char *rindex(const char *s, int c)
{
    char *it = 0;

    while (1)
    {
        if (*s == c)
            it = (char *)s;
        if (*s == 0)
            return it;
        s++;
    }

    return 0;
}
