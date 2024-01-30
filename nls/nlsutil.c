/*
 * @(#)Language/Nlsutil.c
 * @(#)Stefan Eissing, 29. Dezember 1990
*/

#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <tos.h>

#include "nlsdef.h"
#include "nls.h"
#include "nlsfix.h"

#define EACCDN -36

#ifndef FALSE
#define FALSE	0
#define TRUE	(!FALSE)
#endif

/*
 * Interne, lokale Variablen
 */
/* LangInit schon erfolgreich aufgerufen? */
static int initialized = FALSE;

/* Pointer fÅr malloc/free-Funktionen */
static void *(*NlsMalloc)(size_t n);
static void (*NlsFree)(void *ptr);

/* Pointer auf den Inhalt der geladenen Datei */
static char *TextBuffer;

/* Zeiger auf die erste Section */
static BINSECTION *FirstSection;


int NlsInit(const char *TextFileName, void *MallocFunction, void *FreeFunction)
{
	int fhandle;
	long fsize;
	
	if (initialized)
		return FALSE;
	
	NlsMalloc = MallocFunction;
	NlsFree = FreeFunction;

	fhandle = (int)Fopen(TextFileName, FO_READ);
	if (fhandle < 0)
		return FALSE;

	fsize = Fseek(0, fhandle, SEEK_END);
	Fseek(0, fhandle, SEEK_SET);

	TextBuffer = NlsMalloc(fsize);
	if (TextBuffer == NULL)
	{
		Fclose(fhandle);
		return FALSE;
	}

	if (Fread(fhandle, fsize, TextBuffer) != fsize)
	{
		NlsFree(TextBuffer);
		Fclose(fhandle);
		return FALSE;
	}
	Fclose(fhandle);

	FirstSection = NlsFix(TextBuffer);
	if (FirstSection == NULL)
	{
		NlsFree(TextBuffer);
		return FALSE;
	}

	initialized = TRUE;
	return TRUE;
}


void NlsExit(void)
{
	if (initialized)
	{
		NlsFree(TextBuffer);
		initialized = FALSE;
	}
}


const char *NlsGetStr(const char *Section, int Number)
{
	BINSECTION *sec, *nextsec;
	const char *str;
	int found;

	if (!initialized)
		return NULL;

	nextsec = FirstSection;
	do
	{
		sec = nextsec;
		found = strcmp(Section, sec->SectionTitle) == 0;
		nextsec = sec->NextSection;
	} while (!found && nextsec != NULL);

	if (found)
	{
		if (sec->StringCount > Number)
		{
			str = sec->SectionStrings;

			/* öberspringe Number Strings */
			while (Number != 0)
			{
				while (*str != '\0')
					++str;
				++str;
				Number--;
			}
			return str;
		}
	}

	return "String missing!";
}
