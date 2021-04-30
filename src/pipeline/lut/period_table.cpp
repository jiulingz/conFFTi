#include <bitset>
#include <cmath>
#include <fstream>
#include <iostream>

constexpr int AUDIO_GENERATION_FREQUENCY = 50000;
constexpr int PERIOD_WIDTH = 16;
constexpr int DATA_WIDTH = 7;
constexpr char PERIOD_TABLE[] = "period_table.vm";

/*
 * The table contains mapping from midi note number to number of system clock
 * cycle per period.
 *
 * See the note numebr to frequency conversion:
 * https://en.wikipedia.org/wiki/MIDI_tuning_standard#Frequency_values
 */
void make_period_table(const char *filename) {
	auto frequency = [](int m) { return 440 * std::exp2((m - 69) / 12.0); };

	std::ofstream table{filename};
	for (int i = 0; i < (1 << DATA_WIDTH); i++) {
		std::bitset<PERIOD_WIDTH> clock_cycles{AUDIO_GENERATION_FREQUENCY
		                                       / frequency(i)};
		table << clock_cycles << std::endl;
	}
}

int main(int argc, char **argv) {
	make_period_table(PERIOD_TABLE);
	return 0;
}
