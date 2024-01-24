/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int sqquestion_data[] = {
	0x3fff, 0xfffc, 0x7fff, 0xfffe, 0x7ff8, 0x1ffe, 0x7fe0, 0x07fe,
	0x7f80, 0x01fe, 0x7f00, 0x00fe, 0x7e00, 0x007e, 0x7e01, 0xc07e,
	0x7e03, 0xc07e, 0x7f07, 0x80fe, 0x7fff, 0x01fe, 0x7ffe, 0x01fe,
	0x7ffc, 0x03fe, 0x7ff8, 0x07fe, 0x7ff8, 0x07fe, 0x7ff0, 0x0ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff8, 0x1ffe, 0x7ffc, 0x3ffe,
	0x7fff, 0xfffe, 0x7fff, 0xfffe, 0x7ffc, 0x3ffe, 0x7ff8, 0x1ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff8, 0x1ffe,
	0x7ffc, 0x3ffe, 0x7fff, 0xfffe, 0x3fff, 0xfffc, 0x0000, 0x0000
};
static BITBLK sqquestion_bitblk = { sqquestion_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImSqQuestionMark(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(sqquestion_data, 4, 32, HandAES);
	}
	return &sqquestion_bitblk;
}
