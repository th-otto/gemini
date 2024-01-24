/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int question_data[] = {
	0x0000, 0x0000, 0x001f, 0xfe00, 0x007f, 0xff80, 0x00ff, 0xffc0,
	0x01ff, 0xffe0, 0x01f8, 0x07e0, 0x01f0, 0x03e0, 0x01f0, 0x03e0,
	0x00e0, 0x03e0, 0x0000, 0x07c0, 0x0000, 0x0fc0, 0x0000, 0x1f80,
	0x0000, 0x3f00, 0x0000, 0x7e00, 0x0000, 0xfc00, 0x0001, 0xf800,
	0x0003, 0xf000, 0x0003, 0xe000, 0x0007, 0xc000, 0x0007, 0xc000,
	0x0007, 0xc000, 0x0007, 0xc000, 0x0007, 0xc000, 0x0003, 0x8000,
	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0007, 0xc000,
	0x000f, 0xe000, 0x000f, 0xe000, 0x0007, 0xc000, 0x0000, 0x0000
};
static BITBLK question_bitblk = { question_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImQuestionMark(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(question_data, 4, 32, HandAES);
	}
	return &question_bitblk;
}
