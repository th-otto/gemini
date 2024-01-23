#include "clip.h"

static void add_slash(char *filename)
{
	if (filename[strlen(filename)] != '\\')
		strcat(filename, "\\");
}

static void remove_slash(char *filename)
{
	size_t len;
	
	len = strlen(filename);
	if (filename[len - 1] == '\\')
		filename[len - 1] = '\0';
}

int ClipFindFile(const char *Extension, char *Filename)
{
}
