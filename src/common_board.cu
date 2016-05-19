#include "common_board.h"

static int boardDim;
static int boardSize;

int getBoardDim() {
	return boardDim;
}

int getBoardSize() {
	return boardSize;
}

void setBoardDim(int newBoardDim) {
	boardDim = newBoardDim;
	boardSize = boardDim * boardDim;
}

__device__ int d_getBoardDim() {
	return blockDim.x;
}

__device__ int d_getBoardSize() {
	return blockDim.x * blockDim.y;
}
