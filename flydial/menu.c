/*
	@(#)FlyDial/menu.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int cdecl draw_thinline(PARMBLK *pb)
{
	int x, y;
	int pxy[4];

	ObjcOffset(pb->pb_tree, pb->pb_obj, &x, &y);
	vsf_color(DialWk, BLACK);
	vsf_interior(DialWk, FIS_PATTERN);
	vsf_style(DialWk, 4);
	RectAES2VDI(x, (pb->pb_h >> 1) + y - 1, pb->pb_w, 2, pxy);
	vr_recfl(DialWk, pxy);
	vsf_style(DialWk, 8);
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

static USERBLK thinline_userblk = { draw_thinline, 0 };

void MenuSet2ThinLine(OBJECT *tree, int ob)
{
	tree[ob].ob_type = G_USERDEF;
	tree[ob].ob_spec.userblk = &thinline_userblk;
}

/*** ---------------------------------------------------------------------- ***/

static void tune_tree(OBJECT *tree, int parent, int tune)
{
	int idx;
	
	idx = tree[parent].ob_head;
	do
	{
		if (tune)
		{
			tree[idx].ob_width -= HandXSize;
		}
		if (tree[idx].ob_spec.free_string[0] == '-')
			MenuSet2ThinLine(tree, idx);
		idx = tree[idx].ob_next;
	} while (idx != parent);
	if (tune)
	{
		tree[idx].ob_width -= (&HandYSize)[-1]; /* XXX */
	}
}

/*** ---------------------------------------------------------------------- ***/

void MenuTune(OBJECT *tree, int tune)
{
	int box;
	int item;
	
	box = tree[tree[ROOT].ob_head].ob_next;
	item = tree[box].ob_head;
	do
	{
		tune_tree(tree, item, tune);
		item = tree[item].ob_next;
	} while (item != box);
}
