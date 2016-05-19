#include "device_board.h"

Board newDeviceBoard() {
	Board d_board;
	cudaMalloc(&d_board, getBoardSize() * sizeof(char));
	return d_board;
}

void freeDeviceBoard(Board board) {
	cudaFree(board);
}

void copyBoardToDevice(Board board, Board d_board) {
	cudaMemcpy(d_board, board, getBoardSize() * sizeof(char), cudaMemcpyHostToDevice);
}

void copyDeviceToBoard(Board d_board, Board board) {
	cudaMemcpy(board, d_board, getBoardSize() * sizeof(char), cudaMemcpyDeviceToHost);
}

#define d_wrapCoord(c) ((c + d_getBoardDim()) % d_getBoardDim())

__device__ CellState d_getCellState(Board board, int x, int y) {
	return (board[d_getBoardDim() * d_wrapCoord(y) + d_wrapCoord(x)] == 1) ? ALIVE : DEAD;
}

__device__ void d_setCellState(Board board, int x, int y, CellState state) {
	board[d_getBoardDim() * d_wrapCoord(y) + d_wrapCoord(x)] = (state == ALIVE) ? 1 : 0;
}
