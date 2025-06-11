/* sine_generator.c
 *
 * A program by Richard Cavell
 * June 2025
 * richardcavell@mail.com
 */

#include <stdio.h>
#include <stdlib.h>

const char *fname = "sine_table.bin";

int main(int argc, char *argv[])
{
	FILE *fp = NULL;
/* 	int val = 0; */

	if (argc < 2)
	{
		fprintf(stderr, "%s", "You must provide an output filename\n");
		exit(EXIT_FAILURE);
	}

	fp = fopen(argv[1], "w");

	if (fp == NULL)
	{
		fprintf(stderr, "%s%s%c", "Couldn't open file ", fname, '\n');
		exit(EXIT_FAILURE);
	}

	fprintf(fp, "%c", 0);
	fprintf(fp, "%c", 100);
	fprintf(fp, "%c", 100);
	fprintf(fp, "%c", 100);
	fprintf(fp, "%c", 100);

	if (fclose(fp) == EOF)
	{
		fprintf(stderr, "%s%s%c", "Couldn't close file ", fname, '\n');
		exit(EXIT_FAILURE);
	}

	return EXIT_SUCCESS;
}
