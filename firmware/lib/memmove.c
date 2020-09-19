#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

//-----------------------------------------------------------------
// memmove:
//-----------------------------------------------------------------
void *memmove(void *v_dst, const void *v_src, size_t length)
{
    char *src               = (char *)v_src;
    char *dst               = (char *)v_dst;
    unsigned int *src32     = (unsigned int *)v_src;
    unsigned int *dst32     = (unsigned int *)v_dst;

    // No need to copy if src = dst or no length
    if (!length || v_src == v_dst)
        return v_dst;

    // Word aligned source & dest?
    if ((((unsigned long)dst & 3) == 0) && (((unsigned long)src & 3) == 0) && (length >= 4))
    {
        // How many full words can be copied?
        unsigned int len32 = length >> 2;

        // Move from lower address to higher address
        if (src < dst)
        {
            // Copy from end 
            for (src32 += len32, dst32 += len32; len32; --len32)
                *--dst32 = *--src32;

            src+= (length & ~3);
            dst+= (length & ~3);
        }
        // Move from higher address to lower address
        else
        {
            // Copy from start 
            for (; len32; --len32)
                *dst32++ = *src32++;

            src = (char *)src32;
            dst = (char *)dst32;
        }

        // There might be some bytes left over
        length -= (length & ~3);
    }

    // Byte copy if not aligned (or odd length)
    if (length)
    {
        // Move from lower address to higher address
        if (src < dst)
        {
            // Copy from end 
            for (src += length, dst += length; length; --length)
                *--dst = *--src;
        }
        // Move from higher address to lower address
        else
        {
            // Copy from start 
            for (; length; --length)
                *dst++ = *src++;
        }
    }

    return v_dst;
}