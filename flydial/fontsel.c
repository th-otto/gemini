/*
	@(#)FlyDial/fontsel.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include "fontsel.h"
#include <string.h>
#include <stdio.h>

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void drawname(LISTSPEC *list, int x, int y, int offset, GRECT *clip, int how)
{
	char *name = ((FONTINFO *)list->entry)->name;
	MFDB fdb;
	int dummy;
	int pxy[8];
	
	RectGRECT2VDI(clip, pxy);
	vs_clip(DialWk, TRUE, pxy);
	if (list != NULL)
	{
		if (how & 1)
		{
			vswr_mode(DialWk, MD_TRANS);
			vst_alignment(DialWk, 0, 5, &dummy, &dummy);
			vst_effects(DialWk, 0);
			v_gtext(DialWk, x - offset + HandXSize, y, name);
		}
		if (list->flags.selected || ((how == 0) & 1))
		{
			fdb.fd_addr = NULL;
			memcpy(&pxy[4], &pxy[0], 4 * sizeof(pxy[0]));
			vro_cpyfm(DialWk, D_INVERT, pxy, &fdb, &fdb);
		}
	}
	vs_clip(DialWk, FALSE, pxy);
}

/*** ---------------------------------------------------------------------- ***/

static void drawsize(LISTSPEC *list, int x, int y, int offset, GRECT *clip, int how)
{
	MFDB fdb;
	int dummy;
	int pxy[8];
	char buf[8];
	
	RectGRECT2VDI(clip, pxy);
	vs_clip(DialWk, TRUE, pxy);
	if (list != NULL)
	{
		if (how & 1)
		{
			sprintf(buf, " %2d", (int)(long)list->entry);
			vswr_mode(DialWk, MD_TRANS);
			vst_alignment(DialWk, 0, 5, &dummy, &dummy);
			vst_effects(DialWk, 0);
			v_gtext(DialWk, x - offset + HandXSize, y, buf);
		}
		if (list->flags.selected || ((how == 0) & 1))
		{
			fdb.fd_addr = NULL;
			memcpy(&pxy[4], &pxy[0], 4 * sizeof(pxy[0]));
			vro_cpyfm(DialWk, D_INVERT, pxy, &fdb, &fdb);
		}
	}
	vs_clip(DialWk, FALSE, pxy);
}

/*** ---------------------------------------------------------------------- ***/

static LISTSPEC *AllocSizes(FONTWORK *fw, int fontid, int count)
{
	LISTSPEC *entry;
	int *sizes;
	int text_attr[10];
	int dummy;
	int i;
	int size;
	
	i = 0; /* FIXME: not needed */
	sizes = (int *)calloc(count, sizeof(*sizes));
	if (sizes == NULL)
		return NULL;
	vqt_attributes(fw->handle, text_attr);
	vst_font(fw->handle, fontid);
	size = count - 1;
	if (!FontIsFSM(fw, fontid))
	{
		while (size > 0)
		{
			size = FontSetPoint(fw, fw->handle, fontid, size, &dummy, &dummy, &dummy, &dummy);
			if (size > 0)
			{
				if (sizes[size] != 0)
					break;
				sizes[size] = TRUE;
			}
			size--;
		}
	} else
	{
		sizes[9] = sizes[10] = sizes[12] = sizes[14] = sizes[18] = sizes[20] = sizes[24] = sizes[27] = TRUE;
	}
	entry = (LISTSPEC *)calloc(count, sizeof(*entry));
	if (entry == NULL)
	{
		free(sizes);
		return NULL; /* BUG: skips reset of text attributes below */
	}
	for (size = i = 0; size < count; size++)
	{
		if (sizes[size] != 0)
		{
			entry[i].entry = (void *)(long)size;
			entry[i].flags.selected = FALSE; /* FIXME: already zeroed above */
			entry[i].next = NULL;
			if (i != 0)
				entry[i - 1].next = &entry[i];
			i++;
		}
	}
	free(sizes);
	entry = (LISTSPEC *)realloc(entry, i * sizeof(*entry));
	vst_font(fw->handle, text_attr[0]);
	FontSetPoint(fw, fw->handle, text_attr[0], text_attr[7], &dummy, &dummy, &dummy, &dummy);
	
	return entry;
}

/*** ---------------------------------------------------------------------- ***/

static LISTSPEC *AllocFontList(FONTINFO *list, int fontid, int proportional)
{
	int i, count, fonts, j;
	LISTSPEC *entry;
	
	for (count = i = 0; list[i].id != -1; i++)
	{
		if (proportional || !list[i].flags.isprop)
			count++;
	}
	fonts = i;
	
	entry = (LISTSPEC *)calloc(count, sizeof(*entry));
	if (entry == NULL)
		return NULL;
	for (j = i = 0; i < fonts; i++)
	{
		if (proportional || !list[i].flags.isprop)
		{
			entry[j].flags.selected = FALSE;
			if (list[i].id == fontid)
				entry[j].flags.selected = TRUE;
			entry[j].entry = &list[i];
			entry[j].next = &entry[j + 1];
			j++;
		}
	}
	entry[count - 1].next = NULL;
	return entry;
}

/*** ---------------------------------------------------------------------- ***/

void FontShowFont(FONTWORK *f, OBJECT *tree, int frame, int font, int size, char *teststring)
{
	MFDB fdb;
	int text_attr[10];
	int dummy;
	int x, y;
	int pxy[8];
	
	fdb.fd_addr = NULL;
	vqt_attributes(f->handle, text_attr);
	vst_font(f->handle, font);
	FontSetPoint(f, f->handle, font, size, &dummy, &dummy, &dummy, &dummy);
	vst_alignment(f->handle, 0, 3, &dummy, &dummy);
	ObjcOffset(tree, frame, &x, &y);
	RectAES2VDI(x, y, tree[frame].ob_width, tree[frame].ob_height, &pxy[0]);
	vs_clip(f->handle, TRUE, pxy);
	GrafMouse(M_OFF, NULL);
	memcpy(&pxy[4], &pxy[0], 4 * sizeof(pxy[0]));
	vro_cpyfm(f->handle, ALL_WHITE, pxy, &fdb, &fdb);
	v_justified(f->handle, x, y + tree[frame].ob_height - 1, teststring, 0, 0, 0);
	GrafMouse(M_ON, NULL);
	vs_clip(f->handle, FALSE, pxy);
	vst_font(f->handle, text_attr[0]);
	FontSetPoint(f, f->handle, text_attr[0], text_attr[7], &dummy, &dummy, &dummy, &dummy);
	vst_alignment(f->handle, text_attr[3], text_attr[4], &dummy, &dummy);
}

/*** ---------------------------------------------------------------------- ***/

void FontSelectSize(LISTINFO *l, int *size, int redraw)
{
	LISTSPEC *list;
	long entry;
	int mindiff;
	
	list = l->list;
	mindiff = 1000;
	entry = 0;
	for ( ; list != NULL; list = list->next)
	{
		int diff = abs(*size - (int)(long)list->entry);
		if (diff < mindiff)
			mindiff = diff;
	}
	for (list = l->list; list != NULL; list = list->next, entry++)
	{
		int diff = abs(*size - (int)(long)list->entry);
		if (diff == mindiff)
		{
			mindiff = 0;
			list->flags.selected = TRUE;
			*size = (int)(long)list->entry;
			if (redraw)
			{
				ListUpdateEntry(l, entry);
				ListVScroll(l, entry - l->startindex);
			}
		} else
		{
			if (list->flags.selected)
			{
				list->flags.selected = FALSE;
				if (redraw)
				{
					ListUpdateEntry(l, entry);
				}
			}
		}
	}	
}

/*** ---------------------------------------------------------------------- ***/

int FontSelInit(FONTSELINFO *f, FONTWORK *fw, OBJECT *tree,
	int fontbox, int fontbgbox, int pointbox,
	int pointbgbox, int showbox, char *teststring,
	int proportional, int *actfont, int *actsize)
{
	int stdwidth;
	int size;
	
	stdwidth = HandXSize * 33;
	f->fw = fw;
	f->test = teststring;
	f->tree = tree;
	f->fontbox = fontbox;
	f->fontbgbox = fontbgbox;
	f->pointbox = pointbox;
	f->pointbgbox = pointbgbox;
	f->showbox = showbox;
	if (f->fw->list == NULL)
		return FALSE;
	ListStdInit(&f->L, tree, fontbox, fontbgbox, drawname, AllocFontList(f->fw->list, *actfont, proportional),
		tree[fontbox].ob_width == stdwidth ? 0 : stdwidth, 0, 1);
	f->L.hstep = 8;
	ListInit(&f->L);
	ListScroll2Selection(&f->L);
	ListStdInit(&f->P, tree, pointbox, pointbgbox, drawsize, AllocSizes(fw, *actfont, 50),
		0, 0, 1);
	size = *actsize;
	FontSelectSize(&f->P, &size, FALSE);
	if (!FontIsFSM(fw, *actfont))
		*actsize = size;
	ListInit(&f->P);
	ListScroll2Selection(&f->P);
	
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int FontClFont(FONTSELINFO *f, int clicks, int *font, int *size)
{
	int ret;
	int asize;
	
	asize = *size;
	ret = (int)ListClick(&f->L, clicks);
	if (ret >= 0)
	{
		FONTINFO *info = (FONTINFO *)(ListIndex2List(f->L.list, ret)->entry);
		ret = info->id;
		if (ret != *font)
		{
			*font = ret;
			free(f->P.list);
			ListExit(&f->P);
			ListStdInit(&f->P, f->tree, f->pointbox, f->pointbgbox, drawsize, AllocSizes(f->fw, *font, 50),
				0, 0, 1);
			ListInit(&f->P);
			FontSelectSize(&f->P, &asize, FALSE);
			if (!FontIsFSM(f->fw, *font))
				*size = asize;
			ListScroll2Selection(&f->P);
			ListDraw(&f->P);
			FontShowFont(f->fw, f->tree, f->showbox, *font, *size, f->test);
		}
	}
	return ret;
}

/*** ---------------------------------------------------------------------- ***/

int FontClSize(FONTSELINFO *f, int clicks, int *font, int *size)
{
	int ret;
	
	ret = (int)ListClick(&f->P, clicks);
	if (ret >= 0)
	{
		*size = (int)(long)f->P.list[ret].entry;
		FontShowFont(f->fw, f->tree, f->showbox, *font, *size, f->test);
	}
	return ret;
}

/*** ---------------------------------------------------------------------- ***/

void FontSelDraw(FONTSELINFO *f, int font, int size)
{
	ListDraw(&f->L);
	ListDraw(&f->P);
	FontShowFont(f->fw, f->tree, f->showbox, font, size, f->test);
}

/*** ---------------------------------------------------------------------- ***/

void FontSelExit(FONTSELINFO *f)
{
	free(f->L.list);
	free(f->P.list);
	ListExit(&f->L);
	ListExit(&f->P);
}
