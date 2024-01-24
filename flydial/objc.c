/*
	@(#)FlyDial/objc.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include <string.h>

struct button_image {
	MFDB *unselected;
	MFDB *selected;
	int xsize;
	int ysize;
};
static struct button_image rbutton_image;
static struct button_image cycle_image;
static void (*draw_rbutton_func)(int x, int y, int w, int h, int state);
static MFDB src_fdb; /* FIXME: move to local functions */

static int unselected_radio_large_data[16] = {
	0x0000, 0x03c0, 0x0c30, 0x1008, 0x2004, 0x2004, 0x4002, 0x4002,
	0x4002, 0x4002, 0x2004, 0x2004, 0x1008, 0x0c30, 0x03c0, 0x0000
};
static int selected_radio_large_data[16] = {
	0x0000, 0x03c0, 0x0c30, 0x1188, 0x27e4, 0x2ff4, 0x4ff2, 0x5ffa,
	0x5ffa, 0x4ff2, 0x2ff4, 0x27e4, 0x1188, 0x0c30, 0x03c0, 0x0000
};
static MFDB unselected_radio_large_mfdb = { unselected_radio_large_data, 16, 16, 1, 0, 1, 0, 0, 0 };
static MFDB selected_radio_large_mfdb = { selected_radio_large_data, 16, 16, 1, 0, 1, 0, 0, 0 };
static int unselected_radio_small_data[8] = {
	0x07e0, 0x381c, 0x4002, 0x8001, 0x8001, 0x4002, 0x381c, 0x07e0
};
static int selected_radio_small_data[8] = {
	0x07e0, 0x381c, 0x47e2, 0xbffd, 0xbffd, 0x47e2, 0x381c, 0x07e0
};
static MFDB unselected_radio_small_mfdb = { unselected_radio_small_data, 16, 8, 1, 0, 1, 0, 0, 0 };
static MFDB selected_radio_small_mfdb = { selected_radio_small_data, 16, 8, 1, 0, 1, 0, 0, 0 };
static int cycle_large_data[16] = {
	0x0000, 0x0000, 0x13c0, 0x1c30, 0x1c08, 0x0008, 0x2004, 0x2004,
	0x2004, 0x2004, 0x1000, 0x1038, 0x0c38, 0x03c8, 0x0000, 0x0000
};
static int cycle_small_data[8] = {
	0x27e0, 0x381c, 0x3000, 0x0000, 0x0000, 0x000c, 0x381c, 0x07e4
};
static MFDB cycle_large_mfdb = { cycle_large_data, 16, 16, 1, 0, 1, 0, 0, 0 };
static MFDB cycle_small_mfdb = { cycle_small_data, 16, 8, 1, 0, 1, 0, 0, 0 };
static struct button_image radio_images[2] = {
	{ &unselected_radio_large_mfdb, &selected_radio_large_mfdb, 8, 16 },
	{ &unselected_radio_small_mfdb, &selected_radio_small_mfdb, 8, 8 },
};
static struct button_image cycle_images[2] = {
	{ &cycle_large_mfdb, &cycle_large_mfdb, 8, 16 },
	{ &cycle_small_mfdb, &cycle_small_mfdb, 8, 8 },
};

static MFDB screen_mfdb = { NULL, 0, 0, 0, 0, 0, 0, 0, 0 };
static int (cdecl *draw_cycle_func)(PARMBLK *pb) = 0;

#define DIM(x) (int)(sizeof(x)/sizeof(x[0]))


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void draw_rbutton_images(int x, int y, int _w, int _h, int state)
{
	int w;
	int h;
	int pxy[8];
	static int color_index[2] = { 1, 0 };
	
	(void)_w;
	(void)_h;
	w = rbutton_image.unselected->fd_w;
	h = rbutton_image.unselected->fd_h;
	RectAES2VDI(0, 0, w, h, &pxy[0]);
	RectAES2VDI(x, y, w, h, &pxy[4]);
	vrt_cpyfm(DialWk, MD_XOR, pxy, state & SELECTED ? rbutton_image.selected : rbutton_image.unselected, &screen_mfdb, color_index);
}

/*** ---------------------------------------------------------------------- ***/

static void draw_rbutton_generic(int x, int y, int w, int h, int state)
{
	int pxy[4];
	
	RectAES2VDI(x, y, w, h, &pxy[0]);
	vsf_color(DialWk, BLACK);
	vsf_perimeter(DialWk, 1);
	vsf_interior(DialWk, FIS_HOLLOW);
	v_bar(DialWk, pxy);
	RectAES2VDI(x + 2, y + 2, w - 4, h - 4, pxy);
	vsf_interior(DialWk, state & SELECTED ? FIS_SOLID : FIS_HOLLOW);
	v_bar(DialWk, pxy);
}

/*** ---------------------------------------------------------------------- ***/

struct myuserblk {
	OBJECT *tree;
	USERBLK user;
	int type;
};

static struct myuserblk *userblks = NULL;

static int alloc_userblks(void)
{
	int count;
	int i;
	struct myuserblk *old_userblks;
	int newcount;
	
	count = 0;
	old_userblks = userblks;
	if (userblks != NULL)
	{
		for (i = count; userblks[i].tree != (void *)-1; i++)
		{
			if (userblks[i].tree != NULL)
				count++;
		}
		newcount = count + 20;
	} else
	{
		newcount = count + 100;
	}
	userblks = dialmalloc(newcount * sizeof(*userblks));
	if (userblks == NULL)
	{
		userblks = old_userblks;
		return FALSE;
	}
	memset(userblks, 0, newcount * sizeof(*userblks));
	userblks[newcount - 1].tree = (void *)-1;
	if (old_userblks != NULL)
	{
		for (i = 0; old_userblks->tree != (void *)-1; i++, old_userblks++)
		{
			if (old_userblks->tree != NULL)
				userblks[i] = *old_userblks;
		}
		dialfree(old_userblks);
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static struct myuserblk *find_free_userblk(void)
{
	struct myuserblk *user;
	
	user = userblks;
	if (user != NULL)
	{
		do
		{
			if (user->tree == NULL)
				return user;
			user++;
		} while (user->tree != (void *)-1);
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

static struct myuserblk *add_userblk(long data) /* FIXME: why long? */
{
	struct myuserblk *user;
	
	user = find_free_userblk();
	if (user == NULL)
	{
		if (alloc_userblks() == FALSE)
			return NULL;
		user = find_free_userblk();
	}
	user->tree = (void *)data;
	return user;
}

/*** ---------------------------------------------------------------------- ***/

/* FIXME: unused */
static void remove_userblk(long data) /* FIXME: why long? */
{
	int i;
	
	if (userblks != NULL)
	{
		for (i = 0; userblks[i].tree != (void *)-1; i++)
			if (userblks[i].tree == (void *)data)
				userblks[i].tree = NULL;
	}
}

/*** ---------------------------------------------------------------------- ***/

static int cdecl draw_underline(PARMBLK *pb)
{
	int pxy[4];
	
	if (pb->pb_prevstate == pb->pb_currstate)
	{
		HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
		v_gtext(DialWk, pb->pb_x, pb->pb_y, (char *)pb->pb_parm);
		RectAES2VDI(pb->pb_x, pb->pb_y + pb->pb_h - 1, pb->pb_w, 1, pxy);
		vsl_type(DialWk, SOLID);
		vsl_color(DialWk, BLACK);
		v_pline(DialWk, 2, pxy);
		HandClip(0, 0, 0, 0, FALSE);
	}
	return pb->pb_currstate;
}

/*** ---------------------------------------------------------------------- ***/

int cdecl ObjcAnimImage(PARMBLK *pb)
{
	int pxy[8];
	ANIMBITBLK *info;
	BITBLK *image;
	static int color_index[2] = { 1, 0 };

	info = (ANIMBITBLK *)pb->pb_parm;
	HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
	info->Current++;
	if (info->Images[info->Current] == NULL)
		info->Current = 0;
	image = info->Images[info->Current];
	src_fdb.fd_addr = image->bi_pdata;
	src_fdb.fd_w = image->bi_wb << 3;
	src_fdb.fd_h = image->bi_hl;
	src_fdb.fd_wdwidth = image->bi_wb >> 1; /* BUG: must be rounded up */
	src_fdb.fd_stand = FALSE;
	src_fdb.fd_nplanes = 1;
	color_index[0] = image->bi_color;
	RectAES2VDI(image->bi_x, image->bi_y, image->bi_wb << 3, image->bi_hl, &pxy[0]);
	RectAES2VDI(pb->pb_x, pb->pb_y, image->bi_wb << 3, image->bi_hl, &pxy[4]);
	vrt_cpyfm(DialWk, MD_XOR, pxy, &src_fdb, &screen_mfdb, color_index);
	HandClip(0, 0, 0, 0, FALSE);
	return NORMAL;
}

/*** ---------------------------------------------------------------------- ***/

static int cdecl draw_titleline(PARMBLK *pb)
{
	if (pb->pb_prevstate == pb->pb_currstate)
	{
		HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
		vswr_mode(DialWk, MD_REPLACE);
		RastDrawRect(DialWk, pb->pb_x, pb->pb_y + (HandYSize >> 1), pb->pb_w, pb->pb_h - (HandYSize >> 1));
		v_gtext(DialWk, pb->pb_x + HandXSize, pb->pb_y, (char *)pb->pb_parm);
		HandClip(0, 0, 0, 0, FALSE);
	}	
	return pb->pb_currstate;
}

/*** ---------------------------------------------------------------------- ***/

static int calc_underline_pos(char *str)
{
	char *ptr;
	int len = -1;
	
	ptr = str;
	while (*ptr != '\0')
	{
		if (*ptr == '[')
		{
			strcpy(ptr, ptr + 1); /* FIXME: use memmove for overlapping copy */
			if (*ptr != '[')
			{
				len = (int)(ptr) - (int)(str); /* BUG: wrong cast */
			}
			ptr++; /* BUG: must not advance here */
		}
		ptr++; /* BUG: must only advance if != '[' */
	}
	return len;
}

/*** ---------------------------------------------------------------------- ***/

static void draw_string(int x, int y, char *str, int underline, int state)
{
	char c[2];

	vst_effects(DialWk, state & DISABLED ? 2 : 0);
	v_gtext(DialWk, x, y, str);
	if (state & CHECKED)
		v_gtext(DialWk, x, y, "\000\010"); /* BUG? why \0? */
	if (underline != -1)
	{
		c[0] = str[underline];
		c[1] = '\0';
		vst_effects(DialWk, state & DISABLED ? (2 | 8) : 8);
		v_gtext(DialWk, x + underline * HandXSize, y, c);
	}
	/* FIXME: reset effects here */
}

/*** ---------------------------------------------------------------------- ***/

int cdecl ObjcMyButton(PARMBLK *pb)
{
	int flags;
	int state;
	int x, y, w, h;
	int inlinesize;
	int framesize;
	int x2;
	int y2;
	int underline;
	char buf[80]; /* FIXME: quite short, but watch out for AES stack */

	inlinesize = 0;
	framesize = 0;
	HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
	flags = pb->pb_tree[pb->pb_obj].ob_flags;
	state = pb->pb_currstate;
	x = pb->pb_x;
	y = pb->pb_y;
	w = pb->pb_w;
	h = pb->pb_h;
	if ((state & CROSSED) && state != pb->pb_prevstate)
	{
		if (!(state & (SELECTED | CHECKED)))
		{
			pb->pb_tree[pb->pb_obj].ob_state = state |= CHECKED;
		} else if ((state & (SELECTED | CHECKED)) == (SELECTED | CHECKED))
		{
			pb->pb_tree[pb->pb_obj].ob_state = state &= ~(SELECTED | CHECKED);
		}
	}
	vswr_mode(DialWk, MD_REPLACE);
	strcpy(buf, (char *)pb->pb_parm);
	underline = calc_underline_pos(buf);
	if ((pb->pb_tree[pb->pb_obj].ob_type & 0xff00) != (G_BUTTON << 8))
	{
		draw_string(x, y, buf, underline, NORMAL);
		vst_effects(DialWk, 0);
		HandClip(0, 0, 0, 0, FALSE);
	} else
	{
		y2 = y + ((h - HandYSize) >> 1);
		x2 = x + ((w - (int)strlen(buf) * HandXSize) >> 1);
		if (!(flags & EXIT))
		{
			w = HandXSize * 2;
			x2 = x + w + HandXSize;
			w--;
			h--;
		}
		vsf_color(DialWk, state & CHECKED ? BLACK : WHITE);
		vsf_interior(DialWk, state & CHECKED ? FIS_PATTERN : FIS_SOLID);
		vsf_style(DialWk, 1);
		{
		int pxy[4]; /* FIXME: move to top */
		RectAES2VDI(x, y, w, h, pxy);
		v_bar(DialWk, pxy);
		}
		draw_string(x2, y2, buf, underline, flags & RBUTTON ? NORMAL : state);
		if (flags & DEFAULT)
			framesize++;
		if (flags & EXIT)
			framesize++;
		else
			framesize = inlinesize = 0;
		if (state & OUTLINED)
			framesize = inlinesize = 2;
		if ((state & DISABLED) && !(flags & (EXIT | RBUTTON)))
		{
			vsl_udsty(DialWk, 0x5555);
			vsl_type(DialWk, USERLINE);
		}
		if (!(flags & RBUTTON))
		{
			int i;
			
			for (i = inlinesize; i <= framesize; i++)
			{
				RastDrawRect(DialWk, x - i, y - i, w + 2 * i, h + 2 * i);
			}
		}
		if (!(flags & EXIT))
		{
			if (flags & RBUTTON)
			{
				draw_rbutton_func(x, y, w, h, state);
			} else if (state & SELECTED)
			{
				int tmp;
				int pxy[4]; /* FIXME: move to top */
				
				RectAES2VDI(x + 1, y + 1, w - 2, h - 2, pxy);
				v_pline(DialWk, 2, pxy);
				tmp = pxy[0];
				pxy[0] = pxy[2];
				pxy[2] = tmp;
				v_pline(DialWk, 2, pxy);
			}
		} else
		{
			if (state & SELECTED)
			{
				int pxy[4];

				RectAES2VDI(x + 1, y + 1, w - 2, h - 2, pxy);
				vsf_perimeter(DialWk, 0);
				vswr_mode(DialWk, MD_XOR);
				vsf_color(DialWk, BLACK);
				vsf_interior(DialWk, FIS_SOLID);
				v_bar(DialWk, pxy);
			}
		}
		vst_effects(DialWk, 0);
		HandClip(0, 0, 0, 0, FALSE);
		if ((state & DISABLED) && !(flags & (EXIT | RBUTTON)))
		{
			vsl_type(DialWk, SOLID);
		}
		if (flags & RBUTTON)
			return state & DISABLED;
	}
	return NORMAL;
}

/*** ---------------------------------------------------------------------- ***/

static int cdecl draw_mover(PARMBLK *pb)
{
	int pxy[8];
	int x, y, w, h;

	x = pb->pb_x - 2;
	y = pb->pb_y - 2;
	w = pb->pb_w + 4;
	h = pb->pb_h + 4;
	HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
	RectAES2VDI(x, y, w, h, pxy);
	vswr_mode(DialWk, MD_REPLACE);
	vsl_color(DialWk, WHITE);
	RastDrawRect(DialWk, x + 1, y + 1, w - 2, h - 2);
	vsl_color(DialWk, BLACK);
	RastDrawRect(DialWk, x + 3, y + 3, w - 6, h - 6);
	RastDrawRect(DialWk, x, y - 1, w + 1, h + 1);
	v_pline(DialWk, 2, pxy);
	HandClip(0, 0, 0, 0, FALSE);
	return NORMAL;
}

/*** ---------------------------------------------------------------------- ***/

static int cdecl draw_cycle_images(PARMBLK *pb)
{
	int pxy[8];
	int w, h;
	static int color_index[2] = { 1, 0 };

	w = cycle_image.unselected->fd_w;
	h = cycle_image.unselected->fd_h;
	HandClip(pb->pb_xc, pb->pb_yc, pb->pb_wc, pb->pb_hc, TRUE);
	RectAES2VDI(pb->pb_x - 1, pb->pb_y - 1, pb->pb_w + 2, pb->pb_h + 2, pxy);
	memcpy(&pxy[4], &pxy[0], 4 * sizeof(pxy[0]));
	vro_cpyfm(DialWk, ALL_BLACK, pxy, &screen_mfdb, &screen_mfdb);
	RectAES2VDI(pb->pb_x, pb->pb_y, pb->pb_w, pb->pb_h, pxy);
	memcpy(&pxy[4], &pxy[0], 4 * sizeof(pxy[0]));
	vro_cpyfm(DialWk, ALL_WHITE, pxy, &screen_mfdb, &screen_mfdb);
	RectAES2VDI(0, 0, w, h, pxy);
	vrt_cpyfm(DialWk, MD_XOR, pxy, cycle_image.unselected, &screen_mfdb, color_index);
	HandClip(0, 0, 0, 0, FALSE);
	return pb->pb_currstate & DISABLED;
}

/*** ---------------------------------------------------------------------- ***/

void ObjcInit(void)
{
	int i;
	
	alloc_userblks();
	draw_rbutton_func = draw_rbutton_generic;
	for (i = 0; i < DIM(radio_images); i++)
	{
		if (HandXSize == radio_images[i].xsize && HandYSize == radio_images[i].ysize)
		{
			rbutton_image = radio_images[i];
			RastTrans(rbutton_image.unselected->fd_addr, rbutton_image.unselected->fd_wdwidth * 2, rbutton_image.unselected->fd_h, DialWk);
			RastTrans(rbutton_image.selected->fd_addr, rbutton_image.selected->fd_wdwidth * 2, rbutton_image.selected->fd_h, DialWk);
			draw_rbutton_func = draw_rbutton_images;
		}
	}
	for (i = 0; i < DIM(cycle_images); i++)
	{
		if (HandXSize == radio_images[i].xsize && HandYSize == radio_images[i].ysize) /* BUG: should use cycle_images[] */
		{
			cycle_image = cycle_images[i];
			RastTrans(cycle_image.unselected->fd_addr, cycle_image.unselected->fd_wdwidth * 2, cycle_image.unselected->fd_h, DialWk);
			draw_cycle_func = draw_cycle_images;
			/*
			 * BUG: draw_cycle_func undefined if no match found
			 */
		}
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

int ObjcTreeInit(OBJECT *tree)
{
	int obj;
	struct myuserblk *user;
	
	obj = 0;
	for (;;)
	{
		if ((tree[obj].ob_type & 0xff00) == (18 << 8))
		{
			if (!(tree[obj].ob_flags & EXIT))
			{
				int width;

				width = (int)strlen(tree[obj].ob_spec.free_string) + 3;
				if (strchr(tree[obj].ob_spec.free_string, '[') != NULL)
					width--;
				tree[obj].ob_width = HandXSize * width;
			} else
			{
				tree[obj].ob_y -= 2;
				tree[obj].ob_height += 4;
			}
		}
		/*
		 * special buttons
		 */
		if ((tree[obj].ob_type & 0xff00) == (18 << 8))
		{
			user = add_userblk((long) tree);
			if (user == NULL)
				return FALSE;
			user->user.ub_parm = tree[obj].ob_spec.index;
			user->user.ub_code = ObjcMyButton;
			user->type = tree[obj].ob_type;
			tree[obj].ob_type = tree[obj].ob_type << 8;
			tree[obj].ob_type &= 0xff00;
			tree[obj].ob_type |= G_USERDEF;
			tree[obj].ob_spec.userblk = &user->user;
		}
		/*
		 * underline
		 */
		if ((tree[obj].ob_type & 0xff00) == (19 << 8))
		{
			user = add_userblk((long) tree);
			if (user == NULL)
				return FALSE;
			tree[obj].ob_height++;
			user->user.ub_parm = tree[obj].ob_spec.index;
			user->user.ub_code = draw_underline;
			user->type = tree[obj].ob_type;
			tree[obj].ob_type &= 0xff00;
			tree[obj].ob_type |= G_USERDEF;
			tree[obj].ob_spec.userblk = &user->user;
		}
		/*
		 * title line
		 */
		if ((tree[obj].ob_type & 0xff00) == (20 << 8))
		{
			user = add_userblk((long) tree);
			if (user == NULL)
				return FALSE;
			user->user.ub_parm = tree[obj].ob_spec.index;
			user->user.ub_code = draw_titleline;
			user->type = tree[obj].ob_type;
			tree[obj].ob_type &= 0xff00;
			tree[obj].ob_type |= G_USERDEF;
			tree[obj].ob_spec.userblk = &user->user;
		}

		/*
		 * cycle button
		 */
		if ((tree[obj].ob_type & 0xff00) == (22 << 8))
		{
			if ((tree[obj].ob_type & 0xff) == G_BOXCHAR)
			{
				tree[obj].ob_type &= 0xff00;
				tree[obj].ob_type |= G_USERDEF;
				tree[obj].ob_spec.userblk = (USERBLK *)&draw_cycle_func; /* FIXME: ugly cast */
			} else
			{
				tree[obj].ob_width--;
			}
		}
		
		if ((tree[obj].ob_type & 0xff00) == (23 << 8))
		{
			tree[obj].ob_type &= 0x00ff;
			ObjcVStretch(tree, obj, 3, 2);
		}
		
		/*
		 * animated image
		 */
		if ((tree[obj].ob_type & 0xff) == G_ANIMIMAGE)
		{
			user = add_userblk((long) tree);
			if (user == NULL)
				return FALSE;
			user->user.ub_parm = tree[obj].ob_spec.index;
			user->user.ub_code = ObjcAnimImage;
			user->type = tree[obj].ob_type;
			tree[obj].ob_type &= 0xff00;
			tree[obj].ob_type |= G_USERDEF;
			tree[obj].ob_spec.userblk = &user->user;
		}

		/*
		 * dialog mover
		 */
		if (tree[obj].ob_type == ((17 << 8) | G_IBOX) &&
			(tree[obj].ob_state & (CROSSED | OUTLINED)) == (CROSSED | OUTLINED))
		{
			struct myuserblk *user; /* FIXME: use global */

			user = add_userblk((long) tree);
			if (user == NULL)
				return FALSE;
			user->user.ub_parm = tree[obj].ob_spec.index;
			user->user.ub_code = draw_mover;
			user->type = tree[obj].ob_type;
			tree[obj].ob_type &= 0xff00;
			tree[obj].ob_type |= G_USERDEF;
			tree[obj].ob_spec.userblk = &user->user;
		}
		
		if (tree[obj].ob_flags & LASTOB)
			return TRUE;
		obj++;
	}
}

/*** ---------------------------------------------------------------------- ***/

int ObjcRemoveTree(OBJECT *tree)
{
	int obj;
	
	obj = 0;
	for (;;)
	{
		if ((tree[obj].ob_type & 0xff) == G_USERDEF && tree[obj].ob_spec.userblk->ub_code == draw_mover)
		{
			tree[obj].ob_spec.index = tree[obj].ob_spec.userblk->ub_parm;
			tree[obj].ob_type = (17 << 8) | G_IBOX;
		}
		if ((tree[obj].ob_type & 0xff) == G_USERDEF && tree[obj].ob_spec.userblk->ub_code == ObjcMyButton)
		{
			tree[obj].ob_spec.index = tree[obj].ob_spec.userblk->ub_parm;
			tree[obj].ob_type = (18 << 8) | G_BUTTON;
		}

		if (tree[obj].ob_flags & LASTOB)
			break;
		obj++;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static int draw_depth = 0;

int ObjcDeepDraw(void)
{
	return draw_depth;
}

/*** ---------------------------------------------------------------------- ***/

int ObjcGParent(OBJECT *tree, int obj)
{
	int next;
	
	if (obj == -1)
		return -1;
	next = tree[obj].ob_next;
	if (next != -1)
	{
		while (tree[next].ob_tail != obj)
		{
			obj = next;
			next = tree[obj].ob_next;
		}
	}
	return next;
}

/*** ---------------------------------------------------------------------- ***/

int ObjcOffset(OBJECT *tree, int obj, int *x, int *y)
{
	int obx, oby;
	
	obx = 0;
	oby = 0;
	do
	{
		obx += tree[obj].ob_x;
		oby += tree[obj].ob_y;
		obj = ObjcGParent(tree, obj);
	} while (obj != -1);
	*x = obx;
	*y = oby;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int ObjcDraw(OBJECT *tree, int startob, int depth, int xclip, int yclip, int wclip, int hclip)
{
	return objc_draw(tree, startob, depth, xclip, yclip, wclip, hclip);
}

/*** ---------------------------------------------------------------------- ***/

void ObjcXywh(OBJECT *tree, int obj, GRECT *p)
{
	ObjcOffset(tree, obj, &p->g_x, &p->g_y);
	p->g_w = tree[obj].ob_width;
	p->g_h = tree[obj].ob_height;
}

/*** ---------------------------------------------------------------------- ***/

int ObjcChange(OBJECT *tree, int obj, int resvd, int cx, int cy, int cw, int ch, int newstate, int redraw)
{
	return objc_change(tree, obj, resvd, cx, cy, cw, ch, newstate, redraw);
}

/*** ---------------------------------------------------------------------- ***/

void ObjcToggle(OBJECT *tree, int obj)
{
	GRECT gr;
	
	ObjcXywh(tree, ROOT, &gr);
	ObjcChange(tree, obj, 0, gr.g_x, gr.g_y, gr.g_w, gr.g_h, tree[obj].ob_state ^ SELECTED, TRUE);
}

/*** ---------------------------------------------------------------------- ***/

void ObjcSel(OBJECT *tree, int obj)
{
	if (!(tree[obj].ob_state & SELECTED))
		ObjcToggle(tree, obj);
}

/*** ---------------------------------------------------------------------- ***/

void ObjcDsel(OBJECT *tree, int obj)
{
	if (tree[obj].ob_state & SELECTED)
		ObjcToggle(tree, obj);
}

/*** ---------------------------------------------------------------------- ***/

void ObjcVStretch(OBJECT *tree, int obj, int a, int b)
{
	int parent;
	
	parent = obj;
	obj = tree[obj].ob_head;
	do
	{
		tree[obj].ob_y = tree[obj].ob_y * a;
		tree[obj].ob_y = tree[obj].ob_y / b;
		obj = tree[obj].ob_next;
	} while (obj != parent);
}

/*** ---------------------------------------------------------------------- ***/

OBSPEC *ObjcGetObspec(OBJECT *tree, int obj)
{
	if ((tree[obj].ob_type & 0xff) != G_USERDEF)
		return &tree[obj].ob_spec;
	return (OBSPEC *)&tree[obj].ob_spec.userblk->ub_parm;
}
