#include <stdio.h>

#include "board.h"

Board newBoard() {
	Board board = (Board) malloc(BOARD_SIZE * sizeof(char));
	for (int i = 0; i < BOARD_SIZE; i++) {
		board[i] = 0;
	}
	return board;
}

void freeBoard(Board board) {
	free(board);
}

#define wrapCoord(c) ((c + BOARD_DIM) % BOARD_DIM)

CellState getCellState(Board board, int x, int y) {
	return (board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] == 1) ? ALIVE : DEAD;
}

void setCellState(Board board, int x, int y, CellState state) {
	board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] = (state == ALIVE) ? 1 : 0;
}
