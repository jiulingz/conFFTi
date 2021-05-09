#include <bitset>
#include <cmath>
#include <fstream>
#include <iostream>

constexpr int DIVISION_WIDTH = 16;
constexpr char DIVISION_TABLE[] = "division_table.vm";

/*
 * The table contains fixed width mapping from number to their recipocal
 */
void make_division_table(const char *filename) {
	std::ofstream division_table{filename};
	for (int i = 0; i < (1 << DIVISION_WIDTH); i++) {
		std::bitset<DIVISION_WIDTH> recipocal{i == 0 ? 0
		                                           : (1 << DIVISION_WIDTH) / i};
		division_table << recipocal << std::endl;
	}
}

int main(int argc, char **argv) {
	make_division_table(DIVISION_TABLE);
	return 0;
}
