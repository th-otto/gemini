/*
	@(#)FlyDial/form.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include <string.h>
#include <ctype.h>

#define SHFT_INS                    0x5230
#define UNDO                        0x6100
#define HELP                        0x6200
#define HOME                        0x4700
#define TAB                         0x0f09
#define CNTL_CUR_UP                 0x7100
#define CNTL_CUR_DOWN               0x7200
#define CNTL_CUR_LEFT               0x7300
#define CNTL_CUR_RIGHT              0x7400
#define RETURN                      0x1c0d
#define CUR_UP                      0x4800
#define CUR_DOWN                    0x5000

static int tos_version = -1;
static const char *form_valchars = NULL;
static VALFUN *form_funcs = NULL;
static FORMKEYFUNC form_keybd_func = FormKeybd;

#define _SYSBASE  ((SYSHDR **)0x4f2L)

#ifndef SuperToUser
#define SuperToUser(s) Super(s)
#endif

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int get_tosversion(void)
{
	SYSHDR *syshdr;
	long oldsp;
	
	if (tos_version == -1)
	{
		oldsp = Super(0);
		syshdr = *_SYSBASE;
		SuperToUser((void *)oldsp);
		tos_version = syshdr->os_version;
	}
	return tos_version;
}

/*** ---------------------------------------------------------------------- ***/

void FormSetValidator(const char *valchars, VALFUN *funs)
{
	form_valchars = valchars;
	form_funcs = funs;
}

/*** ---------------------------------------------------------------------- ***/

static int FormEdit(OBJECT *tree, int obj, int edchar, int kstate, int *edidx, int edkind)
{
	int scancode;
	int ascii;
	char *ptext;
	
	scancode = (edchar >> 8) & 0xff;
	ascii = edchar & 0xff;
	if (edkind == ED_CHAR && (tree[obj].ob_flags & EDITABLE))
	{
		ptext = tree[obj].ob_spec.tedinfo->te_ptext;
		
		switch (scancode)
		{
		case 0x4b: /* cursor left */
			if ((kstate & (K_LSHIFT | K_RSHIFT)) != 0)
			{
				int retcode;
				
				while (*edidx != 0)
				{
					retcode = objc_edit(tree, obj, 0x4b00, edidx, ED_CHAR);
				}
				return retcode;
			}
			break;
		case 0x4d: /* cursor right */
			if ((kstate & (K_LSHIFT | K_RSHIFT)) != 0)
			{
				objc_edit(tree, obj, 0, edidx, ED_END);
				return objc_edit(tree, obj, 0, edidx, ED_INIT);
			}
			break;
		case 0x73: /* control-cursor left */
			if ((kstate & K_CTRL) != 0)
			{
				int retcode;
				
				while (*edidx != 0)
				{
					retcode = objc_edit(tree, obj, 0x4b00, edidx, ED_CHAR);
					if (ptext[*edidx - 1] == ' ' && ptext[*edidx] != ' ')
						break;
				}
				return retcode;
			}
			break;
		case 0x74: /* control-cursor right */
			if ((kstate & K_CTRL) != 0)
			{
				int retcode;
				
				while (ptext[*edidx] != '\0')
				{
					retcode = objc_edit(tree, obj, 0x4d00, edidx, ED_CHAR);
					if (ptext[*edidx - 1] == ' ' && ptext[*edidx] != ' ')
						break;
				}
				return retcode;
			}
			break;
		case 0x53: /* delete */
			if ((kstate & K_CTRL) != 0)
			{
				int screenx, screeny, screenw, screenh;
				
				HandScreenSize(&screenx, &screeny, &screenw, &screenh);
				objc_edit(tree, obj, 0, edidx, ED_END);
				tree[obj].ob_spec.tedinfo->te_ptext[*edidx] = '\0';
				objc_draw(tree, obj, 1, screenx, screeny, screenw, screenh);
				return objc_edit(tree, obj, 0, edidx, ED_INIT);
			}
			break;
		}

		if (form_valchars != NULL)
		{
			int idx;
			char c;
			const char *p;
			int offset;
			
			idx = *edidx;
			/* BUG: te_pvalid might be shortened */
			c = tree[obj].ob_spec.tedinfo->te_pvalid[idx];
			if (c == '\0')
			{
				idx--;
				c = tree[obj].ob_spec.tedinfo->te_pvalid[idx];
			}
			p = strchr(form_valchars, c);
			if (p != NULL)
			{
				offset = (int)(p - form_valchars);
				if ((form_funcs[offset])(tree, obj, &edchar, &kstate, *edidx))
				{
					tree[obj].ob_spec.tedinfo->te_pvalid[idx] = 'X';
					offset = objc_edit(tree, obj, edchar, edidx, edkind);
					tree[obj].ob_spec.tedinfo->te_pvalid[idx] = c;
					return offset;
				} else
				{
					char *ptmplt;
					char *pscan;
					
					ptmplt = tree[obj].ob_spec.tedinfo->te_ptmplt;
					pscan = ptmplt;
					offset = 0;
					while (offset < *edidx)
					{
						while (*pscan != '_')
							pscan++;
						pscan++;
						offset++;
					}
					p = strchr(pscan, ascii);
					if (p != NULL)
					{
						int d0;
						int d3;
						int screenx, screeny, screenw, screenh;
				
						d0 = (int)(p - ptmplt);
						d3 = 0;
						offset = 0;
						while (offset < d0)
						{
							if (ptmplt[offset] == '_')
								d3++;
							offset++;
						}
						HandScreenSize(&screenx, &screeny, &screenw, &screenh);
						objc_edit(tree, obj, 0, edidx, ED_END);
						ptext[*edidx] = '\0';
						while (strlen(ptext) < d3)
							strcat(ptext, " ");
						objc_draw(tree, obj, 1, screenx, screeny, screenw, screenh);
						return objc_edit(tree, obj, 0, edidx, ED_INIT);
					}
					edchar = 0;
				}
			}
		}
	}

	return objc_edit(tree, obj, edchar, edidx, edkind);
}

/*** ---------------------------------------------------------------------- ***/

static void read_number(int *number)
{
	int key;
	
	key = 0;
	*number = 0;
	for (;;)
	{
		key = evnt_keybd();
		if (key == SHFT_INS)
			break;
		*number *= 10;
		*number += (key & 0xff) - '0';
	}
	*number &= 0xff;
}

/*** ---------------------------------------------------------------------- ***/

static int count_objects(OBJECT *tree)
{
	int count;
	
	for (count = 0; !(tree[count].ob_flags & LASTOB); count++)
		;
	return count;
}

/*** ---------------------------------------------------------------------- ***/

static int watch_object(OBJECT *tree, int obj, int selected, int unselected)
{
	int x;
	int y;
	int mstate;
	int kstate;
	GRECT gr;
	int inside;
	int newstate;
	
	inside = FALSE;
	ObjcXywh(tree, obj, &gr);
	mstate = 1;
	x = gr.g_x;
	y = gr.g_y;
	do
	{
		int prev_inside = inside;
		
		if (x >= gr.g_x && y >= gr.g_y && x < gr.g_x + gr.g_w && y < gr.g_y + gr.g_h)
			inside = TRUE;
		else
			inside = FALSE;
		if (prev_inside != inside)
		{
			if (inside)
				newstate = selected;
			else
				newstate = unselected;
			ObjcChange(tree, obj, 0, gr.g_x, gr.g_y, gr.g_w, gr.g_h, newstate, TRUE);
		}
		graf_mkstate(&x, &y, &mstate, &kstate);
	} while (mstate != 0);
	return inside;
}

/*** ---------------------------------------------------------------------- ***/

/* XXX d3<->d4 swapped */
static int find_button(OBJECT *tree, int defobj, unsigned int key)
{
	unsigned int scancode;
	KEYTAB *keytbl;
	unsigned char c;
	int idx;
	
	if (key == HELP)
	{
		idx = 0;
		while (idx >= 0)
		{
			if ((tree[idx].ob_type & 0xff00) == (21 << 8))
				return idx;
			if (tree[idx].ob_flags & LASTOB)
				idx = -1;
			else
				idx++;
		}
	}
	scancode = (key >> 8) & 0xff;
	keytbl = Keytbl((void *)-1, (void *)-1, (void *)-1);
	if (scancode >= 0x78u)
	{
		c = scancode - (0x78 - '1');
		if (c == '9' + 1)
			c = '0';
	} else
	{
		c = keytbl->unshift[scancode];
	}
	c = toupper(c);
	
	idx = 0;
	while (idx >= 0)
	{
		if ((tree[idx].ob_type & 0xff) == G_USERDEF && tree[idx].ob_spec.userblk->ub_code == ObjcMyButton)
		{
			char *p;
			
			p = (char *)tree[idx].ob_spec.userblk->ub_parm;
			p = strchr(p, '[');
			if (p != NULL && p[1] != '[' && toupper(p[1]) == c)
				return idx;
		}
		if (tree[idx].ob_flags & LASTOB)
			idx = -1;
		else
			idx++;
	}
	return defobj;
}

/*** ---------------------------------------------------------------------- ***/

static int find_animimage(OBJECT *tree)
{
	int obj;
	
	obj = 0;
	for (;;)
	{
		if (tree[obj].ob_flags & LASTOB)
			return -1;
		if ((tree[obj].ob_type & 0xff) == G_USERDEF && tree[obj].ob_spec.userblk->ub_code == ObjcAnimImage)
			return obj;
		obj++;
	}
}

/*** ---------------------------------------------------------------------- ***/

static int find_next(OBJECT *tree, int obj, int code)
{
	int idx;
	int direction;
	int flags;
	int obflags;

	idx = 0;
	direction = 1;
	flags = EDITABLE;
	switch (code)
	{
	case -1:
		direction = -1;
		idx = obj + direction;
		break;
	case -2:
		idx = obj + direction;
		break;
	case -3:
		flags = DEFAULT;
		break;
	}
	while (idx >= 0)
	{
		obflags = tree[idx].ob_flags;
		if (obflags & flags)
			return idx;
		if (obflags & LASTOB)
			idx = -1;
		else
			idx += direction;
	}
	return obj;
}

/*** ---------------------------------------------------------------------- ***/

static int find_first(OBJECT *tree, int obj)
{
	if (obj == ROOT)
		obj = find_next(tree, ROOT, -2);
	return obj;
}

/*** ---------------------------------------------------------------------- ***/

static void select_radio(OBJECT *tree, int obj)
{
	int parent;
	int idx;
	
	parent = ObjcGParent(tree, obj);
	idx = tree[parent].ob_head;
	while (idx != parent)
	{
		if (idx != obj && (tree[idx].ob_flags & RBUTTON))
			ObjcDsel(tree, idx);
		idx = tree[idx].ob_next;
	}
	ObjcSel(tree, obj);
}

/*** ---------------------------------------------------------------------- ***/

int FormButton(OBJECT *tree, int obj, int clicks, int *nextobj)
{
	int obflags;
	int obstate;
	int touchexit;
	int selectable;
	int disabled;
	int editable;
	int doubleclick;
	
	obflags = tree[obj].ob_flags;
	obstate = tree[obj].ob_state;
	touchexit = obflags & TOUCHEXIT;
	selectable = obflags & SELECTABLE;
	disabled = obstate & DISABLED;
	editable = obflags & EDITABLE;
	if (touchexit || (selectable && !disabled) || editable)
	{
		if (touchexit && clicks == 2)
			doubleclick = 0x8000;
		else
			doubleclick = 0;
		if (selectable && !disabled)
		{
			if (obflags & RBUTTON)
			{
				select_radio(tree, obj);
			} else
			{
				if (!touchexit)
				{
					if (!watch_object(tree, obj, obstate ^ SELECTED, obstate))
					{
						*nextobj = 0;
						return TRUE;
					}
				} else
				{
					ObjcToggle(tree, obj);
				}
			}
		}

		if (touchexit || (obflags & EXIT))
		{
			*nextobj = obj | doubleclick;
			return FALSE;
		}
		if (editable)
			return TRUE;
	}

	*nextobj = 0;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int FormKeybd(OBJECT *tree, int edit_obj, int next_obj, int kr, int kstate, int *onext_obj, int *okr)
{
	/* XXX order of loads different */
	unsigned int scancode;
	int obj;
	int ret;

	scancode = kr & 0xff00;
	scancode >>= 8;
	
	/* cntl-cursor down or return? */
	if (scancode == 0x72 || scancode == 0x1c)
	{
		obj = find_next(tree, edit_obj, -3);
		*onext_obj = obj;
		*okr = 0;
		if (edit_obj != obj)
		{
			FormButton(tree, obj, 1, &next_obj);
			return FALSE;
		}
		scancode = 0x0f;
	}
	if (scancode == 0x47)
	{
		if (kstate & (K_LSHIFT | K_RSHIFT))
			obj = find_next(tree, count_objects(tree), -1);
		else
			obj = find_next(tree, ROOT, -2);
		*onext_obj = obj;
		*okr = 0;
		return TRUE;
	} else if (((scancode == 0x0f) & ((kstate & (K_LSHIFT | K_RSHIFT)) == 0)) ||
		scancode == 0x50)
	{
		obj = find_next(tree, edit_obj, -2);
		*onext_obj = obj;
		*okr = 0;
		return TRUE;
	} else if (scancode == 0x48 || scancode == 0x0f)
	{
		obj = find_next(tree, edit_obj, -1);
		*onext_obj = obj;
		*okr = 0;
		return TRUE;
	}
	if ((kr & 0xff) != 0)
	{
		*okr = kr;
		return TRUE;
	}
	obj = find_button(tree, edit_obj, kr);
	*onext_obj = obj;
	*okr = 0;
	if (edit_obj == obj)
	{
		*okr = kr;
		return TRUE;
	}
	ret = FormButton(tree, obj, 1, &next_obj);
	/* XXX uses d1 in original */
	if (ret)
	{
		*onext_obj = edit_obj;
		*okr = 0;
	}
	return ret;
}

/*** ---------------------------------------------------------------------- ***/

void FormSetFormKeybd(FORMKEYFUNC fun)
{
	form_keybd_func = fun;
}

/*** ---------------------------------------------------------------------- ***/

FORMKEYFUNC FormGetFormKeybd(void)
{
	return form_keybd_func;
}

/*** ---------------------------------------------------------------------- ***/

int FormDo(OBJECT *tree, int startfld)
{
	return FormXDo(tree, &startfld);
}

/*** ---------------------------------------------------------------------- ***/

/*
 * XXX
 * d7 -> d4
 * d4 -> d5
 * d5 -> d6
 * d6 -> d7
 */
int FormXDo(OBJECT *tree, int *startfld)
{
	int event_flags;
	int next_obj;
	int edidx;
	int mox;
	int moy;
	int mstate;
	int kstate;
	int key;
	int clicks;
	int duration;
	int cont;
	int events;
	int obj;
	int x, y, w, h;
	ANIMBITBLK *info;
	
	event_flags = MU_KEYBD | MU_BUTTON;
	WindUpdate(BEG_UPDATE);
	obj = find_animimage(tree);
	if (obj != -1)
	{
		info = (ANIMBITBLK *)tree[obj].ob_spec.userblk->ub_parm;
		
		event_flags |= MU_TIMER;
		duration = info->Durations[info->Current];
		objc_offset(tree, obj, &x, &y);
		w = info->Images[0]->bi_wb << 3;
		h = info->Images[0]->bi_hl;
	}
	next_obj = find_first(tree, *startfld);
	obj = 0;
	cont = TRUE;
	while (cont)
	{
		if (next_obj != 0 && next_obj != obj)
		{
			obj = next_obj;
			next_obj = 0;
			FormEdit(tree, obj, 0, 0, &edidx, ED_INIT);
		}
		events = evnt_multi(event_flags,
			2, 1, 1,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			NULL,
			duration, 0,
			&mox, &moy, &mstate, &kstate, &key, &clicks);
		if (events & MU_TIMER)
		{
			ObjcDraw(tree, ROOT, MAX_DEPTH + 2, x, y, w, h);
			duration = info->Durations[info->Current];
		}
		if (events & MU_KEYBD)
		{
			if (key == SHFT_INS)
				read_number(&key);
			cont = form_keybd_func(tree, obj, next_obj, key, kstate, &next_obj, &key);
			if (key != 0)
			{
				/* BUG: te_pvalid might be shortened */
				if (get_tosversion() >= 0x102 ||
					((tree[obj].ob_flags & EDITABLE) &&
					 (tree[obj].ob_spec.tedinfo->te_pvalid[edidx] != '9' ||
					  (key & 0xff) != '_')))
				{
					FormEdit(tree, obj, key, kstate, &edidx, ED_CHAR);
				}
			}
		}
		if (events & MU_BUTTON)
		{
			next_obj = objc_find(tree, ROOT, MAX_DEPTH, mox, moy);
			if (next_obj == -1)
			{
				next_obj = 0;
				Bconout(2, 7);
			} else
			{
				cont = FormButton(tree, next_obj, clicks, &next_obj);
			}
		}
		
		if (!cont || (next_obj != 0 && next_obj != obj))
		{
			FormEdit(tree, obj, 0, 0, &edidx, ED_END);
		}
	}
	
	WindUpdate(END_UPDATE);
	form_keybd_func = FormKeybd;
	*startfld = obj;
	return next_obj;
}
