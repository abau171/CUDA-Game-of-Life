extern "C" {

#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include <gpu_gameoflife.h>

#define CUDA(X) X
//printf("CUDA: %s\n", cudaGetErrorString(X))

#define WIDTH 32
#define HEIGHT 18
#define NUM_CELLS (WIDTH * HEIGHT)

static char board[WIDTH * HEIGHT];

void gpu_set_cell(int x, int y) {
    board[x + WIDTH * y] = 1;
}

void gpu_randomize_board(void) {
    srand(172);
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            if (rand() % 2 == 0) {
                gpu_set_cell(x, y);
            }
        }
    }
}

__device__
static inline char wrap_x(int x) {
    return (x + WIDTH) % WIDTH;
}

__device__
static inline char wrap_y(int y) {
    return (y + HEIGHT) % HEIGHT;
}

__global__
static void d_next_gen(char* board, char* buffer_board) {
    int cell_index = blockIdx.x * blockDim.x + threadIdx.x;
    if (cell_index >= NUM_CELLS) return;
    int y = cell_index / WIDTH;
    int x = cell_index % WIDTH;
    char alive = board[cell_index];
    int num_neighbors = 0;
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) continue;
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

void gpu_next_n_gens(int n) {
    char* d_board;
    char* d_buffer_board;

    CUDA(cudaMalloc(&d_board, NUM_CELLS * sizeof(char)));
    CUDA(cudaMalloc(&d_buffer_board, NUM_CELLS * sizeof(char)));
    CUDA(cudaMemcpy(d_board, board, NUM_CELLS * sizeof(char), cudaMemcpyHostToDevice));

    for (int i = 0; i < n; i++)  {
        d_next_gen<<<(NUM_CELLS + 64 - 1) / 64, 64>>>(d_board, d_buffer_board);

        char* tmp = d_board;
        d_board = d_buffer_board;
        d_buffer_board = tmp;
    }

    CUDA(cudaMemcpy(board, d_board, NUM_CELLS * sizeof(char), cudaMemcpyDeviceToHost));
    CUDA(cudaFree(d_board));
    CUDA(cudaFree(d_buffer_board));
}

void gpu_print_board(void) {
    putchar('O');
    for (int i = 0; i < 2 * WIDTH - 1; i++) {
        putchar('-');
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

}

