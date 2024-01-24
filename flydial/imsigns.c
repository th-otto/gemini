/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int signstop_data[] = {
	0x007f, 0xfe00, 0x00c0, 0x0300, 0x01bf, 0xfd80, 0x037f, 0xfec0,
	0x06ff, 0xff60, 0x0dff, 0xffb0, 0x1bff, 0xffd8, 0x37ff, 0xffec,
	0x6fff, 0xfff6, 0xdfff, 0xfffb, 0xb181, 0x860d, 0xa081, 0x0205,
	0xa4e7, 0x3265, 0xa7e7, 0x3265, 0xa3e7, 0x3265, 0xb1e7, 0x3205,
	0xb8e7, 0x320d, 0xbce7, 0x327d, 0xa4e7, 0x327d, 0xa0e7, 0x027d,
	0xb1e7, 0x867d, 0xbfff, 0xfffd, 0xdfff, 0xfffb, 0x6fff, 0xfff6,
	0x37ff, 0xffec, 0x1bff, 0xffd8, 0x0dff, 0xffb0, 0x06ff, 0xff60,
	0x037f, 0xfec0, 0x01bf, 0xfd80, 0x00c0, 0x0300, 0x007f, 0xfe00
};
static BITBLK signstop_bitblk = { signstop_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImSignStop(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(signstop_data, 4, 32, HandAES);
	}
	return &signstop_bitblk;
}
