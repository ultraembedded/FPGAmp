#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "assert.h"
#include "av_buffer.h"
#include "jpeg_hw.h"
#include "audio.h"
#include "fb_dev.h"
#include "kernel/thread.h"
#include "kernel/mailbox.h"
#include "av_output.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define FRAME_BUFFER1       (0x3100000)
#define FRAME_BUFFER2       (0x3200000)
#define FRAME_BUFFER3       (0x3300000)

//-----------------------------------------------------------------
// uncached_ptr8: Convert to uncached alias
//-----------------------------------------------------------------
static uint8_t *uncached_ptr8(uint8_t *p)
{
    return (uint8_t*)(((uint32_t)p) & 0x7FFFFFFF);
}
//-----------------------------------------------------------------
// av_output: Video / Audio output thread
//-----------------------------------------------------------------
void* av_output(void * mbox)
{
    printf("av_output: S\n");    
    jpeg_hw_reset();

    // Init audio subsystem
    audio_init(CONFIG_AUDIO_BASE, -1, MCU_CLK, AUDIO_TARGET_I2S);

    int frame_idx = 0;
    uint32_t tl = 0;
    uint32_t tprev = 0;
    uint32_t fb[] = { FRAME_BUFFER1, FRAME_BUFFER2, FRAME_BUFFER3 };
    int fb_idx = 0;

    while (1)
    {
        struct av_buffer* buf;
        mailbox_pend(mbox, &buf);

        // Video + Audio
        if (buf->length)
        {
            jpeg_hw_start((uint32_t)uncached_ptr8(buf->src_video), fb[fb_idx], buf->length);

            if (buf->audio_length)
            {
                while (audio_fifo_space() < buf->audio_length)
                    thread_sleep(1);

                audio_load_samples(uncached_ptr8(buf->src_audio), buf->audio_length);
            }

            // 25fps minus some time...
            thread_sleep(35);

            assert(!jpeg_hw_busy());
            avbuf_free(buf);
            frame_idx++;

            fbdev_set_framebuffer(fb[fb_idx]);
            if (++fb_idx == 3)
                fb_idx = 0;
        }
        // Audio only
        else if (buf->audio_length)
        {
            while (audio_fifo_space() < buf->audio_length)
                thread_sleep(5);

            audio_load_samples(buf->src_audio, buf->audio_length);
            avbuf_free(buf);
        }
    }
}