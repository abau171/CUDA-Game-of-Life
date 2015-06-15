#include <stdio.h>

#define BOARD_DIM 1024
#define NUM_GENERATIONS 500

#define USE_GPU false

#define BOARD_CORNER_BORDER "O"
#define BOARD_HORIZONTAL_BORDER "--"
#define BOARD_VERTICAL_BORDER "|"

typedef char* Board;

__device__ int d_getWrappedIndex(int i) {
	// wraps to within board bounds between -BOARD_DIM and +infinity
	return (i + BOARD_DIM) % BOARD_DIM;
}

__global__ void d_computeNextBoard(Board d_prevBoard, Board d_nextBoard) {
	int cellIndex = blockIdx.x * blockDim.x + threadIdx.x;
	int col = cellIndex % BOARD_DIM;
	int row = (cellIndex - col) / BOARD_DIM;
	int numLivingNeighbors = 0;
	for (int dRow = -1; dRow < 2; dRow++) {
		for (int dCol = -1; dCol < 2; dCol++) {
			if (dRow == 0 && dCol == 0) {
				continue;
			}
			int neighborCellIndex = BOARD_DIM * d_getWrappedIndex(row + dRow) + d_getWrappedIndex(col + dCol);
			if (d_prevBoard[neighborCellIndex] > 0) {
				numLivingNeighbors++;
			}
		}
	}
	bool curStateAlive = d_prevBoard[BOARD_DIM * row + col];
	bool nextStateAlive;
	if (curStateAlive) {
		nextStateAlive = (numLivingNeighbors >= 2 && numLivingNeighbors <= 3);
	} else {
		nextStateAlive = (numLivingNeighbors == 3);
	}
	d_nextBoard[cellIndex] = nextStateAlive ? 1 : 0;
}

void printBoardHorizontalBorder() {
	printf(BOARD_CORNER_BORDER);
	for (int col = 0; col < BOARD_DIM; col++) {
		printf(BOARD_HORIZONTAL_BORDER);
	}
	printf("%s\n", BOARD_CORNER_BORDER);
}

void printBoard(Board board) {
	printBoardHorizontalBorder();
	for (int row = 0; row < BOARD_DIM; row++) {
		printf(BOARD_VERTICAL_BORDER);
		for (int col = 0; col < BOARD_DIM; col++) {
			printf(" %c", board[BOARD_DIM * row + col] > 0 ? '#' : ' ');
		}
		printf("%s\n", BOARD_VERTICAL_BORDER);
	}
	printBoardHorizontalBorder();
}

void printGeneration(Board board, int generation) {
	printf("\nGeneration %d\n", generation);
	printBoard(board);
}

Board newBoard() {
	Board board = (char*) malloc(BOARD_DIM * BOARD_DIM);
	return board;
}

void buildGliderBoard(Board board) {
	for (int row = 0; row < BOARD_DIM; row++) {
		for (int col = 0; col < BOARD_DIM; col++) {
			int cellIndex = BOARD_DIM * row + col;
			board[cellIndex] = 0;
		}
	}
	board[BOARD_DIM * 0 + 0] = 1;
	board[BOARD_DIM * 1 + 1] = 1;
	board[BOARD_DIM * 1 + 2] = 1;
	board[BOARD_DIM * 2 + 0] = 1;
	board[BOARD_DIM * 2 + 1] = 1;
}

int getWrappedIndex(int i) {
	// wraps to within board bounds between -BOARD_DIM and +infinity
	return (i + BOARD_DIM) % BOARD_DIM;
}

void nextGenerationCPU(Board* currentBoard_p, Board* bufferBoard_p) {
	Board prevBoard = *currentBoard_p;
	Board nextBoard = *bufferBoard_p;
	for (int row = 0; row < BOARD_DIM; row++) {
		for (int col = 0; col < BOARD_DIM; col++) {
			int cellIndex = BOARD_DIM * row + col;
			int numLivingNeighbors = 0;
			for (int dRow = -1; dRow < 2; dRow++) {
				for (int dCol = -1; dCol < 2; dCol++) {
					if (dRow == 0 && dCol == 0) {
						continue;
					}
					int neighborCellIndex = BOARD_DIM * getWrappedIndex(row + dRow) + getWrappedIndex(col + dCol);
					if (prevBoard[neighborCellIndex] > 0) {
						numLivingNeighbors++;
					}
				}
			}
			bool curStateAlive = prevBoard[BOARD_DIM * row + col];
			bool nextStateAlive;
			if (curStateAlive) {
				nextStateAlive = (numLivingNeighbors >= 2 && numLivingNeighbors <= 3);
			} else {
				nextStateAlive = (numLivingNeighbors == 3);
			}
			nextBoard[cellIndex] = nextStateAlive ? 1 : 0;
		}
	}
	*currentBoard_p = nextBoard;
	*bufferBoard_p = prevBoard;
}

void nextNGenerationsCPU(Board* currentBoard_p, Board* bufferBoard_p, int numGenerations) {
	for (int i = 0; i < numGenerations; i++) {
		nextGenerationCPU(currentBoard_p, bufferBoard_p);
	}
}

void nextNGenerationsGPU(Board* currentBoard_p, int numGenerations) {
	Board currentBoard = *currentBoard_p;

	Board d_board1;
	Board d_board2;
	Board* d_currentBoard = &d_board1;
	Board* d_bufferBoard = &d_board2;
	cudaMalloc((void**) d_currentBoard, BOARD_DIM * BOARD_DIM);
	cudaMalloc((void**) d_bufferBoard, BOARD_DIM * BOARD_DIM);

	cudaMemcpy(*d_currentBoard, currentBoard, BOARD_DIM * BOARD_DIM, cudaMemcpyHostToDevice);

	for (int i = 0; i < numGenerations; i++) {
		d_computeNextBoard<<<BOARD_DIM, BOARD_DIM>>>(*d_currentBoard, *d_bufferBoard);
		Board tmp = *d_currentBoard;
		*d_currentBoard = *d_bufferBoard;
		*d_bufferBoard = tmp;
	}

	cudaMemcpy(currentBoard, *d_currentBoard, BOARD_DIM * BOARD_DIM, cudaMemcpyDeviceToHost);

	cudaFree(d_board1);
	cudaFree(d_board2);

    cudaDeviceReset();
}

int main() {
	Board board1 = newBoard();
	Board board2 = newBoard();
	Board* currentBoard_p = &board1;
	Board* bufferBoard_p = &board2;
	buildGliderBoard(*currentBoard_p);
	printGeneration(*currentBoard_p, 0);
	if (USE_GPU) {
		nextNGenerationsGPU(currentBoard_p, NUM_GENERATIONS);
	} else {
		nextNGenerationsCPU(currentBoard_p, bufferBoard_p, NUM_GENERATIONS);
	}
	printGeneration(*currentBoard_p, NUM_GENERATIONS);
	free(board1);
	free(board2);
	return 0;
}
