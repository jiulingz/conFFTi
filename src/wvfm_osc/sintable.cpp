// reference: https://github.com/ZipCPU/cordic/blob/master/sw/sintable.cpp
// Creates a look-up table for computing sine values. Current version writes
// values from the entire sine wave but goal is to implement quarter look-up.
// Default values for phase bits = 8 and output bits = 24. Edit these values
// in main if needed.

#define _USE_MATH_DEFINES

#include <stdio.h>
#include <math.h>

void sintable(const char* filename, int pw, int ow) {
	FILE* table_file = fopen(filename, "w");
	if (table_file == NULL) {
		fprintf(stderr, "Cannot open file: %s for writing data.", filename);
		return;
	}
	int table_entries = (1 << pw); // 2^pw
	int nc = (ow + 3) / 4;
	long max_val = (1l << (ow - 1)) - 1l;
	for (int i = 0; i < table_entries; i++) {
		double ph = 2 * M_PI * (double)i / (double)table_entries;
		// entries into the sine LUT are percentages of max_val
		long val = (long)max_val * sin(ph);
		if (i % 8 == 0) {
			fprintf(table_file, "%s@%08x ", (i != 0) ? "\n" : "", i);
		}
		// mask the computed value so that it does not exceed max_val
		fprintf(table_file, "%0*lx ", nc, val & max_val);
	}
	fprintf(table_file, "\n");
	fclose(table_file);
}

int main(int argc, char** argv) {
	sintable("sintable.hex", 8, 24);
	return 0;
}