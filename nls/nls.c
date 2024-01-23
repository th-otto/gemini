#include "nls.h"
#include <tos.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define EACCDN -36

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE (!FALSE)
#endif

#ifndef NULL
#define NULL ((void *)0L)
#endif

static int initialized = 0;
static void *(*malloc_function)(size_t n);
static void (*free_function)(void *p);
static char *textfile;

#define NLS_ID "Native Language Support (bin)"


struct msg {
	const char *section;
	const char *text;
	long count;
	struct msg *next;
};

static struct msg *textarr;

struct msg *NlsFix(char *text);

int NlsInit(const char *TextFileName, void *MallocFunction, void *FreeFunction)
{
	int fd;
	long filesize;
	
	if (initialized)
		return FALSE;
	
	malloc_function = MallocFunction;
	free_function = FreeFunction;
	fd = (int)Fopen(TextFileName, FO_READ);
	if (fd < 0)
		return FALSE;
	filesize = Fseek(0, fd, SEEK_END);
	Fseek(0, fd, SEEK_SET);
	textfile = malloc_function(filesize);
	if (textfile == NULL)
	{
		Fclose(fd);
		return FALSE;
	}
	if (Fread(fd, filesize, textfile) != filesize)
	{
		free_function(textfile);
		Fclose(fd);
		return FALSE;
	}
	Fclose(fd);
	textarr = NlsFix(textfile);
	if (textarr == NULL)
	{
		free_function(textfile);
		return FALSE;
	}
	initialized = TRUE;
	return TRUE;
}


void NlsExit(void)
{
	if (initialized)
	{
		free_function(textfile);
		initialized = FALSE;
	}
}


const char *NlsGetStr(const char *Section, int number)
{
	struct msg *ptr;
	struct msg *prev;
	const char *str;

	if (!initialized)
		return NULL;
	ptr = textarr;
	for (;;)
	{
		int found;

		prev = ptr;
		found = strcmp(Section, prev->section) == 0;
		ptr = prev->next;
		if (found || ptr == NULL)
		{
			if (!found || prev->count <= number)
				break;
			str = prev->text;
			while (number != 0)
			{
				while (*str != '\0')
					str++;
				str++;
				number--;
			}
			return str;
		}
	}
	
	return "String missing!";
}


static int NlsFixSection(struct msg *msg, char *start)
{
	if (msg->section != 0)
		msg->section = start + (long)msg->section;
	if (msg->count != 0)
		msg->text = start + (long)msg->text;
	if (msg->next != 0)
		msg->next = (struct msg *)(start + (long)msg->next);
	if (msg->section <= start ||
		(char *)msg->next <= start ||
		(msg->count != 0 && msg->text <= start))
		return FALSE;
	return TRUE;
}


struct msg *NlsFix(char *text)
{
	size_t len;
	struct msg *msg;
	struct msg *ptr;
	
	len = strlen(NLS_ID);
	if (len & 1)
		len++;
	if (strncmp(text, NLS_ID, len) != 0)
		return NULL;
	msg = (struct msg *)(text + len);
	ptr = msg;
	while (ptr && NlsFixSection(ptr, text))
		ptr = ptr->next;
	return msg;
}
