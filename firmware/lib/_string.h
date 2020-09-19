#ifndef __LIB_STRING_H__
#define __LIB_STRING_H__

#ifndef LIBSTD_SIZE_T
#define LIBSTD_SIZE_T
    #ifdef LIBSTD_SIZE_T_IS_LONG
        typedef unsigned long size_t;
    #else
        typedef unsigned int size_t;
    #endif
#endif

typedef unsigned int size_t;

int strcmp(const char* s1, const char* s2);
int strncmp(const char * s1, const char * s2, size_t n);

size_t strlen(const char * str);
size_t strnlen(const char * str, size_t n);

char * strcpy(char * dst, const char * src);
char * strncpy(char * dst, const char * src, size_t n);

size_t strspn(const char *s1, const char *s2);
char * strpbrk(const char *s1, const char *s2);
char * strtok(char *s1, const char *delimit);

char * strrchr(const char *cp, int ch);

char * itoa(int n, char *s, int base);

char *strcat(char *dst, const char *src);
char *strncat(char *s1, const char *s2, size_t count);

int toupper(int ch);
int tolower(int ch);

int atoi(const char *str);
int atoi_hex(const char *str);

void *memset(void *p, int c, size_t n);
int memcmp(const void *dst, const void *src, size_t n);
void *memcpy(void *dst, const void *src, size_t n);
void *memccpy(void *dst, const void *src, int c, size_t count);
int memicmp(const void *buf1, const void *buf2, size_t count);

#endif // __LIB_STRING_H__
