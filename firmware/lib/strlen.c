#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// strlen:
//-----------------------------------------------------------------
size_t strlen(const char * str)
{
    const char * s;

    if(!str) 
        return 0;

    for(s = str; *s; ++ s)
        ;

    return s - str;
}
//-----------------------------------------------------------------
// strnlen:
//-----------------------------------------------------------------
size_t strnlen(const char * str, size_t n)
{
    const char * s;

    if(n == 0 || !str) 
        return 0;

    for(s = str; *s && n; ++ s, -- n)
        ;

    return s - str;
}
