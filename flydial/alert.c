/*
	@(#)FlyDial/alert.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include <string.h>
#include "flydial.h"

#define NUM_STRINGS 24

static char *strptrs[NUM_STRINGS];
static ANIMBITBLK animinfo;
static int screen_width;
static int alert_width;
static int icon_width;

static int dial_success = TRUE;
/* FIXME: should be static */
/* FIXME: not enough OBJECTs for 5 strings & 3 buttons */
OBJECT AlertTree[] = {
	{ -1,  1,  2, G_BOX,                0x0000, 0x0010, { 0x00021100L }, 0, 0, 55, 12 },
	{  2, -1, -1, G_IMAGE,              0x0000, 0x0000, { 0x00000000L }, 1, 1, 0, 0 },
	{  0, -1, -1, G_IBOX | (17 << 8),   0x0040, 0x0012, { 0x00fe1101L }, 0, 0, 1, 1 },
	{  0, -1, -1, G_BUTTON | (18 << 8), 0x0005, 0x0000, { 0x00000000L }, 0, 0, 1, 1 },
	{  0, -1, -1, G_BUTTON | (18 << 8), 0x0005, 0x0000, { 0x00000000L }, 0, 0, 0, 0 },
	{  0, -1, -1, G_BUTTON | (18 << 8), 0x0005, 0x0000, { 0x00000000L }, 0, 0, 0, 0 },
	{  0, -1, -1, G_BUTTON | (18 << 8), 0x0005, 0x0000, { 0x00000000L }, 0, 0, 0, 0 },
	{  0, -1, -1, G_BUTTON | (18 << 8), 0x0005, 0x0000, { 0x00000000L }, 0, 0, 0, 0 }
};

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static const char *split_string(const char *str)
{
	const char *end;
	const char *p;
	
	end = &str[alert_width];
	p = strchr(str, '|');
	if (p != NULL && (int)(p - str) < alert_width)
		return p;
	if (strlen(str) < alert_width)
		return NULL;
	while (end != str)
	{
		if (*end == ' ' || *end == '-')
			return end;
		end--;
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

int DialAlert(BITBLK *Image, const char *String, int Default, const char *Buttons)
{
	int max_buttonlen;
	int y;
	int tail;
	char *strbuf;
	DIALINFO dinfo;
	int max_strlen;
	int num_strings;
	char *button_strbuf;
	char *ptr;
	const char *str;
	const char *end;
	int obj;
	int len;
	int tmp;

	max_buttonlen = 0;
	max_strlen = 0;
	tail = 1;
	if (strlen(Buttons) > 100)
		return -1;
	if (strlen(String) > 700)
		return -1;
	strbuf = dialmalloc(100 + 700);
	if (strbuf == NULL)
		return -1;
	button_strbuf = strbuf + 700;
	WindUpdate(BEG_UPDATE);
	WindUpdate(BEG_MCTRL);
	strcpy(strbuf, String);
	strcpy(button_strbuf, Buttons);
	{
		int dummy;
		int w;

		HandScreenSize(&dummy, &dummy, &w, &dummy);
		screen_width = w / HandXSize;
		screen_width -= 6;
		if (screen_width > 60)
			screen_width = 60;
	}
	AlertTree[1].ob_type = G_STRING;
	AlertTree[1].ob_spec.free_string = "";
	AlertTree[1].ob_width = 0;
	AlertTree[1].ob_height = 0;
	AlertTree[2].ob_width = 2;
	AlertTree[2].ob_height = 1;
	AlertTree[2].ob_spec.index = 0x00FE1101L;
	y = 0;
	icon_width = 0;
	if (Image != NULL)
	{
		if (Image == (BITBLK *)1)
		{
			AlertTree[1].ob_type = G_ANIMIMAGE;
			AlertTree[1].ob_spec.bitblk = (BITBLK *)&animinfo;
			Image = *animinfo.Images;
		} else
		{
			AlertTree[1].ob_type = G_IMAGE;
			AlertTree[1].ob_spec.bitblk = Image;
		}
		icon_width = Image->bi_wb << 3;
		y = Image->bi_hl;
	}
	AlertTree[1].ob_x = AlertTree[1].ob_y = 1;
	alert_width = screen_width - icon_width / HandXSize;
	AlertTree[ROOT].ob_width = screen_width;
	AlertTree[ROOT].ob_height = 12;
	AlertTree[ROOT].ob_x = 0;
	obj = 3;
	ptr = strtok(button_strbuf, "|");
	while (ptr != NULL && obj < 8)
	{
		tail = obj;
		AlertTree[ROOT].ob_tail = tail;
		AlertTree[obj - 1].ob_next = obj;
		AlertTree[obj].ob_next = ROOT;
		AlertTree[obj].ob_height = 1;
		AlertTree[obj].ob_flags = SELECTABLE | EXIT | (obj == Default + 3 ? DEFAULT : 0);
		AlertTree[obj].ob_spec.free_string = ptr;
		AlertTree[obj].ob_state = NONE;
		if (strlen(ptr) > max_buttonlen)
			max_buttonlen = (int)strlen(ptr);
		ptr = strtok(NULL, "|");
		obj++;
	}
	if (max_buttonlen < 5)
		max_buttonlen = 5;
	AlertTree[obj - 1].ob_flags |= LASTOB;
	strptrs[0] = strbuf;
	str = String;
	obj = 0;
	while (obj < (NUM_STRINGS - 1))
	{
		end = split_string(str);
		if (end == NULL)
		{
			if (strlen(str) < alert_width)
			{
				strcpy(strptrs[obj], str);
				strptrs[obj + 1] = NULL;
				obj = NUM_STRINGS;
				continue;
			}
			strncpy(strptrs[obj], str, alert_width - 1);
			strptrs[obj][alert_width - 1] = '\0';
			obj++;
			strptrs[obj] = strptrs[obj - 1] + alert_width;
			str = &str[alert_width - 1];
		} else
		{
			len = (int)(end - str);
			strncpy(strptrs[obj], str, len);
			if (*end == '-')
			{
				strptrs[obj][len] = '-';
				len++;
			}
			strptrs[obj][len] = '\0';
			str = end + 1;
			obj++;
			strptrs[obj] = strptrs[obj - 1] + len + 2;
		}
	}
	
	obj = 0;
	while (obj <= (NUM_STRINGS - 1))
	{
		if (strptrs[obj] == NULL)
		{
			num_strings = obj;
			break;
		}
		len = (int)strlen(strptrs[obj]);
		if (len > max_strlen)
			max_strlen = len;
		obj++;
	}
	tmp = num_strings + 5;
	AlertTree[ROOT].ob_height = tmp;
	if ((tmp - 2) * HandYSize < y)
		AlertTree[ROOT].ob_height = y / HandYSize + 2;
	tmp = (screen_width - alert_width) + max_strlen + 4;
	AlertTree[ROOT].ob_width = tmp;
	if ((max_buttonlen + 3) * (tail - 2) + 6 > tmp)
		AlertTree[ROOT].ob_width = (max_buttonlen + 3) * (tail - 2) + 6;
	if (AlertTree[ROOT].ob_width & 1)
		AlertTree[ROOT].ob_width++;
	for (obj = 3; obj <= tail; obj++)
	{
		AlertTree[obj].ob_width = max_buttonlen + 1;
		AlertTree[obj].ob_x = AlertTree[ROOT].ob_width - (tail - obj + 1) * (max_buttonlen + 3);
		AlertTree[obj].ob_y = AlertTree[ROOT].ob_height - 2;
	}
	AlertTree[2].ob_x = AlertTree[ROOT].ob_width - AlertTree[2].ob_width + AlertTree[ROOT].ob_x;
	for (obj = 0; obj < 8; obj++)
	{
		rsrc_obfix(AlertTree, obj);
	}
	ObjcTreeInit(AlertTree);
	DialCenter(AlertTree);
	if (RectOnScreen(AlertTree[ROOT].ob_x, AlertTree[ROOT].ob_y, AlertTree[ROOT].ob_width, AlertTree[ROOT].ob_height) == FALSE)
	{
		dialfree(strbuf);
		WindUpdate(END_MCTRL);
		WindUpdate(END_UPDATE);
		return -1;
	}
	if (DialStart(AlertTree, &dinfo) == FALSE)
		dial_success = FALSE;
	DialDraw(&dinfo);
	GrafMouse(M_OFF, NULL);
	{
		int dummy;

		vst_alignment(DialWk, 0, 0, &dummy, &dummy);
		len = AlertTree[ROOT].ob_x + icon_width + HandXSize * 2;
		y = AlertTree[ROOT].ob_y + HandYSize * 2;
		
		for (obj = 0; obj < num_strings; obj++)
		{
			switch (strptrs[obj][0])
			{
			case '\001':
				v_gtext(DialWk, (((max_strlen + 1 - (int)strlen(strptrs[obj])) * HandXSize) >> 1) + len, obj * HandYSize + y, strptrs[obj] + 1);
				break;
	
			case '\002':
				v_gtext(DialWk, (((max_strlen + 1 - (int)strlen(strptrs[obj])) * HandXSize)) + len, obj * HandYSize + y, strptrs[obj] + 1);
				break;
			
			default:
				v_gtext(DialWk, len, obj * HandYSize + y, strptrs[obj]);
				break;
			}
		}
	
		vst_alignment(DialWk, 0, 5, &dummy, &dummy);
	}
	GrafMouse(M_ON, NULL);
	
	{
		MFORM mform;
		int num;

		GrafGetForm(&num, &mform);
		GrafMouse(ARROW, NULL);
		obj = DialDo(&dinfo, NULL);
		GrafMouse(num, &mform);
		DialEnd(&dinfo);
		ObjcRemoveTree(AlertTree);
	}
	dialfree(strbuf);
	WindUpdate(END_MCTRL);
	WindUpdate(END_UPDATE);
	return obj - 3;
}

/*** ---------------------------------------------------------------------- ***/

int DialAnimAlert(BITBLK **Image, int *durations, const char *String, int Default, const char *Buttons)
{
	animinfo.Current = 0;
	animinfo.Images = Image;
	animinfo.Durations = durations;
	return DialAlert((BITBLK *)1, String, Default, Buttons);
}

/*** ---------------------------------------------------------------------- ***/

int DialSuccess(void)
{
	int ret = dial_success;
	dial_success = TRUE;
	return ret;
}
