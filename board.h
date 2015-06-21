#ifndef BOARD_H
#define BOARD_H

#include "common_board.h"

Board newBoard();

void freeBoard(Board board);

CellState getCellState(Board board, int x, int y);

void setCellState(Board board, int x, int y, CellState state);

#endif
