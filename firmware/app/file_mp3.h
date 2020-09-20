#ifndef __FILE_MP3_H__
#define __FILE_MP3_H__

#include "kernel/mailbox.h"

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
int file_mp3_play(const char *filename, struct mailbox *mbox, int (*cb_stopped)(void));

#endif // __FILE_MP3_H__
