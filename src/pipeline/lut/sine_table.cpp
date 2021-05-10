#include <bitset>
#include <cmath>
#include <fstream>
#include <iostream>
#include <numbers>

constexpr int LONG_PERCENT_WIDTH = 8;
constexpr int AUDIO_BIT_WIDTH = 16;
constexpr char SINE_TABLE[] = "sine_table.vm";

/*
 * The table contains half period of normalized sine values, i.e.
 * sine values in [-1/2pi, 1/2pi]x[-1,1] is transformed to [0,1]x[0,1].
 *
 * Each table entry represents a percentage (entry/entry_count)
 * and each table value represents a percentage (value/2^entry_width).
 * i.e.
 *               value/2^entry_width == normal_sin(entry/entry_count)
 * where normal_sin is [0,1]x[0,1].
 */
void make_sine_table(const char *filename, int entry_count, int entry_width) {
	auto normal_sine = [](double x) -> double {
		return (std::sin((x - 0.5) * std::numbers::pi) + 1)
		       / 2;
	};

	std::ofstream table{filename};
	for (int i = 0; i < entry_count; i++) {
		std::bitset<AUDIO_BIT_WIDTH> value{normal_sine(1.0 * i / entry_count)
		                                   * (1 << entry_width)};
		table << value << std::endl;
	}
}

int main(int argc, char **argv) {
	make_sine_table(SINE_TABLE, 1 << LONG_PERCENT_WIDTH, AUDIO_BIT_WIDTH);
	return 0;
}
