/*
	@(#)FlyDial/font.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include <string.h>

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int is_proportional(int handle, int fontid)
{
	int width;
	int text_attr[10];
	int min_ade;
	int max_ade;
	int distances[5];
	int effects[3];
	int dummy;
	int proportional;
	int firstwidth;
	int i;
	
	vqt_attributes(handle, text_attr);
	vst_font(handle, fontid);
	vst_point(handle, 20, &dummy, &dummy, &dummy, &dummy);
	vqt_fontinfo(handle, &min_ade, &max_ade, distances, &dummy, effects);
	proportional = FALSE;
	firstwidth = -1;
	if (min_ade == 0)
		min_ade = 1;
	for (i = min_ade; i <= max_ade && proportional == 0; i++)
	{
		vqt_width(handle, i, &width, &dummy, &dummy);
		if (width != 0)
		{
			if (firstwidth == -1)
				firstwidth = width;
			else if (width != firstwidth)
				proportional = TRUE;
			else
				proportional = FALSE;
		}
	}
	vst_font(handle, text_attr[0]);
	vst_point(handle, text_attr[7], &dummy, &dummy, &dummy, &dummy);
	return proportional;
}

/*** ---------------------------------------------------------------------- ***/

static int is_vector(int handle, int fontid)
{
	int text_attr[10];
	int vector;
	
	vqt_attributes(handle, text_attr);
	vst_font(handle, fontid);
	vector = vst_rotation(handle, 1) == 1;
	vst_rotation(handle, 0);
	vst_font(handle, text_attr[0]);
	return vector;
}

/*** ---------------------------------------------------------------------- ***/

void FontLoad(FONTWORK *fwork)
{
	if (!fwork->loaded)
	{
		/* WTF? AES version does not tell anything about VDI */
		if (_GemParBlk.global[0] == 0x210 || vq_gdos())
			fwork->addfonts = vst_load_fonts(fwork->handle, 0);
		fwork->loaded = TRUE;
		fwork->list = NULL;
	}
}

/*** ---------------------------------------------------------------------- ***/

void FontUnLoad(FONTWORK *fwork)
{
	if (fwork->loaded)
	{
		/* WTF? AES version does not tell anything about VDI */
		if (_GemParBlk.global[0] == 0x210 || vq_gdos())
			vst_unload_fonts(fwork->handle, 0);
		fwork->loaded = FALSE;
		if (fwork->list != NULL)
		{
			dialfree(fwork->list);
			fwork->list = NULL;
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

int FontGetList(FONTWORK *fwork, int test_prop, int test_fsm)
{
	int numfonts;
	FONTINFO *list;
	int i;
	char *p;

	if (!fwork->loaded)
		return FALSE;
	if (fwork->list != NULL)
		return TRUE;
	numfonts = fwork->sysfonts + fwork->addfonts;
	if (numfonts == 0)
		return FALSE;
	list = (FONTINFO *)dialmalloc((numfonts + 1) * sizeof(*list));
	if (list == NULL)
		return FALSE;
	memset(list, 0, (numfonts + 1) * sizeof(*list));
	for (i = 0; i < numfonts; i++)
	{
		list[i].id = vqt_name(fwork->handle, i + 1, list[i].name);
		list[i].name[32] = '\0';
		while (strstr(list[i].name, "  ") != NULL)
		{
			p = strstr(list[i].name, "  ");
			strcpy(p, p + 1);  /* FIXME: use memmove for overlapping copy */
		}
		/* FIXME: use id, not name */
		if (strcmp(list[i].name, "6x6 system font") == 0)
			strcpy(list[i].name, "System font");
		list[i].flags.isprop = test_prop ? is_proportional(fwork->handle, list[i].id) : TRUE;
		list[i].flags.isfsm = test_fsm ? is_vector(fwork->handle, list[i].id) : FALSE;
	}
	list[numfonts].id = -1;
	fwork->list = list;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

/* FIXME: why extra handle here? */
int FontSetPoint(FONTWORK *fwork, int handle, int id, int point, int *cw, int *ch, int *lw, int *lh)
{
	int i;
	FONTINFO *list;
	
	for (i = 0, list = fwork->list; list[i].id != -1; i++)
	{
		if (list[i].id == id)
		{
			if (list[i].flags.isfsm)
				return vst_arbpt(handle, point, cw, ch, lw, lh);
			else
				return vst_point(handle, point, cw, ch, lw, lh);
		}
	}
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

int FontIsFSM(FONTWORK *fwork, int id)
{
	int i;
	FONTINFO *list;
	
	for (i = 0, list = fwork->list; list[i].id != -1; i++)
	{
		if (list[i].id == id)
			return list[i].flags.isfsm;
	}
	return FALSE;
}
