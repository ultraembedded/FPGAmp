#ifdef INCLUDE_MP3_SUPPORT
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "assert.h"
#include "mp3dec.h"
#include "fat_filelib.h"
#include "av_buffer.h"
#include "file_mp3.h"
#include "kernel/thread.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
// Should be at least 1 frame at high bitrate
#define READ_CHUNK_SIZE             (128 * 1024)
#define BUFFER_SIZE                 (READ_CHUNK_SIZE + MAINBUF_SIZE)

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static uint8_t readBuf[BUFFER_SIZE + 32];
static HMP3Decoder hMP3Decoder;
static volatile int _stop = 0;

//-----------------------------------------------------------------
// FillReadBuffer:
//-----------------------------------------------------------------
static int FillReadBuffer(uint8_t *readBuf, uint8_t **readPtr, int bytesLeft, void *file)
{
    int nRead;
    int nRequest = READ_CHUNK_SIZE;

    uint8_t *target = readBuf;

    // Non-word aligned amount of data will be read
    if (bytesLeft & 3)
    {
        int offset = bytesLeft & 3;
        int align_count = 4 - offset;
        
        target += align_count;
    }

    // move last, small chunk from end of buffer to start, then fill with new data
    memmove(target, *readPtr, bytesLeft);

    nRead = fl_fread(target + bytesLeft, 1, nRequest, file);

    // zero-pad to avoid finding false sync word after last frame (from old data in readBuf)
    if (nRead < nRequest)
        memset(target + bytesLeft + nRead, 0, nRequest - nRead);

    *readPtr = target;

    return nRead;
}
//-----------------------------------------------------------------
// file_mp3_play: Play an MP3
//-----------------------------------------------------------------
int file_mp3_play(const char *filename, struct mailbox *mbox, int (*cb_stopped)(void))
{
    int bytesLeft, err, offset, outOfData, eofReached;    
    FL_FILE *file;    
    MP3FrameInfo mp3FrameInfo;
    uint8_t *readPtr;
    struct av_buffer* aud_buf = NULL;

    if (!hMP3Decoder)
    {
        // Allocate mp3 decoder buffers
        if ( (hMP3Decoder = MP3InitDecoder()) == 0 )
        {
            printf("MP3: Error allocating decoder\n");
            return -1;
        } 
    }

    // Try and open file first
    file = fl_fopen(filename, "rb");
    if (!file) 
    {
        printf("MP3: Could not open %s\n", filename);
        return -1;
    }

    memset(readBuf, 0x00, sizeof(readBuf));

    bytesLeft = 0;
    outOfData = 0;
    eofReached = 0;
    readPtr = readBuf;
    do 
    {
        // Refill required
        if (bytesLeft < MAINBUF_SIZE && !eofReached) 
        {
            int nRead = FillReadBuffer(readBuf, &readPtr, bytesLeft, file);
            bytesLeft += nRead;
            if (nRead == 0)
                eofReached = 1;
        }

        // Find start of next MP3 frame - assume EOF if no sync found
        offset = MP3FindSyncWord(readPtr, bytesLeft);
        if (offset < 0) 
        {
            outOfData = 1;
            break;
        }
        readPtr += offset;
        bytesLeft -= offset;

        // Wait for audio buffer
        while (!aud_buf)
        {
            aud_buf = avbuf_alloc();
            if (!aud_buf)
                thread_sleep(5);
        }
        aud_buf->src_audio = (uint32_t*)aud_buf->src_data;

        // Play frame (decode one MP3 frame)
        err = MP3Decode(hMP3Decoder, &readPtr, &bytesLeft, aud_buf->src_audio, 0);
        if (err) 
        {
            switch (err) 
            {
            case ERR_MP3_INDATA_UNDERFLOW:
                printf("ERR_MP3_INDATA_UNDERFLOW\n");
                outOfData = 1;
                break;
            case ERR_MP3_MAINDATA_UNDERFLOW:
                /* do nothing - next call to decode will provide more mainData */
                break;
            case ERR_MP3_FREE_BITRATE_SYNC:
            default:
                printf("ERR_MP3_FREE_BITRATE_SYNC %d\n", err);
                outOfData = 1;
                break;
            }
        } 
        else
        {
            MP3GetLastFrameInfo(hMP3Decoder, &mp3FrameInfo);

            aud_buf->audio_length = mp3FrameInfo.outputSamps / 2;
            assert(aud_buf->audio_length > 0 && aud_buf->audio_length < 10000);

            // Queue audio buffer
            mailbox_post(mbox, (uint32_t)aud_buf);
            aud_buf = NULL;

            // Periodic poll function supplied
            if (cb_stopped())
                break;
        }
    } 
    while (!outOfData);

    // Left over audio buffer, free it
    if (aud_buf)
        avbuf_free(aud_buf);

    // Close file
    fl_fclose(file);

    return 0;
}

#endif