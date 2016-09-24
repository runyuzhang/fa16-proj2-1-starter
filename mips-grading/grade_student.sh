#!/bin/bash

# $1 = login, $2 = name

TIME=10s
out_file=tmpout.txt

#############################
# Helper Functions

# Runs test and checks return code
# $1 = test
grade_test() {
    rm -f $out_file
    { timeout $TIME mars nc sm ../grading/${1}.s; } &>/dev/null
    if [ $? -eq 0 ]; then
	items="$items,A"
    elif [ -z "$(diff -qi $out_file ../out/pass.txt)" ]; then
	items="$items,P"
    else
	items="$items,F"
    fi
}

# Runs test and checks output
# $1 = test, $2 = reference output name
grade_test_compare() {
    rm -f $out_file
    { timeout $TIME mars nc sm ../grading/${1}.s; } &>/dev/null
    if [ $? -eq 0 ]; then
	items="$items,A"
    elif [ -z "$(diff -qi $out_file ../out/$2)" ]; then
	items="$items,P"
    else
	items="$items,F"
    fi
}

# Runs linker and checks output
# $1 = output, rest = arguments
grade_linker() {
    output=$1
    shift 1
    { timeout $TIME mars nc sm linker.s pa $@ $output; } &>/dev/null
    if [ ! -e $output ]; then
	items="$items,A"
    elif [ -z "$(diff -qi $output ../out/$output)" ]; then
	items="$items,P"
    else
	items="$items,F"
    fi
}

#############################
# Start Script

items=""

cd tmp
# rm -rf *
# get-subm proj2-2 $1 &>/dev/null
if [ ! -e linker.s ]; then
    echo "$1,$2,no submission"
    exit
fi

cp "../in/file_utils.s" .

grade_test grade_strlen1
grade_test grade_strlen2

grade_test grade_strncpy1
grade_test grade_strncpy2

grade_test grade_copy_of_str1
grade_test grade_copy_of_str2

grade_test grade_addr_for_symbol1
grade_test grade_addr_for_symbol2
grade_test grade_addr_for_symbol3
grade_test grade_addr_for_symbol4

grade_test_compare grade_add_to_list1 table.txt
grade_test_compare grade_add_to_list2 table.txt
grade_test_compare grade_add_to_list3 table.txt

grade_test grade_hex_to_str1
grade_test grade_hex_to_str2

grade_test grade_inst_needs_relocation1
grade_test grade_inst_needs_relocation2
grade_test grade_inst_needs_relocation3

grade_test grade_relocate_inst1
grade_test grade_relocate_inst2
grade_test grade_relocate_inst3
grade_test grade_relocate_inst4

grade_linker output1 '../in/linker1.out'
grade_linker output2 '../in/linker2.out'
grade_linker output3 '../in/linker3A.out' '../in/linker3B.out'

grade_test check_reg_strlen
grade_test check_reg_strncpy
grade_test check_reg_copy_of_str
grade_test check_reg_addr_for_symbol
grade_test check_reg_add_to_list
grade_test check_reg_hex_to_str
grade_test check_reg_inst_needs_relocation
grade_test check_reg_relocate_inst

line="$1,${2}${items}"
echo $line

