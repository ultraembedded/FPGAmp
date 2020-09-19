#ifndef __FILE_MJPG_H__
#define __FILE_MJPG_H__

#include "kernel/mailbox.h"

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
int file_mjpg_play(const char *play_file, struct mailbox *mbox, int (*cb_stopped)(void));

#endif
