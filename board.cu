#include <stdio.h>

#include "board.h"

Board newBoard() {
	Board board = (Board) malloc(getBoardSize() * sizeof(char));
	for (int i = 0; i < getBoardSize(); i++) {
		board[i] = 0;
	}
	return board;
}

void freeBoard(Board board) {
	free(board);
}

#define wrapCoord(c) ((c + getBoardDim()) % getBoardDim())

CellState getCellState(Board board, int x, int y) {
	return (board[getBoardDim() * wrapCoord(y) + wrapCoord(x)] == 1) ? ALIVE : DEAD;
}

void setCellState(Board board, int x, int y, CellState state) {
	board[getBoardDim() * wrapCoord(y) + wrapCoord(x)] = (state == ALIVE) ? 1 : 0;
}
