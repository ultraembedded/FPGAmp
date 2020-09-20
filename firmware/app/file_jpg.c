#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "kernel/thread.h"
#include "kernel/mailbox.h"

#include "assert.h"
#include "fat_filelib.h"
#include "fat_string.h"

#include "av_buffer.h"
#include "file_jpg.h"

//-----------------------------------------------------------------------------
// uncached_ptr8: Convert to uncached alias
//-----------------------------------------------------------------------------
static uint8_t *uncached_ptr8(uint8_t *p)
{
    return (uint8_t*)(((uint32_t)p) & 0x7FFFFFFF);
}
//-----------------------------------------------------------------------------
// file_jpg_play: Load a JPEG
//-----------------------------------------------------------------------------
int file_jpg_play(const char *play_file, struct mailbox *mbox, int (*cb_stopped)(void))
{
    FL_FILE * f = fl_fopen((const char*)play_file, "rb");
    if (!f)
        return 0;

    // Allocate a single buffer
    struct av_buffer* buf = NULL;
    while (!buf)
    {
        buf = avbuf_alloc();
        if (!buf)
            thread_sleep(5);
    }

    // Load JPEG data
    buf->src_video    = &buf->src_data[0];
    buf->length       = f->filelength;
    buf->audio_length = 0;
    fl_fread(uncached_ptr8((uint8_t*)buf->src_video), 1, buf->length, f);

    fl_fclose(f);
    f = NULL;

    // Send to display
    mailbox_post(mbox, (uint32_t)buf);

    // Wait for user input to stop
    while (1)
    {
        thread_sleep(10);
        if (cb_stopped())
            break;
    }

    return 1;
}
