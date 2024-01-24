/*
	@(#)FlyDial/hand.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

int HandAES;
int HandXSize;
int HandYSize;
int HandBXSize;
int HandBYSize;

static char sccs_id[] = "@(#)Fliegende Dialoge 0.31, Copyright (c)  Julian F. Reschke, Apr 02 1991";
static int deskx = -1;
static int desky;
static int deskw;
static int deskh;
static int clip_x = -1;
static int clip_y = -1;
static int clip_w = -1;
static int clip_h = -1;
static int clip_flag = -1;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

int HandFast(void)
{
	int blitmode;
	int workout[56]; /* BUG: too small */
	int fast;
	
	blitmode = Blitmode(-1);
	vq_extnd(HandAES, 1, workout);
	fast = FALSE;
	if (workout[6] > 2000) /* Performance factor (number of 16*16 raster operations per second) */
		fast = TRUE;
	if ((blitmode & 3) == 2) /* Blitter present, but inactive */
		fast = FALSE;
	if (blitmode & 1)
		fast = TRUE;
	/* XXX tst.w d0 in original? */
	return fast;
}

/*** ---------------------------------------------------------------------- ***/

void HandScreenSize(int *x, int *y, int *w, int *h)
{
	if (deskx == -1)
	{
		wind_get(0, WF_WORKXYWH, &deskx, &desky, &deskw, &deskh);
	}
	*x = deskx;
	*y = desky;
	*w = deskw;
	*h = deskh;
}

/*** ---------------------------------------------------------------------- ***/

void HandInit(void)
{
	(void)sccs_id; /* shut up compiler */
	HandAES = graf_handle(&HandXSize, &HandYSize, &HandBXSize, &HandBYSize);
}

/*** ---------------------------------------------------------------------- ***/

void HandClip(int x, int y, int w, int h, int flag)
{
	int pxy[4];
	
	if (w == 0)
		flag = FALSE;
	if (flag != clip_flag || x != clip_x || y != clip_y || w != clip_w || h != clip_h)
	{
		clip_x = x;
		clip_y = y;
		clip_w = w;
		clip_h = h;
		clip_flag = flag;
		RectAES2VDI(x, y, w, h, pxy);
		vs_clip(DialWk, flag, pxy);
	}
}
