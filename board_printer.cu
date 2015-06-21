#include <stdio.h>

#include "board.h"
#include "board_printer.h"

static void printBoardHorizontalBorder() {
	printf("%c", CORNER_BORDER);
	for (int col = 0; col < 2 * getBoardDim() + 1; col++) {
		printf("%c", HORIZONTAL_BORDER);
	}
	printf("%c\n", CORNER_BORDER);
}

void printBoard(Board board) {
	printBoardHorizontalBorder();
	for (int y = 0; y < getBoardDim(); y++) {
		printf("%c", VERTICAL_BORDER);
		for (int x = 0; x < getBoardDim(); x++) {
			printf(" %c", (getCellState(board, x, y) == ALIVE) ? '#' : ' ');
		}
		printf(" %c%c\n", VERTICAL_BORDER);
	}
	printBoardHorizontalBorder();
}
