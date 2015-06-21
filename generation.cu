#include <stdio.h>

#include "generation.h"
#include "board.h"
#include "device_board.h"

static __device__ int d_getNumLivingNeighbors(Board board, int x, int y) {
	int numLivingNeighbors = 0;
	for (int dy = -1; dy <= 1; dy++) {
		for (int dx = -1; dx <= 1; dx++) {
			if (dx == 0 && dy == 0) {
				continue;
			}
			if (d_getCellState(board, x + dx, y + dy) == ALIVE) {
				numLivingNeighbors++;
			}
		}
	}
	return numLivingNeighbors;
}

static __device__ CellState getNextState(bool cellAlive, int numLivingNeighbors) {
	CellState nextState = DEAD;
	if (cellAlive) {
		if (numLivingNeighbors >= 2 && numLivingNeighbors <= 3) {
			nextState = ALIVE;
		}
	} else if (numLivingNeighbors == 3) {
		nextState = ALIVE;
	}
	return nextState;
}

__global__ void d_nextNGens(Board d_board1, Board d_board2, int numGens) {
	bool cellAlive = (d_getCellState(d_board1, threadIdx.x, threadIdx.y) == ALIVE);
	int numLivingNeighbors = d_getNumLivingNeighbors(d_board1, threadIdx.x, threadIdx.y);
	CellState nextState = getNextState(cellAlive, numLivingNeighbors);
	d_setCellState(d_board2, threadIdx.x, threadIdx.y, nextState);
}

void nextNGens(Board origBoard, int numGens) {
	Board d_board1 = newDeviceBoard();
	Board d_board2 = newDeviceBoard();
	copyBoardToDevice(origBoard, d_board1);
	dim3 threadDim(BOARD_DIM, BOARD_DIM);
	d_nextNGens<<<1, threadDim>>>(d_board1, d_board2, numGens);
	copyDeviceToBoard(d_board2, origBoard);
}
