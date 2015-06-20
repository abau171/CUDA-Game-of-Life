#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "options.h"

void getOptions(int argc, char* argv[], int* numGenerations) {
	char* numGenStr;
	bool gotNumGenStr = false;
	int i = 0;
	extern char* optarg;
	while ((i = getopt(argc, argv, ":g:")) != -1) {
		switch(i) {
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
}
