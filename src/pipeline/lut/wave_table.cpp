#include <bitset>
#include <cstring>
#include <fstream>
#include <iostream>

constexpr int LONG_PERCENT_WIDTH = 8;
constexpr int AUDIO_BIT_WIDTH = 16;
constexpr int BYTE_WIDTH = 8;

void make_wavetable(const char *ifilename, const char *ofilename_front, const char *ofilename_back, int entry_count,
                    int entry_width) {
	std::ifstream data(ifilename, std::ios::binary);
	std::ofstream table_front(ofilename_front);
	std::ofstream table_back(ofilename_back);
	char buf[AUDIO_BIT_WIDTH / BYTE_WIDTH];
	uint16_t num;
	for (int i = 0; i < entry_count / 2; i++) {
		if (!data.read(buf, sizeof(buf))) {
			std::cerr << "Not enough bytes in file" << std::endl;
		}
		std::memcpy(&num, buf, sizeof(buf));
		std::bitset<AUDIO_BIT_WIDTH> value{num};
		table_front << value << std::endl;
		table_front << value << std::endl;
	}
	for (int i = 0; i < entry_count / 2; i++) {
		if (!data.read(buf, sizeof(buf))) {
			std::cerr << "Not enough bytes in file" << std::endl;
		}
		std::memcpy(&num, buf, sizeof(buf));
		std::bitset<AUDIO_BIT_WIDTH> value{num};
		table_back << value << std::endl;
		table_back << value << std::endl;
	}
}

int main() {
	make_wavetable("raw/cello.raw", "cello_front_table.vm", "cello_back_table.vm", 1 << LONG_PERCENT_WIDTH,
	               AUDIO_BIT_WIDTH);
	make_wavetable("raw/french_horn.raw", "french_horn_front_table.vm", "french_horn_back_table.vm",
	               1 << LONG_PERCENT_WIDTH, AUDIO_BIT_WIDTH);
	make_wavetable("raw/trumpet.raw", "trumpet_front_table.vm", "trumpet_back_table.vm", 1 << LONG_PERCENT_WIDTH,
	               AUDIO_BIT_WIDTH);
	make_wavetable("raw/viola.raw", "viola_front_table.vm", "viola_back_table.vm", 1 << LONG_PERCENT_WIDTH,
	               AUDIO_BIT_WIDTH);
	make_wavetable("raw/violin.raw", "violin_front_table.vm", "violin_back_table.vm", 1 << LONG_PERCENT_WIDTH,
	               AUDIO_BIT_WIDTH);
	return 0;
}