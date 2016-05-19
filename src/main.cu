#include <stdio.h>

#include "common_board.h"
#include "options.h"
#include "board.h"
#include "generation.h"
#include "board_printer.h"

static void drawGlider(Board board) {
	setCellState(board, 0, 0, ALIVE);
	setCellState(board, 1, 1, ALIVE);
	setCellState(board, 2, 1, ALIVE);
	setCellState(board, 1, 2, ALIVE);
	setCellState(board, 0, 2, ALIVE);
}

int main(int argc, char** argv) {
	int numGenerations;
	int boardDim;
	getOptions(argc, argv, &numGenerations, &boardDim);
	setBoardDim(boardDim);
	Board board = newBoard();
	drawGlider(board);
	printBoard(board);
	nextNGens(board, numGenerations);
	printBoard(board);
	freeBoard(board);
}
