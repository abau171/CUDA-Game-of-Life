#ifndef BOARD_H
#define BOARD_H

#define BOARD_DIM 8
#define BOARD_SIZE (BOARD_DIM * BOARD_DIM)

#define CORNER_BORDER 'O'
#define HORIZONTAL_BORDER '-'
#define VERTICAL_BORDER '|'

typedef enum {ALIVE, DEAD} CellState;

typedef char* Board;

Board newBoard();

void freeBoard(Board board);

Board newDeviceBoard();

void freeDeviceBoard(Board d_board);

void copyBoardToDevice(Board board, Board d_board);

void copyDeviceToBoard(Board d_board, Board board);

CellState getCellState(Board board, int x, int y);

void setCellState(Board board, int x, int y, CellState state);

void printBoard(Board board);

#endif
