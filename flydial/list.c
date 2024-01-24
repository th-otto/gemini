/*
	@(#)FlyDial/list.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include "listman.h"
#include <string.h>
#include <stdlib.h>

#ifndef SuperToUser
#define SuperToUser(s) Super(s)
#endif

#undef min
#undef max
#define min(a, b) (((a) > (b)) ? (b) : (a))
#define max(a, b) (((a) < (b)) ? (b) : (a))

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ListVPos(LISTINFO *l, long pos)
{
	if (l->windhandle < 0)
	{
		SlidPos(l->lslid, pos);
	} else if (l->lslid->scale == 0)
	{
		wind_set(l->windhandle, WF_VSLIDE, 1);
	} else
	{
		wind_set(l->windhandle, WF_VSLIDE, (int)((pos * 1000) / l->lslid->scale));
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ListHPos(LISTINFO *l, long pos)
{
	if (l->windhandle < 0)
	{
		SlidPos(l->mslid, pos);
	} else if (l->mslid->scale == 0)
	{
		wind_set(l->windhandle, WF_HSLIDE, 1);
	} else
	{
		wind_set(l->windhandle, WF_HSLIDE, (int)((pos * 1000) / l->mslid->scale));
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ListVSize(LISTINFO *l, int size)
{
	if (l->windhandle < 0)
	{
		SlidSlidSize(l->lslid, size);
	} else if (size == -1)
	{
		wind_set(l->windhandle, WF_VSLSIZE, size);
	} else
	{
		wind_set(l->windhandle, WF_VSLSIZE, (int)((size * 1000L) / l->listlength));
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ListHSize(LISTINFO *l, int size)
{
	if (l->windhandle < 0)
	{
		SlidSlidSize(l->mslid, size);
	} else if (size == -1)
	{
		wind_set(l->windhandle, WF_HSLSIZE, size);
	} else
	{
		wind_set(l->windhandle, WF_HSLSIZE, (int)((size * 1000L) / l->maxwidth));
	}
}

/*** ---------------------------------------------------------------------- ***/

/* unused */
static void ListInvert(const GRECT *clip)
{
	int pxy[4];
	GRECT screen;
	GRECT gr;
	
	HandScreenSize(&screen.g_x, &screen.g_y, &screen.g_w, &screen.g_h);
	if (RectGInter(clip, &screen, &gr))
	{
		RectGRECT2VDI(&gr, pxy);
		vsf_color(DialWk, BLACK);
		vswr_mode(DialWk, MD_XOR);
		vr_recfl(DialWk, pxy);
	}
}

/*** ---------------------------------------------------------------------- ***/

static int ListVisible(LISTINFO *l, long idx)
{
	return idx >= l->startindex && idx < l->lines + l->startindex;
}

/*** ---------------------------------------------------------------------- ***/

static int x_410(long a, long b, long c)
{
	if (a > b)
		return a >= c && c >= b;
	else
		return b >= c && c >= a;
}

/*** ---------------------------------------------------------------------- ***/

static long ListLength(LISTSPEC *list)
{
	long count = 0;
	
	while (list != NULL)
	{
		count++;
		list = list->next;
	}
	return count;
}

/*** ---------------------------------------------------------------------- ***/

LISTSPEC *ListIndex2List(LISTSPEC *list, long index)
{
	while (index != 0)
	{
		index--;
		list = list->next;
	}
	return list;
}

/*** ---------------------------------------------------------------------- ***/

static int ListLines(LISTINFO *l)
{
	int ret;
	
	ret = 1;
	if (l->boxtree != NULL)
	{
		ObjcOffset(l->boxtree, l->boxindex, &l->area.g_x, &l->area.g_y);
		l->area.g_w = l->boxtree[l->boxindex].ob_width;
		l->area.g_h = l->boxtree[l->boxindex].ob_height;
	}
	if (l->voffset != 0)
	{
		ret = l->area.g_h / l->voffset;
		if ((l->area.g_h % l->voffset) != 0)
			ret++;
	} else
	{
		ret = l->area.g_w / l->hoffset;
		if ((l->area.g_w % l->hoffset) != 0)
			ret++;
	}
	return ret;
}

/*** ---------------------------------------------------------------------- ***/

int ListInit(LISTINFO *l)
{
	int obj;
	int next;
	
	if (l->boxtree != NULL)
	{
		obj = l->boxtree[l->boxindex].ob_head;
		if (obj >= 0)
		{
			l->hoffset = l->hsize = l->boxtree[obj].ob_width;
			l->voffset = l->vsize = l->boxtree[obj].ob_height;
		}
		obj = l->boxtree[l->boxindex].ob_head;
		if (obj >= 0)
		{
			if ((next = l->boxtree[obj].ob_next) >= 0)
			{
				l->hoffset = abs(l->boxtree[next].ob_x - l->boxtree[obj].ob_x);
				l->voffset = abs(l->boxtree[next].ob_y - l->boxtree[obj].ob_y);
			}
		}
	}
	l->listlength = ListLength(l->list);
	l->lines = ListLines(l);
	l->lines = l->lines > l->listlength ? (int)l->listlength : l->lines;
	if (l->lines + l->startindex > l->listlength)
		l->startindex = l->listlength - l->lines;
	l->lslid = SlidCreate(NULL, FALSE, 1);
	if (l->lslid == NULL)
		return FALSE;
	if (l->lslidx <= 0)
		l->lslidx = l->area.g_x + l->area.g_w;
	if (l->lslidy <= 0)
		l->lslidy = l->area.g_y;
	if (l->lslidlen <= 0)
		l->lslidlen = l->area.g_h;
	l->lslidx += 1;
	SlidExtents(l->lslid, l->lslidx, l->lslidy, l->lslidlen);
	SlidScale(l->lslid, l->listlength - l->lines);
	ListVSize(l, l->lines);
	ListVPos(l, l->startindex);

	if (l->maxwidth > 0)
	{
		l->mslid = SlidCreate(NULL, TRUE, l->hstep);
		if (l->mslid == NULL)
		{
			SlidDelete(l->lslid);
			return FALSE;
		}
		if (l->mslidx <= 0)
			l->mslidx = l->area.g_x;
		if (l->mslidy <= 0)
			l->mslidy = l->area.g_y + l->area.g_h;
		if (l->mslidlen <= 0)
			l->mslidlen = l->area.g_w;
		l->mslidy += 1;
		if (l->hpos + l->area.g_w > l->maxwidth)
			l->hpos = l->maxwidth - l->area.g_w;
		SlidExtents(l->mslid, l->mslidx, l->mslidy, l->mslidlen);
		SlidScale(l->mslid, l->maxwidth - l->mslidlen);
		ListHSize(l, l->mslidlen);
		ListHPos(l, l->hpos);
	} else
	{
		l->mslid = NULL;
	}
	
	if (l->boxtree != NULL)
	{
		l->boxtree[l->boxbgindex].ob_width = l->boxtree[l->boxindex].ob_width;
		l->boxtree[l->boxbgindex].ob_height = l->boxtree[l->boxindex].ob_height;
		if (l->lslid != NULL)
			l->boxtree[l->boxbgindex].ob_width += HandBXSize - 1;
		if (l->mslid != NULL)
			l->boxtree[l->boxbgindex].ob_height += HandBYSize - 1;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void ListDrawList(LISTINFO *l, const GRECT *clip)
{
	GRECT draw;
	GRECT area;
	GRECT gr;
	LISTSPEC *list;
	int i;
	
	area = l->area;
	if (RectGInter(clip, &area, &draw))
	{
		if (l->boxtree != NULL)
			objc_draw(l->boxtree, l->boxindex, 0, draw.g_x, draw.g_y, draw.g_w, draw.g_h);
		else
			l->drawfunc(NULL, area.g_x, area.g_y, l->hpos, &draw, 0);
	}
	area = l->area;
	area.g_w = l->hsize;
	area.g_h = l->vsize;
	list = ListIndex2List(l->list, l->startindex);
	for (i = 0; i < l->lines; i++)
	{
		if (RectGInter(&draw, &area, &gr))
		{
			l->drawfunc(list, area.g_x, area.g_y, l->hpos, &gr, 1);
		}
		area.g_x += l->hoffset;
		area.g_y += l->voffset;
		list = list->next;
	}
}

/*** ---------------------------------------------------------------------- ***/

void ListWindDraw(LISTINFO *l, const GRECT *clip, int fullredraw)
{
	int x, y, w, h;
	GRECT gr;
	
	GrafMouse(M_OFF, NULL);
	if (l->windhandle < 0)
	{
		ListDrawList(l, clip);
		SlidDraw(l->lslid, 0, 0, 32767, 32767, fullredraw);
		SlidDrCompleted(l->lslid);
		if (l->mslid != NULL)
		{
			SlidDraw(l->mslid, 0, 0, 32767, 32767, fullredraw);
			SlidDrCompleted(l->mslid);
		}
	} else
	{
		WindUpdate(BEG_UPDATE);
		wind_get(l->windhandle, WF_FIRSTXYWH, &x, &y, &w, &h);
		while (w != 0 && h != 0)
		{
			if (RectInter(clip->g_x, clip->g_y, clip->g_w, clip->g_h, x, y, w, h, &gr.g_x, &gr.g_y, &gr.g_w, &gr.g_h))
				ListDrawList(l, &gr);
			wind_get(l->windhandle, WF_NEXTXYWH, &x, &y, &w, &h);
		}
		WindUpdate(END_UPDATE);
	}
	GrafMouse(M_ON, NULL);
}

/*** ---------------------------------------------------------------------- ***/

void ListDraw(LISTINFO *l)
{
	GRECT gr;
	int x, y, w, h;
	GRECT area;
	GRECT screen;

	GrafMouse(M_OFF, NULL);
	HandScreenSize(&screen.g_x, &screen.g_y, &screen.g_w, &screen.g_h);
	area = l->area;
	if (l->windhandle < 0)
	{
		SlidDraw(l->lslid, screen.g_x, screen.g_y, screen.g_w, screen.g_h, TRUE);
		if (l->mslid != NULL)
			SlidDraw(l->mslid, screen.g_x, screen.g_y, screen.g_w, screen.g_h, TRUE);
		ListDrawList(l, &area);
	} else
	{
		WindUpdate(BEG_UPDATE);
		wind_get(l->windhandle, WF_FIRSTXYWH, &x, &y, &w, &h);
		while (w != 0 && h != 0)
		{
			if (RectInter(area.g_x, area.g_y, area.g_w, area.g_h, x, y, w, h, &gr.g_x, &gr.g_y, &gr.g_w, &gr.g_h))
				ListDrawList(l, &gr);
			wind_get(l->windhandle, WF_NEXTXYWH, &x, &y, &w, &h);
		}
		WindUpdate(END_UPDATE);
	}
	
	GrafMouse(M_ON, NULL);
}

/*** ---------------------------------------------------------------------- ***/

static void ListScroll(LISTINFO *l, int sx, int sy, int sw, int sh, int dx, int dy)
{
	MFDB fdb;
	
	fdb.fd_addr = NULL;
	if (l->windhandle < 0)
	{
		RastBufCopy(sx, sy, sw, sh, dx, dy, &fdb);
	} else
	{
		int rx, ry, rw, rh;
		GRECT gr;
		int x, y, w, h;
		int gx, gy, gw, gh;
		int d5, d6, d3, d7;
		
		WindUpdate(BEG_UPDATE);
		wind_get(l->windhandle, WF_FIRSTXYWH, &x, &y, &w, &h);
		while (w != 0 && h != 0)
		{
			if (RectInter(dx, dy, sw, sh, x, y, w, h, &gx, &gy, &gw, &gh))
			{
				d5 = gx - dx + sx;
				d6 = gy - dy + sy;
				d3 = gw;
				d7 = gh;
				if (RectInter(d5, d6, d3, d7, x, y, w, h, &rx, &ry, &rw, &rh))
				{
					int d7 = rx - d5 + gx;
					int d3 = ry - d6 + gy;
					int d0 = FALSE;
					gr.g_x = gx;
					gr.g_y = gy;
					gr.g_w = gr.g_h = 0;
					if (gw > rw)
					{
						d0 = gh > rh;
						gr.g_w = gw - rw;
						gr.g_h = gh;
						if (gx == d7)
							gr.g_x += rw;
					} else if (gh > rh)
					{
						gr.g_h = gh - rh;
						gr.g_w = gw;
						if (gy == d3)
							gr.g_y += rh;
					}
					if (!d0)
					{
						RastBufCopy(rx, ry, rw, rh, d7, d3, &fdb);
					} else
					{
						gr.g_x = gx;
						gr.g_y = gy;
						gr.g_w = gw;
						gr.g_h = gh;
					}
				} else
				{
					gr.g_x = gx;
					gr.g_y = gy;
					gr.g_w = gw;
					gr.g_h = gh;
				}
				if (gr.g_w > 0 && gr.g_h > 0)
					ListDrawList(l, &gr);
			}
			wind_get(l->windhandle, WF_NEXTXYWH, &x, &y, &w, &h);
		}		
		WindUpdate(END_UPDATE);
	}
}

/*** ---------------------------------------------------------------------- ***/

void ListVScroll(LISTINFO *l, long lines)
{
	long startindex;
	GRECT area;
	GRECT gr;
	int offset;
	long s;
	
	ListMoved(l);
	startindex = l->startindex + lines;
	if (l->lines + startindex > l->listlength)
		startindex = l->listlength - l->lines;
	if (startindex < 0)
		startindex = 0;
	if (startindex != l->startindex)
	{
		offset = (int)(l->startindex - startindex);
		lines = labs(l->startindex - startindex);
		l->startindex = startindex;
		ListVPos(l, startindex);
		s = l->lines - labs(lines);
		area = l->area;
		RectClipWithScreen(&area);
		gr = area;
		v_hide_c(HandAES);
		if (s > 0)
		{
			int sh;

			area.g_h = (int)s * l->voffset;
			area.g_h -= l->lines * l->voffset - l->area.g_h;
			gr.g_h = area.g_h;
			if (offset < 0)
				area.g_y += (int)lines * l->voffset;
			else
				gr.g_y += (int)lines * l->voffset;
			RectClipWithScreen(&area);
			sh = area.g_h;
			ListScroll(l, area.g_x, area.g_y, area.g_w, sh, gr.g_x, gr.g_y);
			area = l->area;
			area.g_h = l->area.g_h - gr.g_h;
			if (offset < 0)
				area.g_y += sh;
		}
		ListWindDraw(l, &area, FALSE);
		v_show_c(HandAES, 1); /* BUG: do not reset */
	}
}

/*** ---------------------------------------------------------------------- ***/

void ListHScroll(LISTINFO *l, int columns)
{
	int startindex;
	GRECT area;
	GRECT gr;
	int offset;
	int s;
	
	ListMoved(l);
	startindex = l->hpos + columns;
	if (startindex + l->area.g_w > l->maxwidth)
		startindex = l->maxwidth - l->area.g_w;
	if (startindex < 0)
		startindex = 0;
	if (startindex != l->hpos)
	{
		offset = (int)(l->hpos - startindex);
		columns = abs(l->hpos - startindex);
		l->hpos = startindex;
		ListHPos(l, startindex);
		s = l->area.g_w - abs(columns);
		area = l->area;
		RectClipWithScreen(&area);
		gr = area;
		v_hide_c(HandAES);
		if (s > 0)
		{
			area.g_w = s;
			gr.g_w = s;
			if (offset < 0)
				area.g_x += columns;
			else
				gr.g_x += columns;
			RectClipWithScreen(&area);
			RectClipWithScreen(&gr);
			area.g_w = area.g_w > gr.g_w ? gr.g_w : area.g_w;
			s = area.g_w;
			ListScroll(l, area.g_x, area.g_y, area.g_w, area.g_h, gr.g_x, gr.g_y);
			area = l->area;
			area.g_w = columns;
			if (offset < 0)
				area.g_x += s;
		}
		ListWindDraw(l, &area, FALSE);
		v_show_c(HandAES, 1); /* BUG: do not reset */
	}
}

/*** ---------------------------------------------------------------------- ***/

static void RedrawEntry(LISTINFO *l, LISTSPEC *list, long entry)
{
	int idx;
	GRECT area;
	GRECT gr;
	
	idx = (int)(entry - l->startindex);
	area = l->area;
	area.g_x += idx * l->hoffset; /* BUG */
	area.g_y += idx * l->voffset;
	area.g_w = l->hsize;
	area.g_h = l->vsize;
	gr = area;
	if (RectGInter(&gr, &l->area, &area))
	{
		v_hide_c(HandAES);
		if (l->windhandle < 0)
		{
			l->drawfunc(list, gr.g_x, gr.g_y, l->hpos, &area, 0);
		} else
		{
			int x, y, w, h;
			GRECT draw;
			
			WindUpdate(BEG_UPDATE);
			wind_get(l->windhandle, WF_FIRSTXYWH, &x, &y, &w, &h);
			while (w != 0 && h != 0)
			{
				if (RectInter(area.g_x, area.g_y, area.g_w, area.g_h, x, y, w, h, &draw.g_x, &draw.g_y, &draw.g_w, &draw.g_h))
				{
					l->drawfunc(list, gr.g_x, gr.g_y, l->hpos, &draw, 0);
				}
				wind_get(l->windhandle, WF_NEXTXYWH, &x, &y, &w, &h);
			}
			WindUpdate(END_UPDATE);
		}
		v_show_c(HandAES, 1); /* BUG: do not reset */
	}
}

/*** ---------------------------------------------------------------------- ***/

static void RedrawLine(LISTINFO *l, int idx)
{
	GRECT area;
	GRECT gr;
	
	v_hide_c(HandAES);
	area = l->area;
	area.g_x += idx * l->hoffset; /* BUG */
	area.g_y += idx * l->voffset;
	area.g_w = l->hsize;
	area.g_h = l->vsize;
	gr = area;
	if (RectGInter(&gr, &l->area, &area))
	{
		if (l->windhandle < 0)
		{
			ListDrawList(l, &area);
		} else
		{
			int x, y, w, h;
			GRECT draw;
			
			WindUpdate(BEG_UPDATE);
			wind_get(l->windhandle, WF_FIRSTXYWH, &x, &y, &w, &h);
			while (w != 0 && h != 0)
			{
				if (RectInter(area.g_x, area.g_y, area.g_w, area.g_h, x, y, w, h, &draw.g_x, &draw.g_y, &draw.g_w, &draw.g_h))
				{
					ListDrawList(l, &draw);
				}
				wind_get(l->windhandle, WF_NEXTXYWH, &x, &y, &w, &h);
			}
			WindUpdate(END_UPDATE);
		}
	}
	v_show_c(HandAES, 1); /* BUG: do not reset */
}

/*** ---------------------------------------------------------------------- ***/

void ListUpdateEntry(LISTINFO *l, long entry)
{
	ListMoved(l);
	if (ListVisible(l, entry))
	{
		RedrawLine(l, (int)(entry - l->startindex));
	}
}

/*** ---------------------------------------------------------------------- ***/

void ListInvertEntry(LISTINFO *l, long entry)
{
	ListMoved(l);
	if (ListVisible(l, entry))
	{
		RedrawEntry(l, ListIndex2List(l->list, entry), entry);
	}
}

/*** ---------------------------------------------------------------------- ***/

#define _HZ_200 ((volatile long *)0x4baL)

static void click_delay(LISTINFO *l, long starttime)
{
	long oldsp;
	long t;
	
	/* FIXME: dont use busy loop, or hz_200 */
	oldsp = Super(0);
	do
	{
		t = *_HZ_200 - starttime;
	} while ((75 / l->lines) > t);
	SuperToUser((void *) oldsp);
}

/*** ---------------------------------------------------------------------- ***/

static long get_hz200(void)
{
	long oldsp;
	long t;
	
	oldsp = Super(0);
	t = *_HZ_200;
	SuperToUser((void *) oldsp);
	return t;
}

/*** ---------------------------------------------------------------------- ***/

int ListMoved(LISTINFO *l)
{
	int x, y;
	int dx, dy;
	
	if (l->boxtree == NULL)
		return FALSE;
	ObjcOffset(l->boxtree, l->boxindex, &x, &y);
	if (l->area.g_x != x || l->area.g_y != y)
	{
		dx = x - l->area.g_x;
		dy = y - l->area.g_y;
		l->area.g_x += dx;
		l->area.g_y += dy;
		l->lslidx += dx;
		l->lslidy += dy;
		l->lslid->drawn = FALSE;
		SlidExtents(l->lslid, l->lslidx, l->lslidy, l->lslidlen);
		SlidScale(l->lslid, l->listlength - l->lines);
		ListVSize(l, l->lines);
		ListVPos(l, l->startindex);
		if (l->mslid != NULL)
		{
			l->mslidx += dx;
			l->mslidy += dy;
			l->mslid->drawn = FALSE;
			SlidExtents(l->mslid, l->mslidx, l->mslidy, l->mslidlen);
			SlidScale(l->mslid, l->maxwidth - l->mslidlen);
			ListHSize(l, l->mslidlen);
			ListHPos(l, l->hpos);
		}
		return TRUE;
	}
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * XXX
 * d7 -> d6
 * d6 -> d7
 *
 * d3 -> d4
 * d5 -> d3
 * d4 -> d5
 */
long ListClick(LISTINFO *l, int clicks)
{
	long pos;
	long line;
	int notfirst;
	int mox;
	int moy;
	int kstate;
	int mstate;
	LISTSPEC *current;
	int x, y;
	long firstsel, lastsel, maxsel, minsel;
	int i;

	notfirst = FALSE;
	ListMoved(l);
	graf_mkstate(&mox, &moy, &mstate, &kstate);
	if (l->lslid != NULL)
	{
		pos = SlidClick(l->lslid, mox, moy, clicks, l->windhandle < 0);
		if (pos == -2)
		{
			MFORM form;
			int formnum;

			GrafGetForm(&formnum, &form);
			GrafMouse(FLAT_HAND, NULL);
			do
			{
				pos = SlidAdjustSlider(l->lslid, mox, moy) - l->startindex;
				ListVScroll(l, pos);
				graf_mkstate(&mox, &moy, &mstate, &kstate);
			} while (mstate != 0);
			GrafMouse(formnum, &form);
			return -1;
		}
		if (pos != -1)
		{
			pos -= l->startindex;
			do
			{
				int dummy;
				long starttime;

				starttime = get_hz200();
				ListVScroll(l, pos);
				if (!(mstate & 2))
					click_delay(l, starttime);
				graf_mkstate(&dummy, &dummy, &mstate, &dummy);
			} while (mstate != 0);
			SlidDeselect(l->lslid);
			return -1;
		}
	}

	if (l->mslid != NULL)
	{
		pos = SlidClick(l->mslid, mox, moy, clicks, l->windhandle < 0);
		if (pos == -2)
		{
			MFORM form;
			int formnum;

			GrafGetForm(&formnum, &form);
			GrafMouse(FLAT_HAND, NULL);
			do
			{
				pos = SlidAdjustSlider(l->mslid, mox, moy);
				pos -= l->hpos;
				ListHScroll(l, (int)pos);
				graf_mkstate(&mox, &moy, &mstate, &kstate);
			} while (mstate != 0);
			GrafMouse(formnum, &form);
			return -1;
		}
		if (pos != -1)
		{
			pos -= l->hpos;
			do
			{
				int dummy;
				long starttime;

				starttime = get_hz200();
				ListHScroll(l, (int)pos);
				if (!(mstate & 2))
					click_delay(l, starttime);
				graf_mkstate(&dummy, &dummy, &mstate, &dummy);
			} while (mstate != 0);
			SlidDeselect(l->mslid);
			return -1;
		}
	}
	
	if (!RectInside(l->area.g_x, l->area.g_y, l->area.g_w, l->area.g_h, mox, moy))
		return -1;
	if (l->selectionservice == 0)
		return -1;
	
	do
	{
		long starttime;

		line = (moy - l->area.g_y) / l->voffset;
		starttime = get_hz200();
		if (notfirst)
		{
			if (line >= l->lines)
			{
				line = l->lines - 1;
				if (!(mstate & 2))
					click_delay(l, starttime);
				ListVScroll(l, 1);
				starttime = get_hz200(); /* FIXME: unused */
			} else if (moy < l->area.g_y)
			{
				line = 0;
				if (!(mstate & 2))
					click_delay(l, starttime);
				ListVScroll(l, -1);
				starttime = get_hz200(); /* FIXME: unused */
			}
		}
		
		line += l->startindex;
		if (line < 0 || line >= l->listlength)
			return -1;
		current = ListIndex2List(l->list, line);
		if ((kstate & (K_LSHIFT | K_RSHIFT)) == 0 || l->selectionservice == 1)
		{
			LISTSPEC *list;
			
			for (i = 0, list = l->list; list != NULL; i++, list = list->next)
			{
				if (list->flags.selected && list != current)
				{
					list->flags.selected = FALSE;
					if (ListVisible(l, i))
						RedrawEntry(l, list, i);
				}
			}
		}
		
		if ((kstate & (K_LSHIFT | K_RSHIFT)) != 0)
		{
			current->flags.selected ^= TRUE; /* FIXME: using bitfield here produces inefficient code */
			RedrawEntry(l, current, line);
		} else if (!current->flags.selected)
		{
			current->flags.selected = TRUE;
			RedrawEntry(l, current, line);
		}
		
		{
			x = (int)(line - l->startindex) * l->hoffset + l->area.g_x;
			y = (int)(line - l->startindex) * l->voffset + l->area.g_y;
			do
			{
				graf_mkstate(&mox, &moy, &mstate, &kstate);
			} while (mstate != 0 && RectInside(x, y, l->hsize, l->vsize, mox, moy));
		}
		notfirst = TRUE;
	} while (mstate != 0 && l->selectionservice == 1);
	
	if (l->selectionservice < 2)
		return line;

	{
		int selected;
		LISTSPEC *list;
		
		lastsel = firstsel = line;
		
		while (mstate != 0)
		{
			graf_mkstate(&mox, &moy, &mstate, &kstate);
			if (l->hoffset != 0)
			{
				if (mox < l->area.g_x)
					line = -1;
				else
					line = (int)(mox - l->area.g_x) / l->hoffset;
			} else
			{
				if (moy < l->area.g_y)
					line = -1;
				else
					line = (int)(moy - l->area.g_y) / l->voffset;
			}
			line += l->startindex;
			if (line < l->startindex)
			{
				ListVScroll(l, -1);
				line = l->startindex;
			} else if (line >= l->lines + l->startindex)
			{
				ListVScroll(l, 1);
				line = l->lines + l->startindex - 1;
			}
			if (min(lastsel, firstsel) < line)
				minsel = min(lastsel, firstsel);
			else
				minsel = line;
			if (max(lastsel, firstsel) > line)
				maxsel = max(lastsel, firstsel);
			else
				maxsel = line;
			for (list = ListIndex2List(l->list, minsel); minsel <= maxsel; list = list->next, minsel++)
			{
				selected = list->flags.selected;
				if (x_410(lastsel, firstsel, minsel))
					list->flags.selected ^= TRUE; /* FIXME: using bitfield here produces inefficient code */
				if (x_410(line, firstsel, minsel))
					list->flags.selected ^= TRUE; /* FIXME: using bitfield here produces inefficient code */
				if (list->flags.selected != selected && ListVisible(l, minsel))
					RedrawEntry(l, list, minsel);
			}
			lastsel = line;
		}
	}
	
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

void ListExit(LISTINFO *l)
{
	if (l->lslid)
	{
		SlidDelete(l->lslid);
		l->lslid = NULL;
	}
	if (l->mslid)
	{
		SlidDelete(l->mslid);
		l->mslid = NULL;
	}
	l->lslidx = l->lslidy = l->lslidlen = 0;
	l->mslidx = l->mslidy = l->mslidlen = 0;
}

/*** ---------------------------------------------------------------------- ***/

void ListStdInit(LISTINFO *l, OBJECT *tree, int box1, int box2, 
	void (*drawfunc)(LISTSPEC *l, int x, int y, int offset, GRECT *cliprect, int how),
	LISTSPEC *list, int maxwidth, long startindex,
	int selectionservice)
{
	l->boxtree = tree;
	l->boxindex = box1;
	l->boxbgindex = box2;
	l->drawfunc = drawfunc;
	l->windhandle = -1;
	l->list = list;
	l->maxwidth = maxwidth;
	l->startindex = startindex;
	l->selectionservice = selectionservice;
	l->lslidx = l->lslidy = l->lslidlen = 0;
	l->mslidx = l->mslidy = l->mslidlen = l->hpos = 0;
}

/*** ---------------------------------------------------------------------- ***/

void ListScroll2Selection(LISTINFO *l)
{
	int line;
	int firstsel;
	LISTSPEC *list;
	
	line = 0;
	firstsel = -1;
	if (l->listlength > l->lines)
	{
		for (list = l->list; list != NULL && firstsel == -1; list = list->next, line++)
			if (list->flags.selected)
				firstsel = line;
		if (line != -1) /* BUG: should be firstsel */
		{
			if (firstsel < l->startindex || firstsel >= l->lines + l->startindex)
			{
				l->startindex = firstsel;
				if (firstsel + l->lines > l->listlength)
					l->startindex = l->listlength - l->lines;
				ListVPos(l, l->startindex);
			}
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

void ListPgDown(LISTINFO *l)
{
	ListVScroll(l, l->lines);
}

/*** ---------------------------------------------------------------------- ***/

void ListPgUp(LISTINFO *l)
{
	ListVScroll(l, -l->lines);
}

/*** ---------------------------------------------------------------------- ***/

void ListPgRight(LISTINFO *l)
{
	ListHScroll(l, l->area.g_w);
}

/*** ---------------------------------------------------------------------- ***/

void ListPgLeft(LISTINFO *l)
{
	ListHScroll(l, -l->area.g_w);
}

/*** ---------------------------------------------------------------------- ***/

void ListLnRight(LISTINFO *l)
{
	ListHScroll(l, l->hstep);
}

/*** ---------------------------------------------------------------------- ***/

void ListLnLeft(LISTINFO *l)
{
	ListHScroll(l, -l->hstep);
}

/*** ---------------------------------------------------------------------- ***/

void ListVSlide(LISTINFO *l, int pos)
{
	long line;
	
	line = (pos * l->lslid->scale);
	line /= 1000;
	ListVScroll(l, line - l->startindex);
}

/*** ---------------------------------------------------------------------- ***/

void ListHSlide(LISTINFO *l, int pos)
{
	long line;
	
	line = (pos * l->mslid->scale);
	line /= 1000;
	ListHScroll(l, (int)(line - l->hpos));
}
