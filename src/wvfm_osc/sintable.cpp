// reference: https://github.com/ZipCPU/cordic/blob/master/sw/sintable.cpp
// Creates a look-up table for computing sine values.
// Default values for phase bits = 8 and output bits = 24. Edit these values
// in main if needed.

#define _USE_MATH_DEFINES

#include <stdio.h>
#include <errno.h>
#include <math.h>

void sintable(const char* filename, int pw, int ow) {
	FILE* table_file;
	errno_t err;
	if ((err = fopen_s(&table_file, filename, "w")) != 0) {
		fprintf(stderr, "Cannot open file: %s for writing data.", filename);
		return;
	}
	int table_entries = (1 << pw); // 2^pw
	int nc = (ow + 3) / 4;
	long max_val = (1l << (ow - 1)) - 1l;
	for (int i = 0; i < table_entries; i++) {
		double ph;
		ph = 2 * M_PI * (double)i / (double)table_entries;
		long val = (long)max_val * sin(ph);
		if (i % 8 == 0) {
			fprintf(table_file, "%s@%08x ", (i != 0) ? "\n" : "", i);
		}
		fprintf(table_file, "%0*lx ", nc, val & max_val);
	}
	fprintf(table_file, "\n");
	fclose(table_file);
}

int main(int argc, char** argv) {
	sintable("sintable.hex", 8, 24);
	return 0;
}