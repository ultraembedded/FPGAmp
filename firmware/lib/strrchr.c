#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// strrchr:
//-----------------------------------------------------------------
char * strrchr(const char *cp, int ch)
{
    char *save;
    char c;

    for (save = (char *) 0; (c = *cp); cp++) 
    {
        if (c == ch)
            save = (char *) cp;
    }

    return save;
}
//-----------------------------------------------------------------
// strrchr:
//-----------------------------------------------------------------
char *strchr(const char *s, int c)
{
    do 
    {
        if (*s == c)
            return (char*)s;
    } 
    while (*s++);
    
    return 0;
}
