#ifndef __UI_H__
#define __UI_H__

#include "lvgl/lvgl.h"

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void ui_init(void);
void ui_add_entry(char *name, void (*handler)(lv_obj_t * obj, lv_event_t event), const void * img);
void *ui_thread(void *arg);

#endif
