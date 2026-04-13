EXECUTABLE=IntegratingCandASM

all:
	nasm -f elf add.asm -o add.o -l starter.lst
	gcc -m32 -c main.c
	gcc -m32 main.o add.o -o $(EXECUTABLE)
	./$(EXECUTABLE)

	nasm -f elf sub.asm -o sub_asm.o
	gcc -m32 -c sub.c -o sub_c.o
	gcc -m32 sub_c.o sub_asm.o -o $(EXECUTABLE)
	./$(EXECUTABLE)

#Clean folder
clean:
	rm -rf *o *.lst $(EXECUTABLE)