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

static __device__ CellState d_getNextState(bool cellAlive, int numLivingNeighbors) {
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

static __device__ void d_nextGen(Board prevBoard, Board nextBoard) {
	bool cellAlive = (d_getCellState(prevBoard, threadIdx.x, threadIdx.y) == ALIVE);
	int numLivingNeighbors = d_getNumLivingNeighbors(prevBoard, threadIdx.x, threadIdx.y);
	CellState nextState = d_getNextState(cellAlive, numLivingNeighbors);
	d_setCellState(nextBoard, threadIdx.x, threadIdx.y, nextState);
}

static __device__ void d_swapBoards(Board** board1_pp, Board** board2_pp) {
	Board* tmp = *board1_pp;
	*board1_pp = *board2_pp;
	*board2_pp = tmp;
}

__global__ void d_nextNGens(Board d_board1, Board d_board2, int numGens) {
	Board* curBoard_p = &d_board1;
	Board* nextBoard_p = &d_board2;
	for (int i = 0; i < numGens; i++) {
		d_nextGen(*curBoard_p, *nextBoard_p);
		d_swapBoards(&curBoard_p, &nextBoard_p);
		__syncthreads();
	}
}

static Board* pickFinalBoard(Board* d_board1_p, Board* d_board2_p, int numGens) {
	if (numGens % 2 == 0) {
		return d_board1_p;
	} else {
		return d_board2_p;
	}
}

void nextNGens(Board origBoard, int numGens) {
	Board d_board1 = newDeviceBoard();
	Board d_board2 = newDeviceBoard();
	copyBoardToDevice(origBoard, d_board1);
	dim3 threadDim(getBoardDim(), getBoardDim());
	d_nextNGens<<<1, threadDim>>>(d_board1, d_board2, numGens);
	Board* d_finalBoard_p = pickFinalBoard(&d_board1, &d_board2, numGens);
	copyDeviceToBoard(*d_finalBoard_p, origBoard);
}
