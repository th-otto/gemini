/*
	@(#)FlyDial/graf.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static int formnum = 0;
static int hidecount = 0;
static MFORM mform;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void GrafGetForm(int *num, MFORM *form)
{
	*num = formnum;
	*form = mform;
}

/*** ---------------------------------------------------------------------- ***/

void GrafMouse(int num, MFORM *form)
{
	switch (num)
	{
	case M_ON:
		if (hidecount == 1)
			graf_mouse(M_ON, NULL);
		if (hidecount != 0)
			--hidecount;
		break;
	case M_OFF:
		if (hidecount == 0)
			graf_mouse(M_OFF, NULL);
		++hidecount;
		break;
	case USER_DEF:
		mform = *form;
		formnum = num;
		graf_mouse(num, form);
		break;
	default:
		formnum = num;
		graf_mouse(num, form);
		break;
	}
}
