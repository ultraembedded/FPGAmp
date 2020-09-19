#ifndef __ASSERT_H__
#define __ASSERT_H__

extern void assert_handler(const char * type, const char *reason, const char *file, int line);

#define assert(exp)        do { if (!(exp)) assert_handler("ASSERT", #exp, __FILE__, __LINE__ ); } while (0)
#define panic(reason)    do { assert_handler("PANIC", #reason, __FILE__, __LINE__ );  } while (0)

#endif

