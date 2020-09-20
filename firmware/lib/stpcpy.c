#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

char * stpcpy(char * dst, const char * src) 
{
    const size_t length = strlen(src);
    memcpy(dst, src, length + 1);
    return dst + length;
}