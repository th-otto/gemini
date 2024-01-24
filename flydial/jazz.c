/*
	@(#)FlyDial/jazz.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include <string.h>

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int find_prev(OBJECT *tree, int obj)
{
	int prev;
	int idx;

	idx = ObjcGParent(tree, obj);
	prev = -1;
	idx = tree[idx].ob_head;
	if (idx != obj)
	{
		do
		{
			if (!(tree[idx].ob_flags & HIDETREE) && !(tree[idx].ob_state & DISABLED))
			{
				prev = idx;
			}
			idx = tree[idx].ob_next;
		} while (idx != obj);
		if (prev != -1)
			return prev;
	}
	return obj;
}

/*** ---------------------------------------------------------------------- ***/

static int find_next(OBJECT *tree, int obj)
{
	int parent;
	int idx;

	parent = ObjcGParent(tree, obj);
	idx = obj;
	do
	{
		idx = tree[idx].ob_next;
		if (idx != parent && !(tree[idx].ob_flags & HIDETREE) && !(tree[idx].ob_state & DISABLED))
			return idx;
	} while (idx != parent);
	return obj;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * XXX
 * a5 -> a6
 * a4 -> a5
 */
static void do_popup(OBJECT *tree, int x, int y, int rel, int cob, int mustbuffer, OBJECT **restree, int flag, int *resobj)
{
	int screenx;
	int screeny;
	int screenw;
	int screenh;
	int prev_obj;
	int obj;
	int mouse_obj;
	int events;
	DIALINFO dinfo;
	int mox;
	int moy;
	int mstate;
	int dummy;
	int xx;
	int yy;
	int done;

	(void)flag;
	xx = x;
	yy = y;
	WindUpdate(BEG_MCTRL);
	graf_mkstate(&mox, &moy, &mstate, &dummy);
	if (rel)
	{
		x += mox;
		y += moy;
	}
	if (cob != -1)
	{
		if (rel)
		{
			int obx;
			int oby;

			ObjcOffset(tree, cob, &obx, &oby);
			x -= (tree[cob].ob_width >> 1) + obx - tree[ROOT].ob_x;
			y -= (tree[cob].ob_height >> 1) + oby - tree[ROOT].ob_y;
		} else
		{
			x -= tree[cob].ob_x;
			y -= tree[cob].ob_y;
		}
	}
	
	HandScreenSize(&screenx, &screeny, &screenw, &screenh);
	prev_obj = -1;
	*resobj = prev_obj;
	*restree = NULL;
	if (x < screenx + 1)
		x = screenx + 1;
	if (y < screeny + 1)
		y = screeny + 1;
	if (tree[ROOT].ob_width + x + 3 > screenx + screenw)
		x = screenx + screenw - (tree[ROOT].ob_width + 3);
	if (tree[ROOT].ob_height + y + 3 > screeny + screenh)
		y = screeny + screenh - (tree[ROOT].ob_height + 3);
	
	tree[ROOT].ob_x = x;
	tree[ROOT].ob_y = y;
	if (tree[ROOT].ob_height); /* XXX */
	if (DialStart(tree, &dinfo) == FALSE && mustbuffer)
	{
		*resobj = -2;
		return;
	}
	obj = objc_find(tree, ROOT, MAX_DEPTH, mox, moy);
	mouse_obj = obj;
	events = 0;
	if (obj == -1)
	{
		obj = objc_find(tree, ROOT, MAX_DEPTH, xx, yy);
		mouse_obj = obj;
		if (obj != -1)
			events |= MU_KEYBD;
	}
	if (obj != -1)
	{
		if ((tree[obj].ob_state & DISABLED) || !(tree[obj].ob_flags & SELECTABLE))
			obj = -1;
	}
	if (obj != -1)
	{
		if (tree[obj].ob_flags & SELECTABLE)
			tree[obj].ob_state |= SELECTED;
	}
	DialDraw(&dinfo);
	
	do
	{
		int key;
		int inside;
		GRECT gr;

		if (mouse_obj != -1)
		{
			inside = 1;
			ObjcOffset(tree, mouse_obj, &gr.g_x, &gr.g_y);
			gr.g_w = tree[mouse_obj].ob_width;
			gr.g_h = tree[mouse_obj].ob_height;
		} else
		{
			inside = 0;
			ObjcOffset(tree, ROOT, &gr.g_x, &gr.g_y);
			gr.g_w = tree[ROOT].ob_width;
			gr.g_h = tree[ROOT].ob_height;
		}
		if (events & MU_KEYBD)
		{
			inside = 1;
			gr.g_x = mox;
			gr.g_y = moy;
			gr.g_w = gr.g_h = 1;
		}
		events = evnt_multi(MU_KEYBD | MU_BUTTON | MU_M1,
			1, 1, (~mstate) & 1,
			inside, gr.g_x, gr.g_y, gr.g_w, gr.g_h,
			0, 0, 0, 0, 0,
			NULL,
			0, 0,
			&mox, &moy, &dummy, &dummy, &key, &dummy);
		prev_obj = obj;
		done = 0;
		
		if (events & MU_KEYBD)
		{
			if ((key & 0xff00) == 0x5000) /* cursor down */
			{
				obj = find_next(tree, prev_obj >= 0 ? prev_obj : 1);
				mouse_obj = obj;
			}
			if ((key & 0xff00) == 0x4800) /* cursor up */
			{
				obj = find_prev(tree, prev_obj >= 0 ? prev_obj : 1);
				mouse_obj = obj;
			}
			if ((key & 0xff00) == 0x6100) /* undo */
			{
				done = obj = -1;
			}			
			if ((key & 0x00ff) == 0x000d) /* return/enter */
			{
				done = 1;
			}
		} else
		{
			obj = objc_find(tree, ROOT, MAX_DEPTH, mox, moy);
			mouse_obj = obj;
		}
		if (obj != -1)
		{
			if ((tree[obj].ob_state & DISABLED) || !(tree[obj].ob_flags & SELECTABLE))
				obj = -1;
		}
		if (prev_obj != obj && prev_obj != -1)
		{
			objc_change(tree, prev_obj, 0, screenx, screeny, screenw, screenh, tree[prev_obj].ob_state & ~SELECTED, TRUE);
		}
		if (obj != -1)
		{
			objc_change(tree, obj, 0, screenx, screeny, screenw, screenh, tree[obj].ob_state | SELECTED, TRUE);
		}
	} while (!(events & MU_BUTTON) && done == 0);
	DialEnd(&dinfo);
	if (((~mstate) & 1) && done == 0)
		evnt_button(1, 1, 0, &dummy, &dummy, &dummy, &dummy);
	if (obj != -1)
	{
		*restree = tree;
		*resobj = obj;
	}
	WindUpdate(END_MCTRL);
}

/*** ---------------------------------------------------------------------- ***/

static int cycle_popup(OBJECT *tree, int obj)
{
	int next;

	next = find_next(tree, obj);
	if (next == obj)
	{
		next = tree[ROOT].ob_head;
		if ((tree[next].ob_flags & HIDETREE) || (tree[next].ob_state & DISABLED))
			next = find_next(tree, next);
	}
	return next;
}

/*** ---------------------------------------------------------------------- ***/

int JazzSelect(OBJECT *tree, int obj, OBJECT *Popup, int docheck, int docycle, long *obs)
{
	int obx;
	int oby;
	int resobj;
	OBJECT *restree;
	int cob;
	int idx;
	
	cob = -1;
	idx = 0;
	do
	{
		if (Popup[idx].ob_flags & SELECTABLE)
			Popup[idx].ob_state &= ~SELECTED;
		if (docheck)
			Popup[idx].ob_state &= ~CHECKED;
		if (Popup[idx].ob_spec.index == *obs)
			cob = idx;
		idx++;
	} while (!(Popup[idx - 1].ob_flags & LASTOB));
	if (cob == -1)
		return 0;
	if (docheck)
		Popup[cob].ob_state |= CHECKED;
	if (docycle == 0)
	{
		ObjcOffset(tree, obj, &obx, &oby);
		do_popup(Popup, obx, oby, FALSE, cob, TRUE, &restree, TRUE, &resobj);
	} else if (docycle == 1)
	{
		resobj = find_next(Popup, cob);
	} else if (docycle == -1)
	{
		resobj = find_prev(Popup, cob);
	} else
	{
		resobj = cycle_popup(Popup, cob);
	}
	if (resobj == -2)
	{
		resobj = cycle_popup(Popup, cob);
	}
	if (resobj != -1)
		*obs = Popup[resobj].ob_spec.index;
	else
		*obs = 0;
	return resobj;
}

/*** ---------------------------------------------------------------------- ***/

void JazzUp(OBJECT *tree, int x, int y, int rel, int cob, int mustbuffer, OBJECT **restree, int *resobj)
{
	do_popup(tree, x, y, rel, cob, mustbuffer, restree, FALSE, resobj);
}
