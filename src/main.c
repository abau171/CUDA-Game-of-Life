#include <stdio.h>

#include <gameoflife.h>
#include <gpu_gameoflife.h>

void run_cpu(void) {
    randomize_board();
    int gen = 0;
    for (int i = 0; i < 10; i++) {
        printf("GENERATION %d\n", gen);
        print_board();
        for (int j = 0; j < 100000; j++) {
            next_gen();
        }
        gen += 100000;
    }
}

void run_gpu(void) {
    gpu_randomize_board();
    int gen = 0;
    for (int i = 0; i < 10; i++) {
        printf("GENERATION %d\n", gen);
        gpu_print_board();
        gpu_next_n_gens(100000);
        gen += 100000;
    }
}

int main(int argc, char* argv[]) {
    run_gpu();
}

    /*gpu_set_cell(2, 1);
    gpu_set_cell(3, 2);
    gpu_set_cell(1, 3);
    gpu_set_cell(2, 3);
    gpu_set_cell(3, 3);*/

