#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// strcat:
//-----------------------------------------------------------------
char *strcat(char *dst, const char *src)
{
    char *cp = dst;
    while (*cp) 
        cp++;
    while (*cp++ = *src++);
    return dst;
}
//-----------------------------------------------------------------
// strncat:
//-----------------------------------------------------------------
char *strncat(char *s1, const char *s2, size_t count)
{
    char *start = s1;

    while (*s1++);

    s1--;

    while (count--)
        if (!(*s1++ = *s2++)) 
            return start;

    *s1 = '\0';
    return start;
}
