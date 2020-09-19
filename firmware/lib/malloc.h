#ifndef __MALLOC_H__
#define __MALLOC_H__

//-----------------------------------------------------------------
// Types:
//-----------------------------------------------------------------
#ifndef LIBSTD_SIZE_T
#define LIBSTD_SIZE_T
    #ifdef LIBSTD_SIZE_T_IS_LONG
        typedef unsigned long size_t;
    #else
        typedef unsigned int size_t;
    #endif
#endif

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void        malloc_init( void *heap, size_t len, int (*fn_lock)(void), void (*fn_unlock)(int l) );
void*       malloc( size_t size );
void        free( void *ptr );
void*       calloc( size_t size );
size_t      malloc_largest_free_size(void);
size_t      malloc_total_free(void);

#endif

