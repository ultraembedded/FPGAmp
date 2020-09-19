#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// bcmp:
//-----------------------------------------------------------------
#ifdef BCMP_LEGACY
int bcmp(const void *s1, const void *s2, int n)
#else
int bcmp(const void *s1, const void *s2, size_t n)
#endif
{
    return memcmp(s1, s2, n);
}

