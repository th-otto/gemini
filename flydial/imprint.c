/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int printer_data[] = {
	0x0000, 0x0000, 0x0000, 0x8000, 0x0001, 0xc000, 0x0003, 0xe000,
	0x0003, 0xf000, 0x0007, 0xf800, 0x0007, 0xfc00, 0x0017, 0xfe00,
	0x0037, 0xff00, 0x006f, 0xff00, 0x00df, 0xfe00, 0x01bf, 0xfe00,
	0x037f, 0xfc00, 0x01bf, 0xfd00, 0x02df, 0xfd80, 0x036f, 0xfb00,
	0x03b7, 0xf680, 0x03db, 0xed80, 0x03ed, 0xdb80, 0x03f6, 0xb780,
	0x03fb, 0x6f80, 0x01fd, 0xdf00, 0x00fe, 0xbec0, 0x007f, 0x7dc0,
	0x003f, 0x7dc0, 0x001f, 0x7d80, 0x000f, 0x7800, 0x0007, 0x7000,
	0x0003, 0x6000, 0x0001, 0x4000, 0x0000, 0x0000, 0x0000, 0x0000
};
static BITBLK printer_bitblk = { printer_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImPrinter(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(printer_data, 4, 32, HandAES);
	}
	return &printer_bitblk;
}
