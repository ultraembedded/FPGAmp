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
#include "mmc_async_io.h"
#include "file_mjpg.h"

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
/*
    File Format:

    |-------------------------|
    | BHeader (512 bytes)     |
    |-------------------------|
    | Video Frame + Pad       |
    |-------------------------|  x 128
    | Audio Frame + Pad       |
    |-------------------------|
    | BHeader (512 bytes)     |
    |-------------------------|
    | Video Frame + Pad       |
    |-------------------------|  x 128
    | Audio Frame + Pad       |
*/

struct headerb
{
    uint32_t frame_size[128];
};

struct audiob
{
    uint32_t samples[1764];
    uint8_t  padding[112];
};

static struct headerb hdr_b __attribute__ ((aligned (512)));

//-----------------------------------------------------------------------------
// fl_get_start_sector: Get first sector used by file (test only)
//-----------------------------------------------------------------------------
static uint32 fl_get_start_sector(void* file)
{
    return fatfs_lba_of_cluster(fl_get_fs(), ((FL_FILE*)file)->startcluster);
}
//-----------------------------------------------------------------
// uncached_ptr8: Convert to uncached alias
//-----------------------------------------------------------------
static uint8_t *uncached_ptr8(uint8_t *p)
{
    return (uint8_t*)(((uint32_t)p) & 0x7FFFFFFF);
}
//-----------------------------------------------------------------------------
// file_mjpg_play: Play motion JPEG file
//-----------------------------------------------------------------------------
int file_mjpg_play(const char *play_file, struct mailbox *mbox, int fps, int (*cb_stopped)(void))
{
    FL_FILE * f = fl_fopen((const char*)play_file, "rb");
    if (!f)
        return 0;

    uint32_t total_sectors  = (f->filelength + 511) / 512;
    // TODO: Currently assuming linear file storage for read speed - FIXME
    uint32_t current_sector = fl_get_start_sector(f);
    uint32_t last_sector   = current_sector + total_sectors;

    int audio_samples = (AV_BUF_SRATE / fps);
    int frame_idx = 0;
    int subframe = 0;
    uint32_t *hdr_frame_sz = (uint32_t *)uncached_ptr8((uint8_t*)&hdr_b.frame_size[0]);
    while (1)
    {
        struct av_buffer* buf = avbuf_alloc();
        if (buf)
        {
            // Read 128 frame block header
            if (subframe == 0)
                mmc_async_io_read(current_sector++, (uint8_t*)&hdr_b, 1);

            int audio_padded;
            if (fps != 25 && (subframe & 1))
                audio_padded = (((((audio_samples+1) * 4) + 511) / 512) * 512);
            else
                audio_padded = ((((audio_samples * 4) + 511) / 512) * 512);

            uint32_t size    = hdr_frame_sz[subframe];
            uint32_t size_pad= ((size + 511) / 512) * 512;
            uint32_t sectors = ((size + 511) / 512) + (audio_padded / 512);

            // Invalid video frame length, end of video detected.
            if (size == 0)
            {
                avbuf_free(buf);
                break;
            }

            mmc_async_io_read(current_sector, uncached_ptr8(buf->src_data), sectors);
            current_sector += sectors;

            // Find pointers to content
            buf->src_video    = &buf->src_data[0];
            buf->src_audio    = (uint32_t*)&buf->src_data[size_pad];
            buf->length       = size;

            if (fps != 25 && (subframe & 1))
                buf->audio_length = (AV_BUF_SRATE / fps) + 1;
            else
                buf->audio_length = (AV_BUF_SRATE / fps);

            if (++subframe == 128)
                subframe = 0;

            mailbox_post(mbox, (uint32_t)buf);
            frame_idx++;

            if (current_sector >= last_sector)
                break;
        }
        else
            thread_sleep(10);

        if (cb_stopped())
        {
            printf("User stopped playback...\n");
            break;
        }
    }
    fl_fclose(f);
    return 1;
}
