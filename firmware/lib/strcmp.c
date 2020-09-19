#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#include <ctype.h>
#endif

//-----------------------------------------------------------------
// strcmp:
//-----------------------------------------------------------------
#ifndef CONFIG_HAS_OPTIMISED_STRCMP
int strcmp(const char* s1, const char* s2)
{
    while(*s1 == *s2)
    {
        if(*s1 == 0) 
            return 0;

        s1 ++;
        s2 ++;
    }

    return *s1 - *s2;
}
#endif
//-----------------------------------------------------------------
// strncmp:
//-----------------------------------------------------------------
int strncmp(const char * s1, const char * s2, size_t n)
{
    if(n == 0) 
        return 0;

    do
    {
        if(*s1 != *s2 ++) 
            return *s1 - *--s2;
        if(*s1++ == 0) 
            break;
    }
    while (-- n != 0);

    return 0;
}
//-----------------------------------------------------------------
// strcasecmp:
//-----------------------------------------------------------------
int strcasecmp(const char* s1, const char* s2)
{
    while(tolower(*s1) == tolower(*s2))
    {
        if(*s1 == 0) 
            return 0;

        s1 ++;
        s2 ++;
    }

    return tolower(*s1) - tolower(*s2);
}
//-----------------------------------------------------------------
// strncasecmp:
//-----------------------------------------------------------------
int strncasecmp(const char * s1, const char * s2, size_t n)
{
    if(n == 0) 
        return 0;

    do
    {
        if(tolower(*s1) != tolower(*s2++)) 
            return tolower(*s1) - tolower(*--s2);
        if(*s1++ == 0) 
            break;
    }
    while (-- n != 0);

    return 0;
}
