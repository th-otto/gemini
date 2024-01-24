/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int finger_data[] = {
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0700, 0x0000, 0x0f80,
	0x0000, 0x0f80, 0x0000, 0x0f80, 0x0000, 0x0f80, 0x0000, 0x0f80,
	0x0000, 0x0f80, 0x0000, 0x0f80, 0x0000, 0x0f80, 0x0000, 0x0f80,
	0x0079, 0xef9c, 0x0efb, 0xefbc, 0x1efb, 0xefbc, 0x1efb, 0xef7c,
	0x16aa, 0xaf7c, 0x1efb, 0xef7c, 0x0d75, 0xdcbc, 0x038e, 0x37f8,
	0x1fff, 0xdff8, 0x1fff, 0x7ff0, 0x1fff, 0xfff0, 0x1ffd, 0xffe0,
	0x1fff, 0xffc0, 0x0ffd, 0xff80, 0x07ff, 0xfe00, 0x01ff, 0xf400,
	0x015f, 0xfc00, 0x01ff, 0xfc00, 0x01ff, 0xfc00, 0x0000, 0x0000
};
static BITBLK finger_bitblk = { finger_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImFinger(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(finger_data, 4, 32, HandAES);
	}
	return &finger_bitblk;
}
