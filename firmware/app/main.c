#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "kernel/critical.h"
#include "kernel/os_assert.h"
#include "kernel/list.h"
#include "kernel/thread.h"
#include "kernel/mutex.h"
#include "kernel/semaphore.h"
#include "kernel/event.h"
#include "kernel/mutex.h"
#include "kernel/mailbox.h"

#include "sd.h"
#include "assert.h"
#include "fat_filelib.h"
#include "fat_string.h"

#include "hr_timer.h"
#include "av_buffer.h"
#include "mmc_async_io.h"
#include "jpeg_hw.h"
#include "timer.h"
#include "audio.h"
#include "ir_decode.h"
#include "fb_dev.h"
#include "ui.h"
#include "av_output.h"

#include "file_mjpg.h"
#include "file_jpg.h"
#ifdef INCLUDE_MP3_SUPPORT
#include "file_mp3.h"
#endif

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define FRAME_BUFFER0       (0x3000000)
#define FRAME_BUFFER1       (0x3100000)
#define FRAME_BUFFER2       (0x3200000)
#define FRAME_BUFFER3       (0x3300000)

#define APP_STACK_SIZE      (1024)

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
THREAD_DECL(main,   APP_STACK_SIZE);
THREAD_DECL(avout,  APP_STACK_SIZE);
THREAD_DECL(ui,     APP_STACK_SIZE);
THREAD_DECL(ir_dec, APP_STACK_SIZE);

// Mailbox for transfering buffers between threads
MAILBOX_DECL(fb, 32);

// Play requests
MAILBOX_DECL(play, 2);
MAILBOX_DECL(comp, 2);

//-----------------------------------------------------------------
// ui_select_handler
//-----------------------------------------------------------------
static void ui_select_handler(lv_obj_t * obj, lv_event_t event)
{
    if (event == LV_EVENT_CLICKED)
    {
        printf("Clicked: %s\n", lv_list_get_btn_text(obj));
        mailbox_post(&mbox_play, lv_list_get_btn_text(obj));

        // Block until player completes
        void *unused;
        mailbox_pend(&mbox_comp, &unused);
    }
}
//-----------------------------------------------------------------
// str_endswith
//-----------------------------------------------------------------
static int str_endswith(const char *str, const char *suffix)
{
    if (!str || !suffix)
        return 0;
    size_t lenstr = strlen(str);
    size_t lensuffix = strlen(suffix);
    if (lensuffix >  lenstr)
        return 0;
    return strncmp(str + lenstr - lensuffix, suffix, lensuffix) == 0;
}
//-----------------------------------------------------------------
// fb_clear: Clear (blank / black) frame buffer
//-----------------------------------------------------------------
void fb_clear(uint32_t fb_addr)
{
    uint32_t size = (CONFIG_SCREEN_HEIGHT * CONFIG_SCREEN_WIDTH * 2) / 4;
    uint32_t *p = (uint32_t*)fb_addr;
    for (uint32_t i=0;i<size;i++)
        *p = 0;
}
//-----------------------------------------------------------------
// user_stop: Stop playback request
//-----------------------------------------------------------------
static int user_stop(void)
{
    if (ir_ready())
    {
        uint32_t ir_code = ir_pop();
        if (ir_code == IR_CMD_BACK)
            return 1;
    }
    return 0;
}
//-----------------------------------------------------------------
// play_thread
//-----------------------------------------------------------------
void* play_thread(void * a)
{
    printf("play_thread: S\n");

    // Init AV buffers
    avbuf_init();

    // Init async MMC driver
    mmc_async_io_init(5, (65536/512));

    if (sd_init() < 0)
    {
        assert(!"SD init failed");
    }

    // Initialise FAT32 library
    fl_init();

    // Attach media access functions to library
    if (fl_attach_media(sd_readsector, sd_writesector) != FAT_INIT_OK)
    {
        assert(!"FS init failed");
    }
   
    // List a directory
    fl_listdirectory("/");

    // Populate OSD menu
    {
        FL_DIR dirstat;

        if (fl_opendir("/", &dirstat))
        {
            struct fs_dir_ent dirent;

            while (fl_readdir(&dirstat, &dirent) == 0)
            {
                if (!dirent.is_dir)
                {
                    char *f = malloc(strlen(dirent.filename) + 16);
                    sprintf(f, "/%s", dirent.filename);
                    printf("Menu: Add %s\n", f);
                    if (str_endswith(dirent.filename, ".mjpg2"))
                        ui_add_entry(f, ui_select_handler, LV_SYMBOL_VIDEO);
                    else if (str_endswith(dirent.filename, ".mp3"))
                        ui_add_entry(f, ui_select_handler, LV_SYMBOL_AUDIO);
                    else
                        ui_add_entry(f, ui_select_handler, LV_SYMBOL_FILE);
                }
            }

            fl_closedir(&dirstat);
        }

    }

    while (1)
    {
        // Run menu until user chooses play
        char *play_file;
        mailbox_pend(&mbox_play, &play_file);

        // Motion JPEG file
        if (str_endswith(play_file, ".mjpg2") || str_endswith(play_file, ".mjpg"))
        {
            // Switch to video mode
            fb_clear(FRAME_BUFFER1);
            fb_clear(FRAME_BUFFER2);
            fb_clear(FRAME_BUFFER3);
            fbdev_set_framebuffer(FRAME_BUFFER1);

            if (str_endswith(play_file, ".mjpg2"))
                file_mjpg_play(play_file, &mbox_fb, 24, user_stop);
            else
                file_mjpg_play(play_file, &mbox_fb, 25, user_stop);

            // Wait for end of play
            while (audio_fifo_level() != 0 || jpeg_hw_busy() || mbox_fb.count != 0)
                thread_sleep(1);

            // Change mode to menu
            fbdev_set_framebuffer(FRAME_BUFFER0);
        }
        else if (str_endswith(play_file, ".jpg"))
        {
            // Switch to video mode
            fb_clear(FRAME_BUFFER1);
            fb_clear(FRAME_BUFFER2);
            fb_clear(FRAME_BUFFER3);
            fbdev_set_framebuffer(FRAME_BUFFER1);

            file_jpg_play(play_file, &mbox_fb, user_stop);

            // Change mode to menu
            fbdev_set_framebuffer(FRAME_BUFFER0);
        }        
#ifdef INCLUDE_MP3_SUPPORT
        else if (str_endswith(play_file, ".mp3"))
        {
            file_mp3_play(play_file, &mbox_fb, user_stop);

            // Wait for end of play
            while (audio_fifo_level() != 0 || mbox_fb.count != 0)
                thread_sleep(1);
        }
#endif

        // Wakeup menu thread
        mailbox_post(&mbox_comp, NULL);
    }

    return NULL;
}
//-----------------------------------------------------------------
// custom_tick_get
//-----------------------------------------------------------------
uint32_t custom_tick_get(void)
{
    static uint32_t start = 0;
    if(start == 0)
        start = hrtimer_now();
    return hrtimer_ticks_to_ms(hrtimer_now() - start);
}
//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    // Setup the RTOS
    thread_kernel_init();

    // Setup IR decode
    ir_decode_init(0, 3);

    // Setup user interface
    ui_init();

    // Disable framebuffer (workaround for bug in framebuffer DMA)
    fbdev_init(CONFIG_FB_DEV_BASE, FRAME_BUFFER0, CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, 0, 0);
    timer_sleep(50);

    // Configure framebuffer
    fbdev_init(CONFIG_FB_DEV_BASE, FRAME_BUFFER0, CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, 1, 0);

    // Create init thread
    THREAD_INIT(main,  "PLAY",      play_thread, NULL, THREAD_MAX_PRIO - 3);
    THREAD_INIT(avout, "AVOUT",     av_output, &mbox_fb, THREAD_MAX_PRIO - 2);
    THREAD_INIT(ui,    "UI",        ui_thread, NULL, THREAD_MAX_PRIO - 1);
    THREAD_INIT(ir_dec,"IR_DECODE", ir_decode_thread, NULL, THREAD_MAX_PRIO);

    // Start kernel
    thread_kernel_run();

    // Kernel should never exit
    OS_ASSERT(0);

    return 0;
}

