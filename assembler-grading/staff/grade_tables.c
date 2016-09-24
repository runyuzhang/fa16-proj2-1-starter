#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "src/utils.h"
#include "src/tables.h"

const char* TMP_FILE = "tmp_grading.txt";
const int BUF_SIZE = 1024;

/****************************************
 *  Helper functions 
 ****************************************/

int check_lines_equal(char **arr, int num) {
    char buf[BUF_SIZE];

    FILE *f = fopen(TMP_FILE, "r");
    if (!f) {
        return -1;
    }
    for (int i = 0; i < num; i++) {
        if (!fgets(buf, BUF_SIZE, f)) {
            return -1;
        }
        if (strncmp(buf, arr[i], strlen(arr[i])) != 0) {
            return 1;
        }
    }
    fclose(f);
    return 0;
}

/****************************************
 *  Test cases for tables.c 
 ****************************************/

int grade_table_1() {
    int retval;
    int correct;

    SymbolTable* tbl = create_table(SYMTBL_NON_UNIQUE);

    retval = add_to_table(tbl, "abc", 8);
    correct = (retval == 0);
    retval = add_to_table(tbl, "efg", 12);
    correct &= (retval == 0);
    retval = add_to_table(tbl, "q45", 16);
    correct &= (retval == 0);

    retval = get_addr_for_symbol(tbl, "abc");
    correct &= (retval == 8);
    retval = get_addr_for_symbol(tbl, "q45");
    correct &= (retval == 16);
    retval = get_addr_for_symbol(tbl, "efg");
    correct &= (retval == 12);
    
    free_table(tbl);
    return correct;
}

int grade_table_2() {
	int retval;
	int correct;

	set_log_file(TMP_FILE);
	SymbolTable* tbl = create_table(SYMTBL_UNIQUE_NAME);

	retval = add_to_table(tbl, "q45", 8);
	correct = (retval == 0);
    retval = add_to_table(tbl, "efg", 12);
    correct &= (retval == 0);
    retval = add_to_table(tbl, "q45", 16);
    correct &= (retval == -1);
    retval = add_to_table(tbl, "abc", 13);
    correct &= (retval == -1);

    free_table(tbl);

    char* arr[] = { "Error: name 'q45' already exists in table.",
                    "Error: address is not a multiple of 4." };
    retval = check_lines_equal(arr, 2);
    correct &= (retval == 0);
    return correct;
}

int grade_table_3() {
    int retval;
    int correct;
    char buf[100];

    SymbolTable* tbl = create_table(SYMTBL_NON_UNIQUE);

    strcpy(buf, "abc");
    retval = add_to_table(tbl, buf, 8);
    correct = (retval == 0);
    strcpy(buf, "asldfkjsd;lskjdfa");
    strcpy(buf, "efg");
    retval = add_to_table(tbl, buf, 12);
    correct &= (retval == 0);
    strcpy(buf, "wenweavnwepoaiwneiawioen");
    strcpy(buf, "q45");
    retval = add_to_table(tbl, buf, 16);
    correct &= (retval == 0);

    retval = get_addr_for_symbol(tbl, "abc");
    correct &= (retval == 8);
    retval = get_addr_for_symbol(tbl, "q45");
    correct &= (retval == 16);
    retval = get_addr_for_symbol(tbl, "efg");
    correct &= (retval == 12);
    
    free_table(tbl);
    return correct;
}


int grade_table_4() {
    int retval, max = 500;
    int correct = 1;

    SymbolTable* tbl = create_table(SYMTBL_UNIQUE_NAME);

    char buf[100];
    for (int i = 0; i < max; i++) {
        sprintf(buf, "%d", i);
        retval = add_to_table(tbl, buf, 4 * i);
        correct &= (retval == 0);
    }

    for (int i = 0; i < max; i++) {
        sprintf(buf, "%d", i);
        retval = get_addr_for_symbol(tbl, buf);
        correct &= (retval == 4 * i);
    }

    free_table(tbl);
    return correct;
}

/****************************************
 *  Add your test cases here
 ****************************************/

int main(int argc, char** argv) {
	if (argc != 2) {
		return -1;
	}
	switch (atoi(argv[1])) {
		case 0: return grade_table_1() ? 0 : 1;
		case 1: return grade_table_2() ? 0 : 1;
		case 2: return grade_table_3() ? 0 : 1;
		case 3: return grade_table_4() ? 0 : 1;
		default: return -1;
	}
}
