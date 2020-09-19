#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "lvgl/lvgl.h"

#include "kernel/critical.h"
#include "kernel/thread.h"

#include "ui.h"
#include "ir_decode.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define DISP_BUF_SIZE (80 * LV_HOR_RES_MAX)

struct bsd_fb_var_info{
    uint32_t xoffset;
    uint32_t yoffset;
    uint32_t xres;
    uint32_t yres;
    int bits_per_pixel;
 };

struct bsd_fb_fix_info{
    long int line_length;
    long int smem_len;
};

static struct bsd_fb_var_info vinfo;
static struct bsd_fb_fix_info finfo;
static char *fbp = 0;
static long int screensize = 0;

#define FRAME_BUFFER0 (0x3000000)

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static lv_obj_t *   ui_list;

/*A small buffer for LittlevGL to draw the screen's content*/
static lv_color_t buf[DISP_BUF_SIZE];

static lv_disp_buf_t disp_buf;

static lv_indev_state_t state = LV_INDEV_STATE_REL;

// Background image definition
LV_IMG_DECLARE(background);

//-----------------------------------------------------------------
// ui_ir_read: Poll IR decoder for useful requests
//-----------------------------------------------------------------
static bool ui_ir_read(lv_indev_drv_t * indev_drv, lv_indev_data_t * data)
{
    (void) indev_drv;      /*Unused*/
    int16_t enc_diff = 0;

    if (state == LV_INDEV_STATE_REL)
    {
        if (ir_ready())
        {
            uint32_t ir_code = ir_pop();
            printf("IR: %08x\n", ir_code);
        
            if (ir_code == IR_CMD_DOWN)
                enc_diff = 1;
            else if (ir_code == IR_CMD_UP)
                enc_diff = -1;
            else if (ir_code == IR_CMD_RIGHT)
                state = LV_INDEV_STATE_PR;
        }
    }
    else
        state = LV_INDEV_STATE_REL;

    data->state = state;
    data->enc_diff = enc_diff;

    return false;
}
//-----------------------------------------------------------------
// lvgl_fbinit
//-----------------------------------------------------------------
static void lvgl_fbinit(void)
{
    vinfo.xres = CONFIG_SCREEN_WIDTH;
    vinfo.yres = CONFIG_SCREEN_HEIGHT;
    vinfo.bits_per_pixel = 16;
    vinfo.xoffset = 0;
    vinfo.yoffset = 0;
    finfo.line_length = vinfo.xres * 2;
    finfo.smem_len = finfo.line_length * vinfo.yres;

    printf("%dx%d, %dbpp\n", vinfo.xres, vinfo.yres, vinfo.bits_per_pixel);

    // Figure out the size of the screen in bytes
    screensize =  finfo.smem_len; //finfo.line_length * vinfo.yres;    

    // Map the device to memory
    fbp = (char *)FRAME_BUFFER0;
    memset(fbp, 0, screensize);

    printf("The framebuffer device was mapped to memory successfully.\n");

}
//-----------------------------------------------------------------
// lvgl_fbflush
//-----------------------------------------------------------------
/**
 * Flush a buffer to the marked area
 * @param drv pointer to driver where this function belongs
 * @param area an area where to copy `color_p`
 * @param color_p an array of pixel to copy to the `area` part of the screen
 */
static void lvgl_fbflush(lv_disp_drv_t * drv, const lv_area_t * area, lv_color_t * color_p)
{
    if(fbp == NULL ||
            area->x2 < 0 ||
            area->y2 < 0 ||
            area->x1 > (int32_t)vinfo.xres - 1 ||
            area->y1 > (int32_t)vinfo.yres - 1) {
        lv_disp_flush_ready(drv);
        return;
    }

    /*Truncate the area to the screen*/
    int32_t act_x1 = area->x1 < 0 ? 0 : area->x1;
    int32_t act_y1 = area->y1 < 0 ? 0 : area->y1;
    int32_t act_x2 = area->x2 > (int32_t)vinfo.xres - 1 ? (int32_t)vinfo.xres - 1 : area->x2;
    int32_t act_y2 = area->y2 > (int32_t)vinfo.yres - 1 ? (int32_t)vinfo.yres - 1 : area->y2;


    lv_coord_t w = (act_x2 - act_x1 + 1);
    long int location = 0;
    long int byte_location = 0;
    unsigned char bit_location = 0;

    /*32 or 24 bit per pixel*/
    if(vinfo.bits_per_pixel == 32 || vinfo.bits_per_pixel == 24) {
        uint32_t * fbp32 = (uint32_t *)fbp;
        int32_t y;
        for(y = act_y1; y <= act_y2; y++) {
            location = (act_x1 + vinfo.xoffset) + (y + vinfo.yoffset) * finfo.line_length / 4;
            memcpy(&fbp32[location], (uint32_t *)color_p, (act_x2 - act_x1 + 1) * 4);
            color_p += w;
        }
    }
    /*16 bit per pixel*/
    else if(vinfo.bits_per_pixel == 16) {
        uint16_t * fbp16 = (uint16_t *)fbp;
        int32_t y;
        for(y = act_y1; y <= act_y2; y++) {
            location = (act_x1 + vinfo.xoffset) + (y + vinfo.yoffset) * finfo.line_length / 2;
            memcpy(&fbp16[location], (uint32_t *)color_p, (act_x2 - act_x1 + 1) * 2);
            color_p += w;
        }
    }
    /*8 bit per pixel*/
    else if(vinfo.bits_per_pixel == 8) {
        uint8_t * fbp8 = (uint8_t *)fbp;
        int32_t y;
        for(y = act_y1; y <= act_y2; y++) {
            location = (act_x1 + vinfo.xoffset) + (y + vinfo.yoffset) * finfo.line_length;
            memcpy(&fbp8[location], (uint32_t *)color_p, (act_x2 - act_x1 + 1));
            color_p += w;
        }
    }
    /*1 bit per pixel*/
    else if(vinfo.bits_per_pixel == 1) {
        uint8_t * fbp8 = (uint8_t *)fbp;
        int32_t x;
        int32_t y;
        for(y = act_y1; y <= act_y2; y++) {
            for(x = act_x1; x <= act_x2; x++) {
                location = (x + vinfo.xoffset) + (y + vinfo.yoffset) * vinfo.xres;
                byte_location = location / 8; /* find the byte we need to change */
                bit_location = location % 8; /* inside the byte found, find the bit we need to change */
                fbp8[byte_location] &= ~(((uint8_t)(1)) << bit_location);
                fbp8[byte_location] |= ((uint8_t)(color_p->full)) << bit_location;
                color_p++;
            }

            color_p += area->x2 - act_x2;
        }
    } else {
        /*Not supported bit per pixel*/
    }

    lv_disp_flush_ready(drv);
}
//-----------------------------------------------------------------
// ui_init
//-----------------------------------------------------------------
void ui_init(void)
{
    /*LittlevGL init*/
    lv_init();

    /*Frame buffer device init*/
    lvgl_fbinit();

    /*Initialize a descriptor for the buffer*/
    lv_disp_buf_init(&disp_buf, buf, NULL, DISP_BUF_SIZE);

    /*Initialize and register a display driver*/
    lv_disp_drv_t disp_drv;
    lv_disp_drv_init(&disp_drv);
    disp_drv.buffer   = &disp_buf;
    disp_drv.flush_cb = lvgl_fbflush;
    lv_disp_drv_register(&disp_drv);

    lv_group_t*  g = lv_group_create();
    //lv_group_set_focus_cb(g, focus_cb);

    lv_indev_drv_t enc_drv;
    lv_indev_drv_init(&enc_drv);
    enc_drv.type = LV_INDEV_TYPE_ENCODER;
    enc_drv.read_cb = ui_ir_read;
    lv_indev_t * enc_indev = lv_indev_drv_register(&enc_drv);
    lv_indev_set_group(enc_indev, g);

    // Load background image
    lv_obj_t * image = lv_img_create(lv_scr_act(), NULL);
    lv_img_set_src(image, &background);

    /*Create a list*/
    lv_obj_t * list1 = lv_list_create(lv_scr_act(), NULL);
    lv_obj_set_size(list1, 400, 400);
    lv_obj_align(list1, NULL, LV_ALIGN_CENTER, 0, 0);

    lv_group_add_obj(g, list1);
    ui_list = list1;
}
//-----------------------------------------------------------------
// ui_add_entry: Add entry to file list
//-----------------------------------------------------------------
void ui_add_entry(char *name, void (*handler)(lv_obj_t * obj, lv_event_t event), const void * img)
{
    int cr = critical_start();
    lv_obj_t * list_btn = lv_list_add_btn(ui_list, img, name);
    lv_obj_set_event_cb(list_btn, handler);
    critical_end(cr);
}
//-----------------------------------------------------------------
// ui_thread: User interface thread
//-----------------------------------------------------------------
void *ui_thread(void *arg)
{
    while (1)
    {
        lv_task_handler();
        thread_sleep(40);
    }
}