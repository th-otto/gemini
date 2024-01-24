/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int disk_data[] = {
	0x0000, 0x0000, 0x0000, 0x0000, 0x3fff, 0xf780, 0x7e00, 0x1fc0,
	0x7e03, 0x9fe0, 0x7e03, 0x9fe0, 0x7e03, 0x9fe0, 0x7e03, 0x9fe0,
	0x7e03, 0x9fe0, 0x7e03, 0x9fe0, 0x7f00, 0x3fe0, 0x7fff, 0xffe0,
	0x7fff, 0xffe0, 0x7fff, 0xffe0, 0x7000, 0x00e0, 0x7000, 0x00e0,
	0x73c0, 0x00e0, 0x7000, 0x00e0, 0x73fd, 0x80e0, 0x7000, 0x00e0,
	0x7390, 0x00e0, 0x7000, 0x00e0, 0x73fe, 0x60e0, 0x7000, 0x00e0,
	0x537c, 0xc0e0, 0x5000, 0x00e0, 0x7000, 0x00e0, 0x3fff, 0xffc0,
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
};
static BITBLK disk_bitblk = { disk_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImDisk(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(disk_data, 4, 32, HandAES);
	}
	return &disk_bitblk;
}
