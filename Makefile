NAME = gameoflife
CC = gcc
NVCC = nvcc

SRC_C = $(wildcard src/*.c)
SRC_CU = $(wildcard src/*.cu)
OBJ = $(patsubst src/%.c, obj/%.o, $(SRC_C)) $(patsubst src/%.cu, obj/%.o, $(SRC_CU))

.PHONY: all clean objects

all : $(NAME)

$(NAME) : $(OBJ)
	$(NVCC) $(OBJ) -o $(NAME)

clean :
	rm -f $(NAME)
	rm -rf obj/

obj/%.o : src/%.cu obj/
	$(NVCC) -x cu -I include/ -dc $< -o $@

obj/%.o : src/%.c obj/
	$(CC) -x c -I include/ -c $< -o $@

obj/ :
	mkdir obj/

