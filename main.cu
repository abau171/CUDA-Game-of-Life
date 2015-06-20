#include <stdio.h>

#include "board.h"
#include "generation.h"

static void drawGlider(Board board) {
	setCellState(board, 0, 0, ALIVE);
	setCellState(board, 1, 1, ALIVE);
	setCellState(board, 2, 1, ALIVE);
	setCellState(board, 1, 2, ALIVE);
	setCellState(board, 0, 2, ALIVE);
}

int main() {
	Board board = newBoard();
	drawGlider(board);
	printBoard(board);
	nextNGens(board, 32);
	printBoard(board);
	freeBoard(board);
}
