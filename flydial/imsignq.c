/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int signquestion_data[] = {
	0x3fff, 0xfffc, 0xc000, 0x0003, 0x9fff, 0xfff9, 0xbfff, 0xfffd,
	0xdff8, 0x3ffb, 0x5fe0, 0x0ffa, 0x6fc0, 0x07f6, 0x2f83, 0x83f4,
	0x3787, 0xc3ec, 0x1787, 0xc3e8, 0x1bff, 0x83d8, 0x0bff, 0x07d0,
	0x0dfe, 0x0fb0, 0x05fc, 0x1fa0, 0x06fc, 0x3f60, 0x02fc, 0x3f40,
	0x037c, 0x3ec0, 0x017c, 0x3e80, 0x01bf, 0xfd80, 0x00bf, 0xfd00,
	0x00dc, 0x3b00, 0x005c, 0x3a00, 0x006c, 0x3600, 0x002f, 0xf400,
	0x0037, 0xec00, 0x0017, 0xe800, 0x001b, 0xd800, 0x000b, 0xd000,
	0x000d, 0xb000, 0x0005, 0xa000, 0x0006, 0x6000, 0x0003, 0xc000
};
static BITBLK signquestion_bitblk = { signquestion_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImSignQuestion(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(signquestion_data, 4, 32, HandAES);
	}
	return &signquestion_bitblk;
}
