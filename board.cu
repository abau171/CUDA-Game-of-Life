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

Board newDeviceBoard() {
	Board d_board;
	cudaMalloc(&d_board, BOARD_SIZE * sizeof(char));
	return d_board;
}

void freeDeviceBoard(Board board) {
	cudaFree(board);
}

void copyBoardToDevice(Board board, Board d_board) {
	cudaMemcpy(d_board, board, BOARD_SIZE * sizeof(char), cudaMemcpyHostToDevice);
}

void copyDeviceToBoard(Board d_board, Board board) {
	cudaMemcpy(board, d_board, BOARD_SIZE * sizeof(char), cudaMemcpyDeviceToHost);
}

#define wrapCoord(c) ((c + BOARD_DIM) % BOARD_DIM)

CellState getCellState(Board board, int x, int y) {
	return (board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] == 1) ? ALIVE : DEAD;
}

void setCellState(Board board, int x, int y, CellState state) {
	board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] = (state == ALIVE) ? 1 : 0;
}

static void printBoardHorizontalBorder() {
	printf("%c", CORNER_BORDER);
	for (int col = 0; col < 2 * BOARD_DIM + 1; col++) {
		printf("%c", HORIZONTAL_BORDER);
	}
	printf("%c\n", CORNER_BORDER);
}

void printBoard(Board board) {
	printBoardHorizontalBorder();
	for (int y = 0; y < BOARD_DIM; y++) {
		printf("%c", VERTICAL_BORDER);
		for (int x = 0; x < BOARD_DIM; x++) {
			printf(" %c", (getCellState(board, x, y) == ALIVE) ? '#' : ' ');
		}
		printf(" %c%c\n", VERTICAL_BORDER);
	}
	printBoardHorizontalBorder();
}
