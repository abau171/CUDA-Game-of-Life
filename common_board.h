#ifndef COMMON_BOARD_H
#define COMMON_BOARD_H

#define BOARD_DIM 8
#define BOARD_SIZE (BOARD_DIM * BOARD_DIM)

#define CORNER_BORDER 'O'
#define HORIZONTAL_BORDER '-'
#define VERTICAL_BORDER '|'

typedef enum {ALIVE, DEAD} CellState;

typedef char* Board;

#endif
