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
