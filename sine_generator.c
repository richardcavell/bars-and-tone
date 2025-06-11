/* sine_generator.c
 *
 * A program by Richard Cavell
 * June 2025
 * richardcavell@mail.com
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

const char *fname = "sine_table.bin";
const int length = 190; /* Number of numbers to output */
const double pi = 3.1415926535897931;

int main(int argc, char *argv[])
{
	FILE *fp = NULL;
 	int val = 0;
	int i = 0;

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

	for (i = 0;i < length; ++i)
	{
		double d_val = sin((i / (double) length) * 2 * pi);
		val = (int) ((d_val + 0.5)*255) + 0x80;	/* 0x80 is the bias */
		fprintf(fp, "%c", val);
	}

	if (fclose(fp) == EOF)
	{
		fprintf(stderr, "%s%s%c", "Couldn't close file ", fname, '\n');
		exit(EXIT_FAILURE);
	}

	return EXIT_SUCCESS;
}
