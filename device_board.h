#ifndef DEVICE_BOARD_H
#define DEVICE_BOARD_H

#include "common_board.h"

Board newDeviceBoard();

void freeDeviceBoard(Board d_board);

void copyBoardToDevice(Board board, Board d_board);

void copyDeviceToBoard(Board d_board, Board board);

#endif
