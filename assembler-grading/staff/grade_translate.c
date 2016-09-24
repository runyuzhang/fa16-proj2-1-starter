#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "src/translate_utils.h"

int grade_translate_reg(int testcase) {
    switch (testcase) {
        case 0: {
            return translate_reg("$zero") == 0 &&
            translate_reg("$0") == 0 &&
            translate_reg("$at") == 1 &&
            translate_reg("$v0") == 2 &&
            translate_reg("$a0") == 4 &&
            translate_reg("$a1") == 5 &&
            translate_reg("$a2") == 6 &&
            translate_reg("$a3") == 7 &&
            translate_reg("$t0") == 8 &&
            translate_reg("$t1") == 9 &&
            translate_reg("$t2") == 10 &&
            translate_reg("$t3") == 11 &&
            translate_reg("$s0") == 16 &&
            translate_reg("$s1") == 17 &&
            translate_reg("$s2") == 18 &&
            translate_reg("$s3") == 19 &&
            translate_reg("$sp") == 29 &&
            translate_reg("$ra") == 31;
        }
        case 1: {
            return translate_reg("$t") == -1 &&
            translate_reg("t0") == -1 &&
            translate_reg("0") == -1 &&
            translate_reg("3") == -1 &&
            translate_reg("$t99") == -1 &&
            translate_reg("bob") == -1;
        }
        default: return 0;
    }

}

int grade_translate_num(int testcase) {
    long int output;
    int correct, retval;

    switch (testcase) {
        case 0: {
            retval = translate_num(&output, "98", -1000, 1000);
            correct = (output == 98) && (retval == 0);
            retval = translate_num(&output, "145634236", 0, 9000000000);
            correct &= (output == 145634236) && (retval == 0);
            retval = translate_num(&output, "-389296", -500000, 0);
            correct &= (output == -389296) && (retval == 0);
            retval = translate_num(&output, "0xC0FFEE", -9000000000, 9000000000);
            correct &= (output == 12648430) && (retval == 0);
            return correct;
        }
        case 1: {
            retval = translate_num(&output, "72", -16, 72);
            correct = (output == 72) && (retval == 0);
            retval = translate_num(&output, "72", -16, 71);
            correct &= (retval < 0);
            retval = translate_num(&output, "72", 72, 150);
            correct &= (output == 72) && (retval == 0);
            retval = translate_num(&output, "72", 73, 150);
            correct &= (retval < 0);
            return correct;
        }
        case 2: {
            retval = translate_num(&output, "35x", -100, 100);
            correct = (retval < 0);
            retval = translate_num(&output, "C0FFEE", -10000, 10000);
            correct &= (retval < 0);
            retval = translate_num(&output, "923 135", -10000, 10000);
            correct &= (retval < 0);
            return correct;
        }
        default: return 0;
    }
}

int main(int argc, char** argv) {
    if (argc != 3) {
        return -1;
    }
    if (strcmp(argv[1], "reg") == 0) {
        return grade_translate_reg(atoi(argv[2])) ? 0 : 1;
    } else {
        return grade_translate_num(atoi(argv[2])) ? 0 : 1;
    }
}
