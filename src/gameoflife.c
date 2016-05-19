#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include <gameoflife.h>

#define WIDTH 32
#define HEIGHT 18

static char board1[WIDTH * HEIGHT];
static char board2[WIDTH * HEIGHT];

static char* board = board1;
static char* buffer_board = board2;

static inline char wrap_x(int x) {
    return (x + WIDTH) % WIDTH;
}

static inline char wrap_y(int y) {
    return (y + HEIGHT) % HEIGHT;
}

static void process_cell(int x, int y) {
    int cell_index = x + WIDTH * y;
    char alive = board[cell_index];
    int num_neighbors = 0;
    for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) {
                continue;
            }
            num_neighbors += board[wrap_x(x + dx) + WIDTH * wrap_y(y + dy)];
        }
    }
    if (alive && (num_neighbors < 2 || num_neighbors > 3)) {
        buffer_board[cell_index] = 0;
    } else if (!alive && num_neighbors == 3) {
        buffer_board[cell_index] = 1;
    } else {
        buffer_board[cell_index] = alive;
    }
}

void next_gen(void) {
    for (int x = 0; x < WIDTH; x++) {
        for (int y = 0; y < HEIGHT; y++) {
            process_cell(x, y);
        }
    }
    char* tmp = board;
    board = buffer_board;
    buffer_board = tmp;
}

void set_cell(int x, int y) {
    board[x + WIDTH * y] = 1;
}

void randomize_board(void) {
    srand(172);
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            if (rand() % 2 == 0) {
                set_cell(x, y);
            }
        }
    }
}

void print_board(void) {
    putchar('O');
    for (int i = 0; i < 2 * WIDTH - 1; i++) { putchar('-');
    }
    putchar('O');
    putchar('\n');
    for (int y = 0; y < HEIGHT; y++) {
        putchar('|');
        for (int x = 0; x < WIDTH; x++) {
            if (x > 0) {
                putchar(' ');
            }
            putchar(board[x + WIDTH * y] ? 'X' : ' ');
        }
        putchar('|');
        putchar('\n');
    }
    putchar('O');
    for (int i = 0; i < 2 * WIDTH - 1; i++) {
        putchar('-');
    }
    putchar('O');
    putchar('\n');
}

