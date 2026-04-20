EXECUTABLE=IntegratingCandASM

all:
	nasm -f elf main.asm -o main.o -l starter.lst
	gcc -m32 -c main.c
	gcc -m32 main.o -o $(EXECUTABLE)
	./$(EXECUTABLE)s

#Clean folder
clean:
	rm -rf *o *.lst $(EXECUTABLE)