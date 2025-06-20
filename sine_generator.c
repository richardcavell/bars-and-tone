/* sine_generator.c
 *
 * A program by Richard Cavell
 * richardcavell@mail.com
 *
 * June 2025
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

const char *fname = "sine_table.asm";
const int length = 190; /* Number of numbers to output */
const double pi = 3.1415926535897931;

int main(int argc, char *argv[])
{
	FILE *fp = NULL;
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

	fprintf(fp, "* This file was generated by sine_generator.c\n");
	fprintf(fp, "* Which was written by Richard Cavell\n");
	fprintf(fp, "* in June 2025.\n");
	fprintf(fp, "*\n");
	fprintf(fp, "* https://github.com/richardcavell/bars-and-tone\n");
	fprintf(fp, "\n");

	for (i = 0;i < length; ++i)
	{
		double x = ((double) i) / length * 2 * pi;
		double y = sin(x) * 128 + 128;
		int val = (int) y & 0xfc;

		fprintf(fp, "\tFCB %u\n", val); /* A value from 0 to 252 */
	}

	if (fclose(fp) == EOF)
	{
		fprintf(stderr, "%s%s%c", "Couldn't close file ", fname, '\n');
		exit(EXIT_FAILURE);
	}

	return EXIT_SUCCESS;
}
