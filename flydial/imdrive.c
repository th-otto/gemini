/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int drive_data[] = {
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x2000, 0x0000, 0x7000,
	0x0000, 0xf800, 0x0001, 0xfc00, 0x0002, 0xfe00, 0x0004, 0x7f00,
	0x0008, 0x3f80, 0x0010, 0x3fc0, 0x0020, 0x7fe0, 0x0043, 0xe7c0,
	0x0087, 0xc3a0, 0x0087, 0xc160, 0x0147, 0xc2e0, 0x01a3, 0x85e0,
	0x01d0, 0x0be0, 0x00e8, 0x17e0, 0x0134, 0x2fc0, 0x019a, 0x5f80,
	0x018d, 0xbf00, 0x00c6, 0x7e00, 0x0066, 0xfc00, 0x0032, 0xf800,
	0x001c, 0xf000, 0x000e, 0xe000, 0x0006, 0xc000, 0x0002, 0x8000,
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
};
static BITBLK drive_bitblk = { drive_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImDrive(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(drive_data, 4, 32, HandAES);
	}
	return &drive_bitblk;
}
