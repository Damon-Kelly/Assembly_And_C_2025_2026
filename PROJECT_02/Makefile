AS=nasm
LD=ld
ASFLAGS=-f elf64 -g -F dwarf -l main.lst
TARGET=main
SOURCES=main.asm
OBJECTS=$(SOURCES:.asm=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(OBJECTS) -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET) *.lst
