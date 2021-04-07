#include <bitset>
#include <fstream>
#include <iostream>

constexpr int AUDIO_GENERATION_FREQUENCY = 50000;
constexpr int PERIOD_WIDTH = 11;
constexpr char PERIOD_TABLE[] = "period_table.vm";

constexpr int NUM_NOTES = 88;
constexpr double FREQUENCIES[] = {
    27.5,   29.135, 30.868, 32.703, 34.648, 36.708, 38.891, 41.203, 43.654,
    46.249, 48.999, 51.913, 55,     58.27,  61.735, 65.406, 69.296, 73.416,
    77.782, 82.407, 87.307, 92.499, 97.999, 103.83, 110,    116.54, 123.47,
    130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185,    196,    207.65,
    220,    233.08, 246.94, 261.63, 277.18, 293.67, 311.13, 329.63, 349.23,
    369.99, 392,    415.30, 440,    466.16, 493.88, 523.25, 554.37, 587.33,
    622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880,    932.33, 987.77,
    1046.5, 1108.7, 1174.7, 1244.5, 1318.5, 1396.9, 1480,   1568,   1661.2,
    1760,   1864.7, 1975.5, 2093,   2217.5, 2349.3, 2489,   2637,   2793,
    2960,   3136,   3322.4, 3520,   3729.3, 3951.1, 4186};

/*
 * The table contains mapping from midi note number to number of system clock
 * cycle per period.
 */
void make_period_table(const char *filename) {
	std::ofstream table{filename};
	for (int i = 0; i < NUM_NOTES; i++) {
		std::bitset<PERIOD_WIDTH> clock_cycles{AUDIO_GENERATION_FREQUENCY / FREQUENCIES[i]};
		table << clock_cycles << std::endl;
	}
}

int main(int argc, char **argv) {
	make_period_table(PERIOD_TABLE);
	return 0;
}
