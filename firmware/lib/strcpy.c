#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// strcpy:
//-----------------------------------------------------------------
char * strcpy(char * dst, const char * src)
{
   char *start = dst;

   while(*dst++ = *src++)
       ;

   return start;
}
//-----------------------------------------------------------------
// strncpy:
//-----------------------------------------------------------------
char * strncpy(char * dst, const char * src, size_t n)
{
    if(n != 0)
    {
        char * d = dst;
        const char * s = src;

        do
        {
            if((*d ++ = *s ++) == 0)
            {
                while (-- n != 0) *d ++ = 0;
                break;
            }
        }
        while(-- n != 0);
    }

    return dst;
}
