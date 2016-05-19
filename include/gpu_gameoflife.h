#ifndef GPU_GAMEOFLIFE_H
#define GPU_GAMEOFLIFE_H

void gpu_next_n_gens(int n);

void gpu_set_cell(int x, int y);

void gpu_randomize_board(void);

void gpu_print_board(void);

#endif

