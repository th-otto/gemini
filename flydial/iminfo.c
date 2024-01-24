/*
	@(#)FlyDial/images.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int info_data[] = {
	0x3fff, 0xfffc, 0x7fff, 0xfffe, 0x7ffc, 0x3ffe, 0x7ff8, 0x1ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff8, 0x1ffe,
	0x7ffc, 0x3ffe, 0x7fff, 0xfffe, 0x7fff, 0xfffe, 0x7f80, 0x0ffe,
	0x7f80, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe,
	0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7ff0, 0x0ffe, 0x7f80, 0x01fe,
	0x7f80, 0x01fe, 0x7fff, 0xfffe, 0x3fff, 0xfffc, 0x0000, 0x0000
};
static BITBLK info_bitblk = { info_data, 4, 32, 0, 0, BLACK };
static int initialized = FALSE;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

BITBLK *ImInfo(void)
{
	if (!initialized)
	{
		initialized = TRUE;
		/* FIXME: use info from bitblk */
		RastTrans(info_data, 4, 32, HandAES);
	}
	return &info_bitblk;
}
