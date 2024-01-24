/*
	@(#)FlyDial/clip.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include "clip.h"
#include <stdlib.h>

#define EACCDN -36

#ifndef NULL
#define NULL ((void *)0L)
#endif

#ifndef SuperToUser
#define SuperToUser(s) Super(s)
#endif

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void add_slash(char *filename)
{
	size_t len;
	
	len = strlen(filename) - 1;
	if (filename[len] != '\\')
		strcat(filename, "\\");
}

/*** ---------------------------------------------------------------------- ***/

static void remove_slash(char *filename)
{
	int len;
	
	len = (int)strlen(filename);
	if (filename[len - 1] == '\\')
		filename[len - 1] = '\0';
}

/*** ---------------------------------------------------------------------- ***/

int ClipFindFile(const char *Extension, char *Filename)
{
	char *env;
	int err;
	
	scrp_read(Filename);
	if (*Filename == '\0')
	{
		env = getenv("CLIPBRD");
		if (env != NULL)
		{
			strcpy(Filename, env);
		} else
		{
			long oldsp;
			short bootdev;
			char clipbrd[] = "#:\\CLIPBRD\\";
			
			oldsp = Super(NULL);
			bootdev = *((short *)0x446L) & 0xff;
			SuperToUser((void *)oldsp);
			clipbrd[0] = bootdev + 'A';
			strcpy(Filename, clipbrd);
		}
		scrp_write(Filename);
		graf_mouse(HOURGLASS, NULL);
		remove_slash(Filename);
		err = (int)Dcreate(Filename);
		add_slash(Filename);
		graf_mouse(ARROW, NULL);
		if (err < 0 && err != EACCDN)
		{
			scrp_write("");
			return FALSE;
		}
	}
	add_slash(Filename);
	strcat(Filename, "SCRAP.");
	strcat(Filename, Extension);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int ClipClear(const char *not)
{
	DTA newDTA;
	DTA *oldDTA;
	char filename[128];
	char *end;
	int err;
	
	if (ClipFindFile("*", filename))
	{
		oldDTA = Fgetdta();
		Fsetdta(&newDTA);
		end = &filename[(int)strlen(filename) - 1];
		err = Fsfirst(filename, 0);
		while (err == 0)
		{
			strcpy(end, newDTA.d_fname + 6);
			if (not == NULL || strncmp(newDTA.d_fname + 6, not, 3) != 0)
				Fdelete(filename);
			err = Fsnext();
		}
		Fsetdta(oldDTA);
		return TRUE;
	}
	return FALSE;
}
