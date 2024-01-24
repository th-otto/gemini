/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int hand_data[] = {
	0x0000, 0x0000, 0x0001, 0xc000, 0x0073, 0xe000, 0x00fb, 0xe700,
	0x00fb, 0xef80, 0x1cfb, 0xef80, 0x3efb, 0xef80, 0x3efb, 0xef80,
	0x3efb, 0xef80, 0x3efb, 0xef80, 0x3efb, 0xef80, 0x3efb, 0xef80,
	0x3efb, 0xef9c, 0x3efb, 0xefbc, 0x3efb, 0xefbc, 0x3fff, 0xff7c,
	0x3fff, 0xff7c, 0x3fff, 0xff7c, 0x3fff, 0xfefc, 0x3fff, 0xf7f8,
	0x3fff, 0xdff8, 0x3fff, 0x7ff0, 0x3fff, 0xfff0, 0x3ffd, 0xffe0,
	0x1ffd, 0xffc0, 0x0fff, 0xff80, 0x07ff, 0xff00, 0x03ff, 0xfe00,
	0x03ff, 0xfe00, 0x03ff, 0xfe00, 0x03ff, 0xfe00, 0x0000, 0x0000
};
static BITBLK hand_bitblk = { hand_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImHand(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(hand_data, 4, 32, HandAES);
	}
	return &hand_bitblk;
}
