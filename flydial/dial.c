/*
	@(#)FlyDial/dial.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include <string.h>

int DialWk = 0;

DIALMALLOC dialmalloc;
DIALFREE dialfree;
static int workout[57];
static int workin[11] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 };

typedef struct
{
  long cookie;   /* Must be 'VSCR'                     */
  long product;  /* Same as XBRA ID of emulator        */
  short version;  /* Version of the VSCR protocol       */
  short x,y,w,h;  /* Visible segment of virtual screen  */
} INFOVSCR;

static INFOVSCR vscr_flydial = {
	0x56534352L, /* 'VSCR' */
	FLYDIALMAGIC, /* 'FLYD' */
	0x100,
	0, 319, 640, 320
};

#ifndef SuperToUser
#define SuperToUser(s) Super(s)
#endif

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int get_cookie(long id, long *value)
{
	long oldsp;
	long *jar;
	
	oldsp = Super(0);
	jar = *((long **)0x5a0);
	SuperToUser((void *)oldsp);
	if (jar != NULL)
	{
		do
		{
			if (*jar == id)
			{
				if (value != NULL)
					*value = jar[1];
				return TRUE;
			}
			jar += 2;
		} while (*jar != 0);
	}
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

static int find_mover(OBJECT *tree)
{
	int obj;
	
	obj = 0;
	for (;;)
	{
		if ((tree[obj].ob_type & 0xff00) == (17 << 8) &&
			(tree[obj].ob_state & (OUTLINED | CROSSED)) == (OUTLINED | CROSSED))
		{
			return obj;
		}
		if (tree[obj].ob_flags & LASTOB)
			return -1;
		obj++;
	}
}

/*** ---------------------------------------------------------------------- ***/

static void unhide_mover(OBJECT *tree)
{
	int obj;
	
	obj = find_mover(tree);
	if (obj != -1)
		tree[obj].ob_flags &= ~HIDETREE;
}

/*** ---------------------------------------------------------------------- ***/

static void hide_mover(OBJECT *tree)
{
	int obj;
	
	obj = find_mover(tree);
	if (obj != -1)
		tree[obj].ob_flags |= HIDETREE;
}

/*** ---------------------------------------------------------------------- ***/

int DialExStart(OBJECT *tree, DIALINFO *d, int use_qsb)
{
	int type;
	unsigned long memsize;
	void *addr;
	
	(void)use_qsb;
	d->Tree = tree;
	d->offset = 0;
	d->x = tree[ROOT].ob_x;
	d->y = tree[ROOT].ob_y;
	d->w = tree[ROOT].ob_width;
	d->h = tree[ROOT].ob_height;
	type = tree[ROOT].ob_type & 0xff;
	if (tree[ROOT].ob_state & OUTLINED)
		d->offset = 3;
	if (tree[ROOT].ob_state & SHADOWED)
	{
		d->h += 2;
		d->w += 2;
	}
	if (type == G_BOX || type == G_IBOX)
	{
		int framesize = tree[ROOT].ob_spec.obspec.framesize;
		if (framesize < 0)
			d->offset -= framesize;
	}
	d->x -= d->offset;
	d->y -= d->offset;
	d->offset <<= 1;
	d->w += d->offset;
	d->h += d->offset;
	d->offset >>= 1;
	memsize = RastSize(d->w, d->h, &d->Buffer);
	addr = NULL;
	d->Buffer.fd_addr = addr;
	if (RectOnScreen(d->x, d->y, d->w, d->h))
		d->Buffer.fd_addr = addr = dialmalloc(memsize);
	if (addr == NULL)
	{
		hide_mover(tree);
		form_dial(FMD_START, d->x, d->y, d->w, d->h, d->x, d->y, d->w, d->h);
		return FALSE;
	} else
	{
		unhide_mover(tree);
		GrafMouse(M_OFF, NULL);
		RastSave(d->x, d->y, d->w, d->h, 0, 0, &d->Buffer);
		GrafMouse(M_ON, NULL);
		return TRUE;
	}
}

/*** ---------------------------------------------------------------------- ***/

int DialStart(OBJECT *tree, DIALINFO *d)
{
	return DialExStart(tree, d, TRUE);
}

/*** ---------------------------------------------------------------------- ***/

void DialEnd(DIALINFO *d)
{
	int pxy[4];
	
	if (d->Buffer.fd_addr == NULL)
	{
		form_dial(FMD_FINISH, d->x, d->y, d->w, d->h, d->x, d->y, d->w, d->h);
	} else
	{
		RectAES2VDI(d->x, d->y, d->w, d->h, pxy);
		GrafMouse(M_OFF, NULL);
		vs_clip(HandAES, TRUE, pxy);
		RastRestore(d->x, d->y, d->w, d->h, 0, 0, &d->Buffer);
		dialfree(d->Buffer.fd_addr);
		GrafMouse(M_ON, NULL);
	}
}

/*** ---------------------------------------------------------------------- ***/

int DialMove(DIALINFO *d, int sx, int sy, int sw, int sh)
{
	int x;
	int y;
	int w;
	int h;
	MFDB dest;
	int mstate;
	int destx;
	int desty;
	int newx;
	int newy;
	int mx;
	int my;
	MFDB *fdb;
	int x3;
	int y3;
	int w3;
	int h3;
	int oldx;
	int oldy;
	int fast;
	int handle;
	int tmp;
	int kstate;

	fdb = &d->Buffer;
	w = d->w;
	h = d->h;
	handle = HandAES;
	fast = HandFast();
	v_opnvwk(workin, &handle, workout);
	if (handle == 0)
		return FALSE;
	vswr_mode(handle, MD_XOR);
	vsl_udsty(handle, 0x5555);
	{
		int pxy[4];
		RectAES2VDI(sx, sy, sw, sh, pxy);
		vs_clip(HandAES, TRUE, pxy);
	}
	if (d->Buffer.fd_addr == NULL) /* XXX was: bhi */
	{
		v_clsvwk(handle);
		return FALSE;
	}
	dest.fd_addr = dialmalloc(RastSize(w, h, &dest));
	if (dest.fd_addr == NULL) /* XXX was: bhi */
	{
		/* BUG: workstation not closed */
		return FALSE;
	}
	GrafMouse(M_OFF, NULL);
	RastSave(d->x, d->y, w, h, 0, 0, &dest);
	if (fast == FALSE)
	{
		RastDotRect(handle, d->x, d->y, w, h);
	}
	GrafMouse(M_ON, NULL);
	graf_mkstate(&mx, &my, &mstate, &kstate);
	x = d->x;
	oldx = x;
	y = d->y;
	oldy = y;
	
	do
	{
		graf_mkstate(&newx, &newy, &mstate, &kstate);
		destx = newx + d->x - mx;
		desty = newy + d->y - my;
		if (destx < sx)
			destx = sx;
		if (desty < sy)
			desty = sy;
		if (destx + w > sx + sw)
			destx = sx + sw - w;
		if (desty + h > sy + sh)
			desty = sy + sh - h;
		if (x != destx || y != desty || mstate == 0)
		{
			GrafMouse(M_OFF, NULL);
			if (fast == FALSE && mstate != 0)
			{
				RastDotRect(handle, x, y, w, h);
				RastDotRect(handle, destx, desty, w, h);
			} else
			{
				if (fast == FALSE)
				{
					RastDotRect(handle, x, y, w, h);
					x = oldx;
					y = oldy;
				}
				if (RectInter(x, y, w, h, destx, desty, w, h, &x3, &y3, &w3, &h3) == FALSE)
				{
					RastRestore(x, y, w, h, 0, 0, fdb);
					RastSave(destx, desty, w, h, 0, 0, fdb);
				} else
				{
					if (h - h3 != 0)
					{
						tmp = h3;
						if (desty > y)
							tmp = 0;
						RastRestore(x, y + tmp, w, h - h3, 0, tmp, fdb);
					}
					if (w - w3 != 0)
					{
						tmp = w3;
						if (destx > x)
							tmp = 0;
						RastRestore(x + tmp, y3, w - w3, h3, tmp, y3 != y ? h - h3 : 0, fdb);
					}
					if (x3 != x && y3 != y)
					{
						RastBufCopy(w - w3, h - h3, w3, h3, 0, 0, fdb);
					} else if (x3 == x && y3 == y)
					{
						RastBufCopy(0, 0, w3, h3, w - w3, h - h3, fdb);
					} else if (x3 == x && y3 != y)
					{
						RastBufCopy(0, h - h3, w3, h3, w - w3, 0, fdb);
					} else
					{
						RastBufCopy(w - w3, 0, w3, h3, 0, h - h3, fdb);
					}
					if (h - h3 != 0)
					{
						if (desty > y)
						{
							RastSave(destx, y + h, w, h - h3, 0, h3, fdb);
						} else
						{
							RastSave(destx, desty, w, h - h3, 0, 0, fdb);
						}
					}
					if (w - w3 != 0)
					{
						if (destx > x)
						{
							RastSave(x + w, y3, w - w3, h3, w3, y3 != y ? 0 : h - h3, fdb);
						} else
						{
							RastSave(destx, y3, w - w3, h3, 0, y3 != y ? 0 : h - h3, fdb);
						}
					}
				}
				RastRestore(destx, desty, w, h, 0, 0, &dest);
			}
			GrafMouse(M_ON, NULL);
			x = destx;
			y = desty;
		}
	} while (mstate != 0);
	
	dialfree(dest.fd_addr);
	d->x = destx;
	d->y = desty;
	d->Tree[ROOT].ob_x = d->x + d->offset;
	d->Tree[ROOT].ob_y = d->y + d->offset;
	v_clsvwk(handle);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int DialDo(DIALINFO *d, int *StartOb)
{
	int ok;
	int done;
	MFORM mform;
	int form_number;
	int screenx;
	int screeny;
	int screenw;
	int screenh;
	int start;
	FORMKEYFUNC keybd;
	int obj;
	
	ok = TRUE;
	done = FALSE;
	start = 0;
	if (StartOb == NULL)
		StartOb = &start;
	HandScreenSize(&screenx, &screeny, &screenw, &screenh);
	WindUpdate(BEG_UPDATE);
	WindUpdate(BEG_MCTRL);
	keybd = FormGetFormKeybd();
	do
	{
		FormSetFormKeybd(keybd);
		obj = FormXDo(d->Tree, StartOb);
		if ((d->Tree[obj & 0xff].ob_type & 0xff00) == (17 << 8)) /* BUG: wrong mask for obj number */
		{
			if (ok)
			{
				GrafGetForm(&form_number, &mform);
				GrafMouse(FLAT_HAND, NULL);
				ok = DialMove(d, screenx, screeny, screenw, screenh);
				GrafMouse(form_number, &mform);
			}
		} else
		{
			done = TRUE;
		}
	} while (done == FALSE);
	WindUpdate(END_MCTRL);
	WindUpdate(END_UPDATE);
	return obj;
}

/*** ---------------------------------------------------------------------- ***/

void DialDraw(DIALINFO *d)
{
	ObjcDraw(d->Tree, ROOT, MAX_DEPTH + 4, d->x, d->y, d->w, d->h);
}

/*** ---------------------------------------------------------------------- ***/

void DialCenter(OBJECT *tree)
{
	int screenx;
	int screeny;
	int screenw;
	int screenh;
	int x3;
	int y3;
	int w3;
	int h3;
	INFOVSCR *vscrn;
	int obx;
	int obw;
	int obh;
	int dx, dy;
	
	form_center(tree, &obx, &obx, &obw, &obh);
	if (get_cookie(0x56534352L, (long *)&vscrn) && vscrn->cookie == 0x56534352L) /* 'VSCR' */
	{
		dx = (obw - tree[ROOT].ob_width) >> 1;
		dy = (obh - tree[ROOT].ob_height) >> 1;
		HandScreenSize(&screenx, &screeny, &screenw, &screenh);
		if (RectInter(screenx, screeny, screenw, screenh, vscrn->x, vscrn->y, vscrn->w, vscrn->h, &x3, &y3, &w3, &h3))
		{
			int d0 = (w3 - obw) / 2;
			int d1 = (h3 - obh) / 2;

			if (d0 >= 0)
				goto l1;
			if (x3 + d0 < screenx)
				d0 = screenx - x3;
			if (x3 + d0 + obw > screenx + screenw)
				d0 = screenx + screenw - obw - x3;
			if (x3 + d0 >= screenx)
			{
			l1:
				if (d1 >= 0)
					goto l2;
				if (y3 + d1 < screeny)
					d1 = screeny - y3;
				if (y3 + d1 + obh > screeny + screenh)
					d1 = screeny + screenh - obh - y3;
				if (y3+ d1 >= screeny)
				{
				l2:
					tree[ROOT].ob_x = x3 + d0 + dx;
					tree[ROOT].ob_y = y3 + d1 + dy;
				}
			}
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

int DialInit(void *mallocfunc, void *freefunc)
{
	int screenh;
	int screenw;
	int screeny;
	int screenx;

	dialmalloc = mallocfunc;
	dialfree = freefunc;
	if (DialWk == 0)
	{
		HandInit();
		DialWk = HandAES;
		v_opnvwk(workin, &DialWk, workout);
		vst_alignment(DialWk, 0, 5, &screenx, &screenx);
		HandScreenSize(&screenx, &screeny, &screenw, &screenh);
		if (DialWk != 0)
			HandClip(screenx, screeny, screenw, screenh, TRUE);
		ObjcInit();
	}
	return DialWk;
}

/*** ---------------------------------------------------------------------- ***/

void DialExit(void)
{
	if (DialWk != 0)
	{
		v_clsvwk(DialWk);
		DialWk = 0;
	}
}
