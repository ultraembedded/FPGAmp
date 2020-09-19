#include <stdint.h>
#include "assert.h"
#include "av_buffer.h"
#include "csr.h"

#ifndef CONFIG_AV_BUFFERS
#define CONFIG_AV_BUFFERS 4
#endif

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static struct av_buffer _buffers[CONFIG_AV_BUFFERS] __attribute__ ((aligned (512)));
static struct link_list _buffer_list;

//-----------------------------------------------------------------
// avbuf_init
//-----------------------------------------------------------------
void avbuf_init(void)
{
    int i;

    // Init buffer list
    list_init(&_buffer_list);

    // Add buffers to free list
    for (i=0;i<CONFIG_AV_BUFFERS;i++)
        list_insert_last(&_buffer_list, &_buffers[i].list_entry);
}
//-----------------------------------------------------------------
// avbuf_alloc
//-----------------------------------------------------------------
struct av_buffer* avbuf_alloc(void)
{
    struct av_buffer* buf;
    struct link_node *node;

    if (list_is_empty(&_buffer_list))
        return 0;

    csr_clr_irq_enable();

    // Get the first buffer
    node = list_first(&_buffer_list);
    buf  = list_entry(node, struct av_buffer, list_entry);

    // Remove from the free list
    list_remove(&_buffer_list, &buf->list_entry);

    csr_set_irq_enable();

    // Reset details
    buf->length = 0;

    return buf;
}
//-----------------------------------------------------------------
// audiobuf_free
//-----------------------------------------------------------------
void avbuf_free(struct av_buffer *buf)
{
    assert(buf);

    csr_clr_irq_enable();
    list_insert_last(&_buffer_list, &buf->list_entry);
    csr_set_irq_enable();
}
