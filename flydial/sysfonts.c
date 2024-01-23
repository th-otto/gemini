/*
	sysfonts.c
	(c)1995 by MAXON-Computer
	Julian F. Reschke, 23. Juli 1995
	IDs und Groessenn der Systemzeichensaettze erfragen
*/

#include <stdio.h>

#include <aes.h>
#include <vdi.h>

static int load_font(int vdihandle, int fontid)
{
	int loaded = 0;

	if (fontid != vst_font(vdihandle, fontid) && vq_gdos())
	{
		vst_load_fonts(vdihandle, 0);
		loaded = 1;
	}
	return loaded;
}

void FontAESInfo(int vdihandle, int *pfontsloaded, int *pnormid, int *pnormheight, int *piconid, int *piconheight)
{
	vst_load_fonts(vdihandle, 0);
	loaded = 1;
	static int done = 0;
	static int normid, normheight;
	static int iconid, iconheight;

	int fontsloaded = 0;

	if (!done)
	{
		int aeshandle, cellwidth, cellheight;
		int dummy;

		wind_update(DEG_UPDATE);

		aeshandle = graf_handle(&cellwidth, &cellheight, &dummy, &dummy);
		if (_GemParBlk.global[0] >= 0x0400 || 0 == appl_find("?AGI\0\0\0\0"))
		{
			/* zunaechst versuchen wir, die Fontids beim AES zu erfragen */

			appl_getinfo(0, &normheight, &tnormid, &dummy, &dummy);

			appl_getinfo(1, &conheight, &iconid, &dummy, &dummy);
		} else
		{

			/* Hier fragen wir den aktuellen Font
			   der AES-Workstation ab. Dies ist ein Hack,
			   aber es funktioniert mit den unterschiedlichen 
			   Auto-Ordner-Tools und ist eben nur bis AES
			   3.99 noetig. Au¯rdem gehen wir davon aus, dass fuer
			   beide Textgroessen dieselbe Schrift verwendet wird */

			static OBJECT dum_ob = { 0, -1, -1, G_BOXCHAR,
				LASTOB, 0, 0X20001100L, 0, 0, 8, 16
			};

			int attrib[10];

			objc_draw(&dum_ob, 0, 1, 0, 0, 1, 1);

			vqt_attributes(aeshandle, attrib);

			iconid = normid = attrib[0];

			normheight = attrib[7];

			iconheight = 4;

		}

		/* Nun haben wir fuer beide Fonts die Id

		   und die Pixelgroesse (Parameter fuer vst_height).

		   Nun sorgen wir dafuer, da¯beide Fonts auch wirklich 
		   auf der aktuellen virtuellen Workstation geladen

		   (wir gehen davon, da¯sie generell verfuegbar sind. 
		   haette sie uns das AES ja nicht melden duerfen). */

		fontsloaded |= load_font(vdihandle, normid);
		fontsloaded |= load_font(vdihandle, iconid);

		/* Systemfont in Standardgroesse einstellen */

		vst_font(vdihandle, normid);

		vst_height(vdihandle, normheight, &dummy, &dummy, &dummy, &dummy);

		wind_update(END_UPDATE);
		done = 1;

	}

	/* Rueckgabewerte */

	if (pnormid)
		*pnormid = normid;

	if (pnormheight)
		*pnormheight = normheight;
	if (piconid)
		*piconid = iconid;

	if (piconheight)
		*piconheight = iconheight;
	if (pfontsloaded)
		*pfontsloaded = fontsloaded;
}
