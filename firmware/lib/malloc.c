#include "malloc.h"

#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// Based on code from a malloc/free implementation from:
// http://www.flipcode.com/archives/Simple_Malloc_Free_Functions.shtml
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------

// Round up to the next 4 byte boundary
#define ROUNDUP_4BYTES(a)       ((((a) + 3) >> 2) << 2)
#define USED                    1

//-----------------------------------------------------------------
// Types:
//-----------------------------------------------------------------
struct MemBlock
{
    size_t size;
};

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
static struct MemBlock* compact_blocks( struct MemBlock *p, size_t nsize );

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static struct MemBlock* MemFree = 0;
static struct MemBlock* MemHeap = 0;
static int              MemAllocInit = 0;
static int (*MemLock)(void) = 0;
static void (*MemUnlock)(int) = 0;

//-----------------------------------------------------------------
// malloc_init:
//-----------------------------------------------------------------
void malloc_init( void *heap, size_t len, int (*fn_lock)(void), void (*fn_unlock)(int l) )
{
    struct MemBlock *end;

    // Round up to next word boundary
    len = ROUNDUP_4BYTES(len);

    // Free pointer is start of heap
    MemFree = MemHeap = (struct MemBlock *) heap;

    MemFree->size = MemHeap->size = len - sizeof(struct MemBlock);
    
    // Skip to end point 
    end = (struct MemBlock*)(((char *)heap) + len - sizeof(struct MemBlock));

    // Mark last node as NULL
    end->size = 0;

    // Store user callbacks for thread safety
    MemLock = fn_lock;
    MemUnlock = fn_unlock;

    // Memory manager initialised
    MemAllocInit = 1;
}
//-----------------------------------------------------------------
// _malloc:
//-----------------------------------------------------------------
static void* _malloc( size_t size )
{
    size_t fsize;
    struct MemBlock *p;

    if( size == 0 || !MemAllocInit) 
        return 0;

    // Round up to next word boundary including extra space for size data
    size = ROUNDUP_4BYTES(size + sizeof(struct MemBlock));

    // Not enough space?
    if( MemFree == 0 || size > MemFree->size )
    {
        // Try running compact_blocks to group together free memory.
        // NOTE: This never returns anything other than NULL if there
        // is not the free space.
        MemFree = compact_blocks( MemHeap, size );

        // No memory free?
        if( MemFree == 0 ) 
            return 0;
    }

    p = MemFree;
    fsize = MemFree->size;

    // Free block is larger than requested size & block allocation node 
    if( fsize >= size + sizeof(struct MemBlock) )
    {
        // Move free pointer onto end of this block
        MemFree = (struct MemBlock *)( (size_t)p + size );

        // ... now setup free space remaining
        MemFree->size = fsize - size;
    }
    // Free block large enough for data but not for extra for block
    // allocation now. Set the free space to 0.
    else
    {
        MemFree = 0;
        size = fsize;
    }

    // Mark block as used (LSB is not used for size as round-up)
    p->size = size | USED;

    return (void *)( (size_t)p + sizeof(struct MemBlock) );
}
//-----------------------------------------------------------------
// compact_blocks: Find a large enough free block on the heap
// Args: p = heap, nsize = requested block size
// Returns: Pointer to free block if large enough one found.
//-----------------------------------------------------------------
static struct MemBlock* compact_blocks( struct MemBlock *p, size_t nsize )
{
    size_t bsize, psize;
    struct MemBlock *best;

    best = p;
    bsize = 0;

    // While not end of heap
    while( psize = p->size, psize )
    {
        // Is block allocated
        if( psize & USED )
        {
            // If we have previously found some free blocks
            if( bsize != 0 )
            {
                // Set size of block to new total free size
                // NOTE: This has the effect of compacting free space 
                // into larger blocks even if this block is not big enough.
                best->size = bsize;

                // Is free space big enough for requested ammount
                if( bsize >= nsize )
                    return best;
            }

            // Reset free space counter
            bsize = 0;

            // Skip to the start of the next block
            best = p = (struct MemBlock *)( (size_t)p + (psize & ~USED) );
        }
        // Free block
        else
        {
            // Add size to running total of contiguous free space
            bsize += psize;

            // Find next block pointer
            p = (struct MemBlock *)( (size_t)p + psize );
        }
    }

    if( bsize != 0 )
    {
        // Set size of block to new total free size
        // NOTE: This has the effect of compacting free space 
        // into larger blocks even if this block is not big enough.
        best->size = bsize;

        // Is free space big enough for requested ammount
        if( bsize >= nsize )
            return best;
    }

    return 0;
}
//-----------------------------------------------------------------
// malloc:
//-----------------------------------------------------------------
void* malloc( size_t size )
{
    void *m;
    int l;

    // Lock (optional)
    if (MemLock)
        l = MemLock();

    m = _malloc(size);

    // Unlock (optional)
    if (MemUnlock)
        MemUnlock(l);

    return m;
}
//-----------------------------------------------------------------
// free:
//-----------------------------------------------------------------
void free( void *ptr )
{
    // NOTE: No locking needed as block is marked free by last  
    // instruction (presuming mem access to p->size is atomic).
    if( ptr && MemAllocInit)
    {
        // Step back from pointer to find block address
        struct MemBlock *p = (struct MemBlock *)( (size_t)ptr - sizeof(struct MemBlock) );

        // Mark block as un-used
        p->size &= ~USED;
    }
}
//-----------------------------------------------------------------
// calloc:
//-----------------------------------------------------------------
void* calloc( size_t size )
{
    void *p = malloc(size);
    if (p)
        memset(p, 0, size);
    return p;
}
//-----------------------------------------------------------------
// malloc_largest_free_size: Find the size of the largest free block
//-----------------------------------------------------------------
size_t malloc_largest_free_size(void)
{
    size_t psize, largest;
    struct MemBlock *p = MemHeap;
    int l;

    // Lock (optional)
    if (MemLock)
        l = MemLock();

    largest = 0;

    // Run the memory compactor first
    compact_blocks( MemHeap, (size_t)-1);

    // While not end of heap
    while( psize = p->size, psize )
    {
        // Is block allocated
        if( psize & USED )
        {
            // Skip to the start of the next block
            p = (struct MemBlock *)( (size_t)p + (psize & ~USED) );
        }
        // Free block
        else
        {
            if (psize > largest)
                largest = psize;

            // Find next block pointer
            p = (struct MemBlock *)( (size_t)p + psize );
        }
    }

    // Unlock (optional)
    if (MemUnlock)
        MemUnlock(l);

    return largest;
}
//-----------------------------------------------------------------
// malloc_total_free: Find the total free space
//-----------------------------------------------------------------
size_t malloc_total_free(void)
{
    size_t psize, total;
    struct MemBlock *p = MemHeap;
    int l;

    // Lock (optional)
    if (MemLock)
        l = MemLock();

    total = 0;

    // Run the memory compactor first
    compact_blocks( MemHeap, (size_t)-1);

    // While not end of heap
    while( psize = p->size, psize )
    {
        // Is block allocated
        if( psize & USED )
        {
            // Skip to the start of the next block
            p = (struct MemBlock *)( (size_t)p + (psize & ~USED) );
        }
        // Free block
        else
        {
            total += psize;

            // Find next block pointer
            p = (struct MemBlock *)( (size_t)p + psize );
        }
    }

    // Unlock (optional)
    if (MemUnlock)
        MemUnlock(l);

    return total;
}