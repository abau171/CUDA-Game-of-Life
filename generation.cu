#include <stdio.h>

#include "generation.h"
#include "board.h"

void printGeneration(Board board, int generation) {
	printf("\nGeneration %d\n", generation);
	printBoard(board);
}

static int getNumLivingNeighbors(Board board, int x, int y) {
	int numLivingNeighbors = 0;
	for (int dy = -1; dy <= 1; dy++) {
		for (int dx = -1; dx <= 1; dx++) {
			if (dx == 0 && dy == 0) {
				continue;
			}
			if (getCellState(board, x + dx, y + dy) == ALIVE) {
				numLivingNeighbors++;
			}
		}
	}
	return numLivingNeighbors;
}

static CellState getNextState(Board board, int x, int y) {
	int numLivingNeighbors = getNumLivingNeighbors(board, x, y);
	CellState prevState = getCellState(board, x, y);
	CellState nextState = DEAD;
	if (prevState == ALIVE) {
		if (numLivingNeighbors >= 2 && numLivingNeighbors <= 3) {
			nextState = ALIVE;
		}
	} else if (numLivingNeighbors == 3) {
		nextState = ALIVE;
	}
	return nextState;
}

static void nextGen(Board prevBoard, Board nextBoard) {
	for (int y = 0; y < BOARD_DIM; y++) {
		for (int x = 0; x < BOARD_DIM; x++) {
			setCellState(nextBoard, x, y, getNextState(prevBoard, x, y));
		}
	}
}

void nextNGens(Board origBoard, int numGens) {

	Board bufferBoard = newBoard();

	nextGen(origBoard, bufferBoard);

	Board* curBoard_p = &origBoard;
	Board* nextBoard_p = &bufferBoard;

	for (int i = 0; i < numGens; i++) {
		nextGen(*curBoard_p, *nextBoard_p);
		Board* tmp = curBoard_p;
		curBoard_p = nextBoard_p;
		nextBoard_p = tmp;
	}

	if (*curBoard_p != origBoard) {
		for (int i = 0; i < BOARD_SIZE; i++) {
			origBoard[i] = (*curBoard_p)[i];
		}
	}

	freeBoard(bufferBoard);
}
