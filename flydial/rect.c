/*
	@(#)FlyDial/rast.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

#undef min
#undef max
#define max(a, b) (((a) > (b)) ? (a) : (b))
#define min(a, b) (((a) < (b)) ? (a) : (b))

static GRECT desk = { 0, 0, 0, 0 };

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void RectAES2VDI(int x, int y, int w, int h, int *xy)
{
	*xy++ = x;
	*xy++ = y;
	*xy++ = x + w - 1;
	*xy = y + h - 1;
}

/*** ---------------------------------------------------------------------- ***/

void RectGRECT2VDI(const GRECT *gr, int *xy)
{
	*xy++ = gr->g_x;
	*xy++ = gr->g_y;
	*xy++ = gr->g_x + gr->g_w - 1;
	*xy = gr->g_y + gr->g_h - 1;
}

/*** ---------------------------------------------------------------------- ***/

int RectInter(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2, int *x3, int *y3, int *w3, int *h3)
{
	int t, t2;

	*x3 = max(x1, x2);
	*y3 = max(y1, y2);
	t = x1 + w1;
	t2 = x2 + w2;
	*w3 = min(t, t2) - *x3;
	t = y1 + h1;
	t2 = y2 + h2;
	*h3 = min(t, t2) - *y3;
	return *w3 > 0 && *h3 > 0;
}

/*** ---------------------------------------------------------------------- ***/

int RectGInter(const GRECT *a, const GRECT *b, GRECT *c)
{
	int t, t2;

	c->g_x = max(a->g_x, b->g_x);
	c->g_y = max(a->g_y, b->g_y);
	t = a->g_x + a->g_w;
	t2 = b->g_x + b->g_w;
	c->g_w = min(t, t2) - c->g_x;
	t = a->g_y + a->g_h;
	t2 = b->g_y + b->g_h;
	c->g_h = min(t, t2) - c->g_y;
	return c->g_w > 0 && c->g_h > 0;
}

/*** ---------------------------------------------------------------------- ***/

int RectOnScreen(int x, int y, int w, int h)
{
	int screenx, screeny, screenw, screenh;
	
	HandScreenSize(&screenx, &screeny, &screenw, &screenh);
	return x >= screenx && y >= screeny && x + w <= screenx + screenw && y + h <= screeny + screenh;
}

/*** ---------------------------------------------------------------------- ***/

int RectInside(int x, int y, int w, int h, int x2, int y2)
{
	return x2 >= x && y2 >= y && x2 < x + w && y2 < y + h;
}

/*** ---------------------------------------------------------------------- ***/

int RectClipWithScreen(GRECT *g)
{
	GRECT g2;

	if (desk.g_w == 0)
		HandScreenSize(&desk.g_x, &desk.g_y, &desk.g_w, &desk.g_h);
	g2 = *g;
	return RectGInter(&g2, &desk, g);
}
