#ifndef __AV_BUFFER_H__
#define __AV_BUFFER_H__

#include <stdint.h>
#include "list.h"

#define AV_BUF_DEPTH    2
#define AV_BUF_FPS      25
#define AV_BUF_SRATE    44100

// Round up to 512 sector size
#define AV_AUD_SIZE     (((((AV_BUF_SRATE / AV_BUF_FPS) * 4) + 511) / 512) * 512)

//-----------------------------------------------------------------
// Types:
//-----------------------------------------------------------------
struct av_buffer
{
    // Uncompressed output
    uint8_t             frame_buffer[CONFIG_SCREEN_WIDTH * CONFIG_SCREEN_HEIGHT * AV_BUF_DEPTH] __attribute__ ((aligned (512)));

    // Source data buffer
    uint8_t             src_data[(CONFIG_SCREEN_WIDTH * CONFIG_SCREEN_HEIGHT * AV_BUF_DEPTH) + AV_AUD_SIZE] __attribute__ ((aligned (512)));

    // Compressed data
    uint8_t            *src_video;

    // PCM audio (stereo)
    uint32_t           *src_audio;

    // JPEG image length
    int                 length;

    // Audio length
    int                 audio_length;

    struct link_node    list_entry;
};

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void avbuf_init(void);
struct av_buffer* avbuf_alloc(void);
void avbuf_free(struct av_buffer *buf);

#endif
