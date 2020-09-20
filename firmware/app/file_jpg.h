#ifndef __FILE_JPG_H__
#define __FILE_JPG_H__

#include "kernel/mailbox.h"

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
int file_jpg_play(const char *filename, struct mailbox *mbox, int (*cb_stopped)(void));

#endif
