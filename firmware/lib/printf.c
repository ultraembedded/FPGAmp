#ifdef CONFIG_USE_LOCAL_STRING_H
#include "_string.h"
#else
#include <string.h>
#endif

#include "printf.h"

//----------------------------------------------------
// Defines
//----------------------------------------------------
#ifndef PRINTF_MINIMAL

    #define PRINTF_DEC_PRINT
    #define PRINTF_HEX_PRINT
    #define PRINTF_STR_PRINT
    #define PRINTF_CHR_PRINT
    #define PRINTF_ENABLE_PADDING
    #define PRINTF_ENABLE_OTHER_FUNCS
    #define PRINTF_ENABLE_BUFFER_OUTPUT

#endif

#ifdef PRINTF_ENABLE_OTHER_FUNCS
    #define PRINTF_ENABLE_BUFFER_OUTPUT
#endif

//----------------------------------------------------
// Locals
//----------------------------------------------------
static FP_OUTCHAR   _stdout = 0;

//----------------------------------------------------
// printf: Console based printf
//----------------------------------------------------
int printf( const char* ctrl1, ... )
{
    int res = 0;
    va_list argp;
    struct vbuf buf;

    if (_stdout && ctrl1)
    {
        va_start( argp, ctrl1);
        
        // Setup target to be stdout function
        buf.function = _stdout;
        buf.buffer = 0;
        buf.offset = 0;
        buf.max_length = 0;

        res = vbuf_printf(&buf, ctrl1, argp);

        va_end( argp);
    }

    return res;
}
//----------------------------------------------------
// printf_register: Assign printf output function
//----------------------------------------------------
void printf_register(FP_OUTCHAR f)
{
    _stdout = f;
}
#ifdef PRINTF_ENABLE_OTHER_FUNCS
//----------------------------------------------------
// vsprintf: 
//----------------------------------------------------
int vsprintf(char *s, const char *format, va_list arg)
{
    struct vbuf buf;

    if (!s || !format)
        return 0;

    // Setup buffer to be target
    buf.function = 0;
    buf.buffer = s;
    buf.offset = 0;
    buf.max_length = 32768; // default

    vbuf_printf(&buf, format, arg);

    // Null terminate at end of string
    buf.buffer[buf.offset] = 0;

    return buf.offset;
}
//----------------------------------------------------
// vsnprintf: 
//----------------------------------------------------
int vsnprintf( char *s, size_t maxlen, const char *format, va_list arg)
{
    struct vbuf buf;

    if (!s || !format || !maxlen)
        return 0;

    // Setup buffer to be target
    buf.function = 0;
    buf.buffer = s;
    buf.offset = 0;
    buf.max_length = maxlen;

    vbuf_printf(&buf, format, arg);

    // Null terminate at end of string
    buf.buffer[buf.offset] = 0;

    return buf.offset;
}
//----------------------------------------------------
// sprintf: 
//----------------------------------------------------
int sprintf(char *s, const char *format, ...)
{
    va_list argp;
    struct vbuf buf;

    if (!s || !format)
        return 0;

    va_start( argp, format);

    // Setup buffer to be target
    buf.function = 0;
    buf.buffer = s;
    buf.offset = 0;
    buf.max_length = 32768; // default

    vbuf_printf(&buf, format, argp);

    // Null terminate at end of string
    buf.buffer[buf.offset] = 0;

    va_end( argp);

    return buf.offset;
}
//----------------------------------------------------
// snprintf: 
//----------------------------------------------------
int snprintf(char *s, size_t maxlen, const char *format, ...)
{
    va_list argp;
    struct vbuf buf;

    if (!maxlen || !s || !format)
        return 0;

    va_start( argp, format);

    // Setup buffer to be target
    buf.function = 0;
    buf.buffer = s;
    buf.offset = 0;
    buf.max_length = maxlen;

    vbuf_printf(&buf, format, argp);

    // Null terminate
    if (buf.offset < buf.max_length)
        buf.buffer[buf.offset] = 0;
    else
        buf.buffer[buf.max_length-1] = 0;

    va_end( argp);

    return buf.offset;
}
#endif
//----------------------------------------------------
// puts:
//----------------------------------------------------
int puts( const char * str )
{
    if (!_stdout)
        return -1;

    while (*str)
        _stdout(*str++);

    return _stdout('\n');
}
//----------------------------------------------------
// putchar:
//----------------------------------------------------
int putchar( int c )
{
    if (!_stdout)
        return -1;

    _stdout((char)c);

    return c;
}

//----------------------------------------------------
//          Printf Implementation
//----------------------------------------------------

//----------------------------------------------------
// Structures
//----------------------------------------------------
typedef struct params_s 
{
    int len;
    long num1;
    long num2;
    char pad_character;
    int do_padding;
    int is_unsigned;
    int left_flag;
    int uppercase;
    int max_len;
} params_t;

//----------------------------------------------------
// vbuf_putchar: vbuf_printf output function (directs
// output to either function or buffer.
//----------------------------------------------------
#ifdef PRINTF_ENABLE_BUFFER_OUTPUT
static void vbuf_putchar(struct vbuf *buf, char c)
{
    // Function is target
    if (buf->function)
        buf->function(c);
    // Buffer is target
    else if (buf->buffer)
    {
        if (buf->offset < buf->max_length)
            buf->buffer[buf->offset++] = c;
    }
}
#else
    #define vbuf_putchar(buf,c) _stdout(c)
#endif
//----------------------------------------------------
/*                                                   */
/* This routine puts pad characters into the output  */
/* buffer.                                           */
/*                                                   */
//----------------------------------------------------
#if defined PRINTF_DEC_PRINT || defined PRINTF_HEX_PRINT || defined PRINTF_STR_PRINT
#if defined PRINTF_ENABLE_PADDING
static void padding( struct vbuf *buf, const int l_flag, params_t *par)
{
    int i;

    if (par->do_padding && l_flag && (par->len < par->num1))
        for (i=par->len; i<par->num1; i++)
            vbuf_putchar(buf, par->pad_character);
}
#endif
#endif
//----------------------------------------------------
/*                                                   */
/* This routine moves a string to the output buffer  */
/* as directed by the padding and positioning flags. */
/*                                                   */
//----------------------------------------------------
#ifdef PRINTF_STR_PRINT
static void outs( struct vbuf *buf, char* lp, params_t *par)
{
    /* pad on left if needed                         */
    par->len = strlen( lp);
#ifdef PRINTF_ENABLE_PADDING
    padding(buf, !(par->left_flag), par);
#endif

    /* Move string to the buffer                     */
    while (*lp && (par->num2)--)
        vbuf_putchar(buf, *lp++);

    /* Pad on right if needed                        */
    par->len = strlen( lp);
#ifdef PRINTF_ENABLE_PADDING
    padding(buf, par->left_flag, par);
#endif
}
#endif
//----------------------------------------------------
/*                                                   */
/* This routine moves a number to the output buffer  */
/* as directed by the padding and positioning flags. */
/*                                                   */
//----------------------------------------------------
#if defined PRINTF_DEC_PRINT || defined PRINTF_HEX_PRINT
static void outnum( struct vbuf *buf, const long n, const long base, params_t *par)
{
    char* cp;
    int negative;
    char outbuf[32];
    const char udigits[] = "0123456789ABCDEF";
    const char ldigits[] = "0123456789abcdef";
    const char *digits;
    unsigned long num;
    int count;

    /* Check if number is negative                   */
    if (base == 10 && n < 0L && !par->is_unsigned) {
        negative = 1;
        num = -(n);
    }
    else{
        num = (n);
        negative = 0;
    }

    if (par->uppercase)
        digits = udigits;
    else
        digits = ldigits;
   
    /* Build number (backwards) in outbuf            */
    cp = outbuf;
    if (base == 10)
    {    
        do {
            *cp++ = digits[(int)(num % 10)];
        } while ((num /= 10) > 0);
    }
    else
    {
        do {
            *cp++ = digits[(int)(num % 16)];
        } while ((num /= 16) > 0);
    }

    if (negative)
        *cp++ = '-';
    *cp-- = 0;

    /* Move the converted number to the buffer and   */
    /* add in the padding where needed.              */
    par->len = strlen(outbuf);
#ifdef PRINTF_ENABLE_PADDING
    padding(buf, !(par->left_flag), par);
#endif
    count = 0;
    while (cp >= outbuf && count++ < par->max_len)
        vbuf_putchar(buf, *cp--);
#ifdef PRINTF_ENABLE_PADDING
    padding(buf, par->left_flag, par);
#endif
}
#endif
//----------------------------------------------------
/*                                                   */
/* This routine gets a number from the format        */
/* string.                                           */
/*                                                   */
//----------------------------------------------------
static long getnum( char** linep)
{
    long n;
    char* cp;

    n = 0;
    cp = *linep;
    while (((*cp) >= '0' && (*cp) <= '9'))
        n = n*10 + ((*cp++) - '0');
    *linep = cp;
    return(n);
}
//----------------------------------------------------
/*                                                   */
/* This routine operates just like a printf/sprintf  */
/* routine. It outputs a set of data under the       */
/* control of a formatting string. Not all of the    */
/* standard C format control are supported. The ones */
/* provided are primarily those needed for embedded  */
/* systems work. Primarily the floaing point         */
/* routines are omitted. Other formats could be      */
/* added easily by following the examples shown for  */
/* the supported formats.                            */
/*                                                   */
//----------------------------------------------------
int vbuf_printf(struct vbuf *buf, const char* ctrl1, va_list argp)
{
    int long_flag;
    int dot_flag;
    int res = 0;

    params_t par;

    char ch;
    char* ctrl = (char*)ctrl1;

    for ( ; *ctrl; ctrl++) 
    {
        /* move format string chars to buffer until a  */
        /* format control is found.                    */
        if (*ctrl != '%') 
        {
            vbuf_putchar(buf, *ctrl);
            continue;
        }

        /* initialize all the flags for this format.   */
        dot_flag   = long_flag = par.left_flag = par.do_padding = 0;
        par.is_unsigned = 0;
        par.pad_character = ' ';
        par.num2=32767;
        par.max_len = 10;

 try_next:
        ch = *(++ctrl);

        if ((ch >= '0' && ch <= '9')) 
        {
            if (dot_flag)
                par.num2 = getnum(&ctrl);
            else {
                if (ch == '0')
                    par.pad_character = '0';

                par.num1 = getnum(&ctrl);
                par.do_padding = 1;
            }
            ctrl--;
            goto try_next;
        }

        par.uppercase = (ch >= 'A' && ch <= 'Z') ? 1 : 0;

        switch ((par.uppercase ? ch + 32: ch)) 
        {
            case '%':
                vbuf_putchar(buf, '%');
                continue;

            case '-':
                par.left_flag = 1;
                break;

            case '.':
                dot_flag = 1;
                break;

            case 'l':
                long_flag = 1;
                break;

#ifdef PRINTF_DEC_PRINT
            case 'u':
                par.is_unsigned = 1;
                // Drop thru
            case 'd':
                if (long_flag || ch == 'D') 
                {
                    outnum(buf, va_arg(argp, long), 10L, &par);
                    continue;
                }
                else {
                    outnum(buf, va_arg(argp, int), 10L, &par);
                    continue;
                }
#endif
#ifdef PRINTF_HEX_PRINT
            case 'x':
            case 'p':
                if (long_flag || ch == 'D') 
                {
                    par.max_len = sizeof(long) * 2;
                    outnum(buf, (long)va_arg(argp, long), 16L, &par);
                }
                else
                {
                    par.max_len = sizeof(int) * 2;
                    outnum(buf, (long)va_arg(argp, int), 16L, &par);
                }
                continue;
#endif
#ifdef PRINTF_STR_PRINT
            case 's':
                outs(buf, va_arg( argp, char*), &par);
                continue;
#endif
#ifdef PRINTF_CHR_PRINT
            case 'c':
                vbuf_putchar(buf, va_arg( argp, int));
                continue;
#endif
            case '\\':
                switch (*ctrl) {
                    case 'a':
                        vbuf_putchar(buf, 0x07);
                        break;
                    case 'h':
                        vbuf_putchar(buf, 0x08);
                        break;
                    case 'r':
                        vbuf_putchar(buf, 0x0D);
                        break;
                    case 'n':
                        vbuf_putchar(buf, 0x0A);
                        break;
                    default:
                        vbuf_putchar(buf, *ctrl);
                        break;
                }
                ctrl++;
                break;

            default:
                continue;
        }
        goto try_next;
    }

    return res;
}
