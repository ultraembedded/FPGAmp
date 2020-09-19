#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// toupper:
//-----------------------------------------------------------------
int toupper(int ch) 
{
    if ( (unsigned int)(ch - 'a') < 26 )
        ch += 'A' - 'a';

    return ch;
}
