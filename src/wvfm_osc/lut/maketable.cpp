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

void freqtable(const char* filename) {
	FILE* table_file = fopen(filename, "w");
	if (table_file == NULL) {
		fprintf(stderr, "Cannot open file: %s for writing data.", filename);
		return;
	}
	int starting_freq = 21;
	int ending_freq = 108;
	int fpga_clk = 50000000;
	double freqs[88] = {27.5, 29.135, 30.868, 32.703, 34.648, 36.708, 38.891,
		41.203, 43.654, 46.249, 48.999, 51.913, 55, 58.27, 61.735, 65.406,
		69.296, 73.416, 77.782, 82.407, 87.307, 92.499, 97.999, 103.83,
		110, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 174.61,
		185, 196, 207.65, 220, 233.08, 246.94, 261.63, 277.18, 293.67,
		311.13, 329.63, 349.23, 369.99, 392, 415.30, 440, 466.16, 493.88,
		523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99,
		830.61, 880, 932.33, 987.77, 1046.5, 1108.7, 1174.7, 1244.5,
		1318.5, 1396.9, 1480, 1568, 1661.2, 1760, 1864.7, 1975.5, 2093,
		2217.5, 2349.3, 2489, 2637, 2793, 2960, 3136, 3322.4, 3520, 3729.3,
		3951.1, 4186};
	for (int i = 0; i < ending_freq - starting_freq + 1; i++) {
		fprintf(table_file, "%s@%08x ", (i != 0) ? "\n" : "", i);
		long val = fpga_clk / freqs[i];
		fprintf(table_file, "%lx\n", val);
	}
	fclose(table_file);
}

int main(int argc, char** argv) {
	sintable("sintable.hex", 8, 24);
	freqtable("freqtable.hex");
	return 0;
}
