#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include <gameoflife.h>

int main(int argc, char* argv[]) {
    //set_cell(2, 1);
    //set_cell(3, 2);
    //set_cell(1, 3);
    //set_cell(2, 3);
    //set_cell(3, 3);
    randomize_board();
    int gen = 0;
    while (1) {
        printf("GENERATION %d\n", gen);
        print_board();
        usleep(100 * 1000);
        next_gen();
        gen++;
    }
}

