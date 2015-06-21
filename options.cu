#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "options.h"

void getOptions(int argc, char* argv[], int* numGenerations, int* boardDim) {
	char* numGenStr;
	bool gotNumGenStr = false;
	char* boardDimStr;
	bool gotBoardDimStr = false;
	int i = 0;
	extern char* optarg;
	while ((i = getopt(argc, argv, ":d:g:")) != -1) {
		switch(i) {
		case 'd':
			boardDimStr = optarg;
			gotBoardDimStr = true;
			break;
		case 'g':
			numGenStr = optarg;
			gotNumGenStr = true;
			break;
		case ':':
			printf("missing argument\n");
			break;
		case '?':
			printf("unknown argument\n");
			break;
		}
	}
	if (gotNumGenStr) {
		*numGenerations = (int) strtol(numGenStr, NULL, 10);
	} else {
		*numGenerations = 1;
	}
	if (gotBoardDimStr) {
		*boardDim = (int) strtol(boardDimStr, NULL, 10);
	} else {
		*boardDim = 8;
	}
}
