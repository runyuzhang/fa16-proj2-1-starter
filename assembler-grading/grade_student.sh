#!/bin/bash

# Grading script for CS61C Summer 2015 Projec/Users/derekahmed/Desktop/assembler-grading/grade_student.sht 2-1: Assembler Project
# This script grades the work of an individual student.
# Arguments: $1 = login, $2 = name, $3 = diagnostic

# Config
TIME=10s
intfile=tmpint.txt
if [ -z "$3" ]; then
    diagnostic=0
else
    diagnostic=$3
fi

####################################
# Helper Functions

# Arguments: <test name> <mode>
run_assembler() {
    if [ $2 -eq 1 ]; then
	{ timeout $TIME ./assembler -p1 ../test_input/${1}.s out/${1}.out -log log/${1}.txt; } &>/dev/null
    elif [ $2 -eq 2 ]; then
	{ timeout $TIME ./assembler -p2 ../test_input/${1}.s out/${1}.out -log log/${1}.txt; } &>/dev/null
    else
	{ timeout $TIME ./assembler ../test_input/${1}.s $intfile out/${1}.out -log log/${1}.txt; } &>/dev/null
    fi
}

# Arguments: <test name> <check out?> <check log?>
check_differences() {
    # Are outputs the same?
    if [ $2 -eq 1 ] && [ -z "$(diff -qi out/${1}.out ../test_output/${1}.out)" ]; then
	same_out=1
    elif [ "$1" == "li_pass" ] && [ -z "$(diff -qi out/${1}.out ../test_output/li_pass2.out)" ]; then
	same_out=1
    elif [ "$1" == "li_simple" ] && [ -z "$(diff -qi out/${1}.out ../test_output/li_simple2.out)" ]; then
	same_out=1
    else
	if [ $diagnostic -eq 1 ] && [ $2 -eq 1 ]; then
	    echo "Difference in output of $1:"
	    diff -i out/${1}.out ../test_output/${1}.out
	fi
	same_out=0
    fi

    # Are logs the same?
    if [ $3 -eq 1 ] && [ -z "$(diff -qi log/${1}.txt ../test_log/${1}.txt)" ]; then
	same_log=1
    else
        if [ $diagnostic -eq 1 ] && [ $3 -eq 1 ]; then
	    echo "Difference in log of $1:"
            diff -i log/${1}.txt ../test_log/${1}.txt
        fi
	same_log=0
    fi

    # Determine return value
    if [ $2 -eq 1 ] && [ $3 -eq 1 ] && [ $same_out -eq 1 ] && [ $same_log -eq 1 ]; then
	return 1
    elif [ $2 -eq 1 ] && [ $same_out -eq 1 ]; then
	return 1
    elif [ $3 -eq 1 ] && [ $same_log -eq 1 ]; then
	return 1
    else
	return 0
    fi
}



#######################################
# Run Script

cd tmp
# rm -rf * &>/dev/null
# get-subm proj2-1 $1 &>/dev/null


########################################


report="TESTING REPORT: PROJECT 2-1"
echo -e $report >> ../reports/${1}.txt
report="Student: ${2}\nLogin: ${1}"
echo -e $report >> ../reports/${1}.txt
########################################


touch ../reports/${1}.txt
login=${1}
name=${2}
secscore=0
one=1
two=2
three=3
#####################################
# Grading Functions

# Arguments: <test name> <point value> <executable> <args>
grade() {
    name=$1
    pointval=$2
    maxval=$pointval
    if [ ! -e $3 ]; then
        items="$items,C"
        report="[COMPILE ERROR] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
        return
    fi
    shift 2
    { timeout $TIME ./$@; } &>/dev/null
    if [ $? -eq 0 ]; then
	   score="$((score + pointval))"
        items="$items,P"
        report="[      OK     ] ${1} ${maxval}/${pointval}"
        echo -e $report >> ../reports/${login}.txt
        secscore=$((secscore + pointval))
    elif [ $? -eq 139 ]; then
        items="$items,S"
        report="[   SEGFAULT  ] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
    else
	items="$items,F"
        report="[     FAIL    ] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
    fi
}

# Arguments: <test name> <point value> <mode> <check out?> <check log?>
grade_assembler() {
    name=$1
    pointval=$2
    if [ ! -e assembler ]; then
        items="$items,C"
        report="[COMPILE ERROR] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
        return
    fi
    run_assembler $1 $3
    if [ $? -eq 139 ]; then
        items="$items,S"
        report="[   SEGFAULT  ] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
        return
    fi
    check_differences $1 $4 $5

    if [ $? -eq 1 ]; then
	   score="$((score + $2))"
        items="$items,P"
        report="[      OK     ] ${1} ${pointval}/${pointval}"
        echo -e $report >> ../reports/${login}.txt
        secscore=$((secscore + pointval))
    else
	items="$items,F"
        report="[     FAIL    ] ${1} 0/${pointval}"
        echo -e $report >> ../reports/${login}.txt
    fi
}

grade_branch() {
    name=$1
    pointval=1
    if [ ! -e grade-branch ]; then
	items="$items,C"
    report="[COMPILE ERROR] grade_branch 0/1"
    echo -e $report >> ../reports/${login}.txt
    else
	{ timeout $TIME ./grade-branch 0; } &>/dev/null
	if [ $? -eq 139 ]; then
	    items="$items,S"
        report="[   SEGFAULT  ] grade_branch 0/1"
        echo -e $report >> ../reports/${login}.txt
	elif [ -z "$(diff -qi out/branch.out ../test_output/branch.out)" ]; then
        score="$((score + 1))"
	    items="$items,P"
        report="[      OK     ] grade_branch 1/1"
        echo -e $report >> ../reports/${login}.txt
        secscore=$((secscore + pointval))
	else
	    if [ $diagnostic -eq 1 ]; then
		echo "Difference in branch:"
		diff -i out/branch.out ../test_output/branch.out
	    fi
	    items="$items,F"
        report="[     FAIL    ] grade_branch 0/1"
        echo -e $report >> ../reports/${login}.txt
	fi
    fi
}


#####################################


if [ ! -e assembler.c ]; then
    echo "$1,$2,no submission"
    exit
fi


items=""

cp ../staff/{Makefile,grade_translate.c,grade_tables.c,grade_branch.c} .
if [ ! -e src/utils.h ]; then
    cp ../staff/utils.h src
fi
if [ ! -e src/utils.c ]; then
    cp ../staff/utils.c src
fi
make clean &>/dev/null
rm -f grade-*
mkdir out
mkdir log

# Grade translate_utils.c
report="\ntranslate_utils.c TESTS"
echo -e $report >> ../reports/${1}.txt

make grade-translate &>/dev/null
secscore=0
grade tr_reg1 2 grade-translate reg 0
grade tr_reg2 2 grade-translate reg 1
grade tr_num1 2 grade-translate num 0
grade tr_num2 2 grade-translate num 1
grade tr_num3 2 grade-translate num 2
report="\nSubscore: $secscore out of 10"
echo -e $report >> ../reports/${1}.txt
percentage=""

# Grade tables.c
report="\ntables.c TESTS"
echo -e $report >> ../reports/${1}.txt
secscore=0
make grade-tables &>/dev/null
grade tables1 3 grade-tables 0
grade tables2 3 grade-tables 1
grade tables3 3 grade-tables 2
grade tables4 3 grade-tables 3
if [ ! -e grade-tables ]; then
    items="$items,C"
        report="[COMPILE ERROR] grade_tables 0/3"
        echo -e $report >> ../reports/${login}.txt
else
    { valgrind --tool=memcheck --leak-check=full --log-file=valgrind_out.txt ./grade-tables 3; } &>/dev/null
    if [ -n "$(grep '0 errors from 0 contexts' valgrind_out.txt)" ]; then
	   score="$((score + 3))"
        items="$items,P"
        report="[      OK     ] grade_tables 3/3"
        echo -e $report >> ../reports/${login}.txt
        secscore=$((secscore + three))
    elif [ $? -eq 139 ]; then
        items="$items,S"
        report="[   SEGFAULT  ] grade_tables 0/3"
        echo -e $report >> ../reports/${login}.txt
    else
	items="$items,F"
    report="[     FAIL    ] grade_tables 0/3"
    echo -e $report >> ../reports/${login}.txt
    fi
fi
report="\nSubscore: $secscore out of 15"
echo -e $report >> ../reports/${1}.txt


# Grade most instruction translation
cp ../staff/{tables.c,translate_utils.c} src

report="\nINSTRUCTION TESTS"
echo -e $report >> ../reports/${1}.txt
secscore=0
# Arguments: <test name> <point value> <mode> <check out?> <check log?>
make assembler &>/dev/null
grade_assembler rtypes       3 2 1 0
grade_assembler sll_pass     1 2 1 0
grade_assembler sll_fail     1 2 0 1
grade_assembler addiu_simple 1 2 1 0
grade_assembler addiu_pass   1 2 1 0
grade_assembler addiu_fail   1 2 0 1
grade_assembler ori_simple   1 2 1 0
grade_assembler ori_pass     1 2 1 0
grade_assembler ori_fail     1 2 0 1
grade_assembler lui_simple   1 2 1 0
grade_assembler lui_pass     1 2 1 0
grade_assembler lui_fail     1 2 0 1
grade_assembler mem_simple   1 2 1 0
grade_assembler mem_pass     1 2 1 0
grade_assembler mem_fail     1 2 0 1
grade_assembler jumps        2 0 1 0
report="\nSubscore: $secscore out of 19"
echo -e $report >> ../reports/${1}.txt


# Grade branches
report="\nBRANCH TESTS"
echo -e $report >> ../reports/${1}.txt
secscore=0

cp assembler.c assembler_nomain.c
sed -i 's/int main(/int zzz_unsused(/g' assembler_nomain.c
make grade-branch &>/dev/null

grade_branch
grade branch2 1 grade-branch 1
report="\nSubscore: $secscore out of 2"
echo -e $report >> ../reports/${1}.txt

# Grade pseudoinstruction expansion
report="\nPSEUDOINSTRUCTION TESTS"
echo -e $report >> ../reports/${1}.txt
secscore=0

grade_assembler li_simple 1 1 1 0
grade_assembler li_pass   1 1 1 0
grade_assembler li_addiu  1 1 1 0
grade_assembler li_fail   1 1 0 1
grade_assembler mul       1 1 1 0
grade_assembler quo       1 1 1 0
grade_assembler rem       1 1 1 0
report="\nSubscore: $secscore out of 9"
echo -e $report >> ../reports/${1}.txt

    
# Grade full process/error messages
report="\nCOMMENT AND ERROR MESSAGE TESTS"
echo -e $report >> ../reports/${1}.txt
secscore=0

grade_assembler comments  1 0 1 0
grade_assembler p1_errors 1 1 0 1
grade_assembler p2_errors 1 0 0 1
grade_assembler combined  2 0 1 0
report="\nSubscore: $secscore out of 5"
echo -e $report >> ../reports/${1}.txt

report="\nTotal Score: $score out of 60"
echo -e $report >> ../reports/${1}.txt

report="\n$ ${login},$score"
echo -e $report >> ../reports/${1}.txt

# Write to CSV file
echo "$1,$2$items"
