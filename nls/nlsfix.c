/*
 * @(#)Language/Nlsfix.c
 * @(#)Stefan Eissing, 14. Januar 1991
 */

#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <tos.h>

#include "nlsdef.h"
#include "nlsfix.h"

#ifndef FALSE
#define FALSE	0
#define TRUE	(!FALSE)
#endif


static int fixSection(BINSECTION *sec, char *start)
{
	if (sec->SectionTitle != 0)
		sec->SectionTitle = start + (long)sec->SectionTitle;
	if (sec->StringCount != 0)
		sec->SectionStrings = start + (long)sec->SectionStrings;
	if (sec->NextSection != 0)
		sec->NextSection = (BINSECTION *)(start + (long)sec->NextSection);

	if (sec->SectionTitle <= start ||
		(char *)sec->NextSection <= start ||
		(sec->StringCount != 0 && sec->SectionStrings <= start))
		return FALSE;
	return TRUE;
}


BINSECTION *NlsFix(char *TextFile)
{
	size_t len;
	BINSECTION *firstSection, *Section;
	
	len = strlen(NLS_BIN_MAGIC);
	if (len & 1)
		++len;

	if (strncmp(TextFile, NLS_BIN_MAGIC, len) != 0)
		return NULL;

	firstSection = (BINSECTION *)(TextFile + len);

	Section = firstSection;
	while (Section && fixSection(Section, TextFile))
		Section = Section->NextSection;

	return firstSection;
}
