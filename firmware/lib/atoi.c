#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// atoi:
//-----------------------------------------------------------------
int atoi(const char *str)
{
    unsigned int val = 0;

    while ('0' <= *str && *str <= '9') 
    {
        val *= 10;
        val += *str++ - '0';
    }

    return (int)val;
}
//-----------------------------------------------------------------
// atoi_hex:
//-----------------------------------------------------------------
int atoi_hex(const char *str)
{
    unsigned int sum = 0;
    unsigned int leftshift = 0;
    char *s = (char*)str;
    char c;
    
    // Find the end
    while (*s)
        s++;

    // Backwards through the string
    while(s != str)
    {
        s--;
        c = *s;

        if((c >= '0') && (c <= '9'))
            sum += (c-'0') << leftshift;
        else if((c >= 'A') && (c <= 'F'))
            sum += (c-'A'+10) << leftshift;
        else if((c >= 'a') && (c <= 'f'))
            sum += (c-'a'+10) << leftshift;
        else
            break;
        
        leftshift+=4;
    }

    return (int)sum;
}
