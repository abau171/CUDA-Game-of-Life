NAME = gameoflife
CC = gcc
NVCC = nvcc

SRC = $(wildcard src/*.cu)
OBJ = $(patsubst src/%.cu, obj/%.o, $(SRC))

.PHONY: all clean objects

all : $(NAME)

$(NAME) : $(OBJ)
	nvcc $(OBJ) -o $(NAME)

clean :
	rm -f $(NAME)
	rm -rf obj/

obj/%.o : src/%.cu obj/
	$(NVCC) -x cu -I include/ -dc $< -o $@

obj/%.o : src/%.c obj/
	$(CC) -x c -I include/ -c $< -o $@

obj/ :
	mkdir obj/

