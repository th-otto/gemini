/*
	@(#)FlyDial/wind.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int wind_update_count = 0;
static int wind_ctrl_count = 0;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void WindUpdate(int mode)
{
	switch (mode)
	{
	case BEG_UPDATE:
		if (wind_update_count == 0)
			wind_update(BEG_UPDATE);
		wind_update_count++;
		break;

	case END_UPDATE:
		if (wind_update_count == 1)
			wind_update(END_UPDATE);
		if (wind_update_count != 0)
			wind_update_count--;
		break;

	case BEG_MCTRL:
		if (wind_ctrl_count == 0)
			wind_update(BEG_MCTRL);
		wind_ctrl_count++;
		break;

	case END_MCTRL:
		if (wind_ctrl_count == 1)
			wind_update(END_MCTRL);
		if (wind_ctrl_count != 0)
			wind_ctrl_count--;
		break;
	}
}

/*** ---------------------------------------------------------------------- ***/

void WindRestoreControl(void)
{
	if (wind_update_count != 0)
		wind_update(BEG_UPDATE);
	if (wind_ctrl_count != 0)
		wind_update(END_MCTRL); /* BUG? should be BEG_MCTRL */
}
