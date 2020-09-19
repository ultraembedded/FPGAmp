#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// tolower:
//-----------------------------------------------------------------
int tolower(int ch)
{
    if ( (unsigned int)(ch - 'A') < 26u )
        ch += 'a' - 'A';
    return ch;
}
