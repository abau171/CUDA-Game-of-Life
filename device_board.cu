#include "device_board.h"

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

__device__ CellState d_getCellState(Board board, int x, int y) {
	return (board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] == 1) ? ALIVE : DEAD;
}

__device__ void d_setCellState(Board board, int x, int y, CellState state) {
	board[BOARD_DIM * wrapCoord(y) + wrapCoord(x)] = (state == ALIVE) ? 1 : 0;
}
