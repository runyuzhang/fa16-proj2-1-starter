CC = gcc
CFLAGS = -g -std=gnu99 -Wall
ASSEMBLER_FILES = src/utils.c src/tables.c src/translate_utils.c src/translate.c

assembler:
	$(CC) $(CFLAGS) -o assembler assembler.c $(ASSEMBLER_FILES)

grade-translate:
	$(CC) $(CFLAGS) -o grade-translate grade_translate.c src/utils.c src/translate_utils.c
	
grade-tables:
	$(CC) $(CFLAGS) -o grade-tables grade_tables.c src/utils.c src/tables.c
	
grade-branch:
	$(CC) $(CFLAGS) -o grade-branch grade_branch.c assembler_nomain.c $(ASSEMBLER_FILES)

clean:
	rm -f *.o assembler test-assembler core
