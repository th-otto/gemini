/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int bomb_data[] = {
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xc790, 0x0000, 0xf844,
	0x003d, 0xf830, 0x01ff, 0xfcb2, 0x07ff, 0xfc00, 0x0fff, 0xf848,
	0x1f3f, 0xf800, 0x1e67, 0xf800, 0x3fcf, 0xfc00, 0x3cff, 0xfc00,
	0x3c9f, 0xfc00, 0x7f9f, 0xfe00, 0x7fff, 0xfe00, 0x7fff, 0xfe00,
	0x7fff, 0xfe00, 0x3fff, 0xfc00, 0x3fff, 0xfc00, 0x3fff, 0xfc00,
	0x1fff, 0xf800, 0x1fff, 0xf800, 0x0fff, 0xf000, 0x07ff, 0xe000,
	0x01ff, 0x8000, 0x003c, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
};
static BITBLK bomb_bitblk = { bomb_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImBomb(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(bomb_data, 4, 32, HandAES);
	}
	return &bomb_bitblk;
}
