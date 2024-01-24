/*
	@(#)FlyDial/slid.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include "slid.h"
#include <string.h>
#include <stdlib.h>

#define SL_UP   1
#define SL_BAR  2
#define SL_ELEV 3
#define SL_DOWN 4

static OBJECT slider_tree[] = {
	{ -1,  1,  4, G_BOX,     0x0000, 0x0000, { 0x00011110L },  0,  0, 37, 1 },
	{  2, -1, -1, G_BOXCHAR, 0x0000, 0x0000, { 0x04011101L },  0,  0,  4, 1 },
	{  4,  3,  3, G_BOX,     0x0000, 0x0000, { 0x00011111L },  4,  0, 29, 1 },
	{  2, -1, -1, G_BOX,     0x0000, 0x0000, { 0x00011100L }, 11,  0,  6, 1 },
	{  0, -1, -1, G_BOXCHAR, 0x0020, 0x0000, { 0x03011101L }, 33,  0,  4, 1 }
};

#define DIM(x) (int)(sizeof(x)/sizeof(x[0]))

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void SlidDraw(SLIDERSPEC *s, int xc, int yc, int wc, int hc, int redraw)
{
	int screenx, screeny, screenw, screenh;
	int grx, gry, grw, grh;
	int lastdraw;
	int x;
	int w;
	int rx, rw;
	int visible;

	if (!s->drawn)
		redraw = s->drawn = TRUE;
	HandScreenSize(&screenx, &screeny, &screenw, &screenh);
	RectInter(xc, yc, wc, hc, screenx, screeny, screenw, screenh, &grx, &gry, &grw, &grh);
	lastdraw = s->lastdraw;
	if (s->hori)
	{
		x = s->ob[SL_ELEV].ob_x;
		w = s->ob[SL_ELEV].ob_width;
	} else
	{
		x = s->ob[SL_ELEV].ob_y;
		w = s->ob[SL_ELEV].ob_height;
	}
	if (redraw)
	{
		objc_draw(s->ob, ROOT, 10, grx, gry, grw, grh);
	} else if (x != lastdraw)
	{
		if (lastdraw > x && x + w > lastdraw)
		{
			rx = x + w;
			rw = lastdraw - x;
		} else if (x > lastdraw && lastdraw + w > x)
		{
			rx = lastdraw;
			rw = x - lastdraw;
		} else
		{
			rx = lastdraw;
			rw = w;
		}
		if (s->hori)
		{
			visible = RectInter(grx, gry, grw, grh, rx + s->offset, yc, rw, hc, &screenx, &screeny, &screenw, &screenh);
		} else
		{
			visible = RectInter(grx, gry, grw, grh, xc, rx + s->offset, wc, rw, &screenx, &screeny, &screenw, &screenh);
		}
		if (visible)
			objc_draw(s->ob, SL_BAR, 0, screenx, screeny, screenw, screenh);
		objc_draw(s->ob, SL_ELEV, 0, xc, yc, wc, hc);
	}
	if (redraw)
		s->lastdraw = x;
}

/*** ---------------------------------------------------------------------- ***/

void SlidDrCompleted(SLIDERSPEC *s)
{
	if (s->hori)
		s->lastdraw = s->ob[SL_ELEV].ob_x;
	else
		s->lastdraw = s->ob[SL_ELEV].ob_y;
}

/*** ---------------------------------------------------------------------- ***/

void SlidSlidSize(SLIDERSPEC *s, int size)
{
	int w, sw;
	
	s->lastdraw = -1;
	s->size = size;
	if (size != -1)
	{
		if (size == 0)
		{
			if (s->hori)
				w = s->ob[SL_BAR].ob_width;
			else
				w = s->ob[SL_BAR].ob_height;
		} else
		{
			long lw;
			
			if (s->hori)
				sw = s->ob[SL_BAR].ob_width;
			else
				sw = s->ob[SL_BAR].ob_height;
			lw = (long)sw * size;
			lw = lw / (s->size + s->scale);
			w = (int) lw;
			if (w < s->ob[SL_UP].ob_width)
				w = s->ob[SL_UP].ob_width;
		}
	} else
	{
		w = s->ob[SL_UP].ob_width;
	}
	if (s->hori)
		s->ob[SL_ELEV].ob_width = w;
	else
		s->ob[SL_ELEV].ob_height = w;
}

/*** ---------------------------------------------------------------------- ***/

void SlidScale(SLIDERSPEC *s, long scale)
{
	s->lastdraw = -1;
	s->scale = scale;
	SlidSlidSize(s, s->size);
}

/*** ---------------------------------------------------------------------- ***/

void SlidPos(SLIDERSPEC *s, long pos)
{
	int w;
	long lw;
	
	if (pos != s->position)
	{
		s->position = pos;
		if (s->hori)
			w = s->ob[SL_BAR].ob_width - s->ob[SL_ELEV].ob_width;
		else
			w = s->ob[SL_BAR].ob_height - s->ob[SL_ELEV].ob_height;
		lw = w;
		lw = lw * pos;
		lw = lw / s->scale;
		if (s->hori)
			s->ob[SL_ELEV].ob_x = (int)lw;
		else
			s->ob[SL_ELEV].ob_y = (int)lw;
	}
}

/*** ---------------------------------------------------------------------- ***/

SLIDERSPEC *SlidCreate(SLIDERSPEC *Slider, int hori, int accel)
{
	int i;
	
	if (Slider == NULL)
		Slider = calloc(1, sizeof(*Slider));
	if (Slider == NULL)
		return NULL;
	Slider->accel = accel;
	Slider->hori = hori;
	/* BUG? object tree not set up yet */
	SlidScale(Slider, 1000);
	SlidSlidSize(Slider, -1);
	SlidPos(Slider, 0);
	memcpy(Slider->ob, slider_tree, sizeof(Slider->ob));
	/* XXX */
	for (i = 0; i <= DIM(Slider->ob) - 1; i++)
	{
		Slider->ob[i].ob_x = Slider->ob[i].ob_y = 0;
		Slider->ob[i].ob_height = HandBYSize;
		Slider->ob[i].ob_width = HandBXSize;
	}
	return Slider;
}

/*** ---------------------------------------------------------------------- ***/

void SlidDelete(SLIDERSPEC *s)
{
	free(s);
}

/*** ---------------------------------------------------------------------- ***/

void SlidExtents(SLIDERSPEC *s, int x, int y, int len)
{
	x -= 1;
	y -= 1;
	len += 2;
	s->lastdraw = -1;
	s->ob[ROOT].ob_x = x;
	s->ob[ROOT].ob_y = y;
	if (s->hori)
	{
		s->ob[ROOT].ob_width = len;
		s->ob[SL_BAR].ob_x = s->ob[SL_UP].ob_width - 1;
		s->ob[SL_BAR].ob_width = len + 2 - 2 * s->ob[SL_UP].ob_width;
		s->offset = x + s->ob[SL_BAR].ob_x;
	} else
	{
		s->ob[SL_UP].ob_spec.obspec.character = '\001';
		s->ob[SL_DOWN].ob_spec.obspec.character = '\002';
		s->ob[ROOT].ob_height = len;
		s->ob[SL_BAR].ob_y = s->ob[SL_UP].ob_height - 1;
		s->ob[SL_BAR].ob_height = len + 2 - 2 * s->ob[SL_UP].ob_height;
		s->offset = y + s->ob[SL_BAR].ob_y;
	}
	s->ob[SL_UP].ob_x = s->ob[SL_UP].ob_y = 0;
	s->ob[SL_DOWN].ob_x = s->ob[ROOT].ob_width - s->ob[SL_DOWN].ob_width;
	s->ob[SL_DOWN].ob_y = s->ob[ROOT].ob_height - s->ob[SL_DOWN].ob_height;
	SlidSlidSize(s, s->size);
}

/*** ---------------------------------------------------------------------- ***/

long SlidClick(SLIDERSPEC *s, int x, int y, int clicks, int realtime)
{
	int w;
	int obj;
	OBJECT *tree;
	long pos;
	
	if (s->hori)
		w = s->ob[SL_BAR].ob_width - s->ob[SL_ELEV].ob_width;
	else
		w = s->ob[SL_BAR].ob_height - s->ob[SL_ELEV].ob_height;
	obj = objc_find(s->ob, ROOT, 2, x, y);
	if (obj == -1)
		return -1;
	switch (obj)
	{
	case SL_UP:
		if (realtime)
		{
			tree = s->ob;
			objc_change(tree, SL_UP, 0, tree[ROOT].ob_x, tree[ROOT].ob_y, tree[ROOT].ob_width, tree[ROOT].ob_height, SELECTED, TRUE);
		}
		pos = s->position - s->accel;
		if (clicks > 1)
			pos = 0;
		break;

	case SL_DOWN:
		if (realtime)
		{
			tree = s->ob;
			objc_change(tree, SL_DOWN, 0, tree[ROOT].ob_x, tree[ROOT].ob_y, tree[ROOT].ob_width, tree[ROOT].ob_height, SELECTED, TRUE);
		}
		pos = s->position + s->accel;
		if (clicks > 1)
			pos = s->scale;
		break;

	case SL_BAR:
		{
			int sx, sy;
			
			ObjcOffset(s->ob, SL_ELEV, &sx, &sy);
			if (sx > x || y < sy)
				pos = s->position - s->size;
			else
				pos = s->size + s->position;
		}
		break;

	case SL_ELEV:
		{
			int slpos;
			long lpos;
			
			if (clicks == 2 || (realtime && s->scale < w * s->accel))
				return -2;
			WindUpdate(BEG_MCTRL);
			slpos = graf_slidebox(s->ob, SL_BAR, SL_ELEV, 1 - s->hori);
			WindUpdate(END_MCTRL);
			lpos = s->scale * slpos;
			pos = (int)(lpos / 1000);
			if ((lpos % 1000) >= 500)
				pos++;
		}
		break;
	}
	if (pos > s->scale)
		pos = s->scale;
	else if (pos < 0)
		pos = 0;
	return pos;
}

/*** ---------------------------------------------------------------------- ***/

long SlidAdjustSlider(SLIDERSPEC *s, int x, int y)
{
	int bx, by;
	int sx, sy;
	
	ObjcOffset(s->ob, SL_BAR, &bx, &by);
	ObjcOffset(s->ob, SL_ELEV, &sx, &sy);
	if (!s->hori)
	{
		int w;

		y -= s->ob[SL_ELEV].ob_height >> 1;
		if (by >= y)
			return 0;
		if (by + s->ob[SL_BAR].ob_height <= y)
			return s->scale;
		y -= by;
		w = s->ob[SL_BAR].ob_height - s->ob[SL_ELEV].ob_height;
		if (w != 0)
			return (y * s->scale) / w;
	} else
	{
		int w;

		x -= s->ob[SL_ELEV].ob_width >> 1;
		if (bx >= x)
			return 0;
		if (bx + s->ob[SL_BAR].ob_width <= x)
			return s->scale;
		x -= bx;
		w = s->ob[SL_BAR].ob_width - s->ob[SL_ELEV].ob_width;
		if (w != 0)
			return (x * s->scale) / w;
	}
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

void SlidDeselect(SLIDERSPEC *s)
{
	OBJECT *tree;
	
	tree = s->ob;
	if (tree[SL_UP].ob_state & SELECTED)
		objc_change(tree, SL_UP, 0, tree[ROOT].ob_x, tree[ROOT].ob_y, tree[ROOT].ob_width, tree[ROOT].ob_height, NORMAL, TRUE);
	if (tree[SL_DOWN].ob_state & SELECTED)
		objc_change(s->ob, SL_DOWN, 0, tree[ROOT].ob_x, tree[ROOT].ob_y, tree[ROOT].ob_width, tree[ROOT].ob_height, NORMAL, TRUE);
}
