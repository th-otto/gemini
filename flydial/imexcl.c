/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int exclamation_data[] = {
	0x0003, 0xc000, 0x0006, 0x6000, 0x000d, 0xb000, 0x001b, 0xd800,
	0x0037, 0xec00, 0x006f, 0xf600, 0x00dc, 0x3b00, 0x01bc, 0x3d80,
	0x037c, 0x3ec0, 0x06fc, 0x3f60, 0x0dfc, 0x3fb0, 0x1bfc, 0x3fd8,
	0x37fc, 0x3fec, 0x6ffc, 0x3ff6, 0xdffc, 0x3ffb, 0xbffc, 0x3ffd,
	0xbffc, 0x3ffd, 0xdffc, 0x3ffb, 0x6ffc, 0x3ff6, 0x37fc, 0x3fec,
	0x1bff, 0xffd8, 0x0dff, 0xffb0, 0x06fc, 0x3f60, 0x037c, 0x3ec0,
	0x01bc, 0x3d80, 0x00dc, 0x3b00, 0x006f, 0xf600, 0x0037, 0xec00,
	0x001b, 0xd800, 0x000d, 0xb000, 0x0006, 0x6000, 0x0003, 0xc000
};
static BITBLK exclamation_bitblk = { exclamation_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImExclamation(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(exclamation_data, 4, 32, HandAES);
	}
	return &exclamation_bitblk;
}
