#include <stdio.h>
extern void _exit(int rc); 

//-----------------------------------------------------------------
// assert_handler:
//-----------------------------------------------------------------
void assert_handler(const char * type, const char *reason, const char *file, int line)
{
    printf("%s: %s (%s:%d)\n", type, reason, file, line);
    _exit(-1);
}
