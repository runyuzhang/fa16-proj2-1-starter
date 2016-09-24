#include <stdio.h>
#include <stdlib.h>

#include "src/tables.h"
#include "assembler.h"

int grade_pass_two(char* in_name, char* out_name, SymbolTable* symtbl, SymbolTable* reltbl) {
    FILE *input = fopen(in_name, "r");
    FILE *output = fopen(out_name, "w");
    if (!input || !output) {
        return -1;
    }
    int retval = pass_two(input, output, symtbl, reltbl);
    fclose(input);
    fclose(output);
    return retval;
}

int grade_branch_one() {
    SymbolTable* symtbl = create_table(SYMTBL_UNIQUE_NAME);
    SymbolTable* reltbl = create_table(SYMTBL_NON_UNIQUE);

    add_to_table(symtbl, "l1", 0);
    add_to_table(symtbl, "l2", 4);
    add_to_table(symtbl, "l3", 16);

    int retval = grade_pass_two("../test_input/branch.s", "out/branch.out", symtbl, reltbl);
    free_table(symtbl);
    free_table(reltbl);
    return retval;
}

int grade_branch_two() {
    SymbolTable* symtbl = create_table(SYMTBL_UNIQUE_NAME);
    SymbolTable* reltbl = create_table(SYMTBL_NON_UNIQUE);

    add_to_table(symtbl, "l1", 131072);
    add_to_table(symtbl, "l2", 131076);

    int retval = grade_pass_two("../test_input/branch2.s", "out/branch2.out", symtbl, reltbl);
    int correct = (retval == 0);
	retval = grade_pass_two("../test_input/branch3.s", "out/branch3.out", symtbl, reltbl);
	correct &= (retval == -1);

    free_table(symtbl);
    free_table(reltbl);
    return correct;
}

int main(int argc, char** argv) {
	if (argc != 2) {
		return -1;
	}
	switch (atoi(argv[1])) {
		case 0: return grade_branch_one();
		case 1: return grade_branch_two() ? 0 : 1;
		default: return -1;
	}
}
