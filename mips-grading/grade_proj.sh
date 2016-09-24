#!/bin/bash

# Grades all proj1-1 submissions.

ROSTER=roster.txt

if [[ ! -e "$ROSTER" ]]; then
  echo "No roster.txt found."
  exit 0
fi

if [[ -e "gradebook.csv" ]]; then
  echo "Old gradebook will be moved to gradebook.csv.bak"
  if [[ -e "gradebook.csv.bak" ]]; then
    echo "Overwriting gradebook.csv.bak"
  fi
  mv gradebook.csv gradebook.csv.bak
fi

while read line
do
  IFS=$' ' read -a array <<< "$line"
  login=${array[0]}
  name=${array[1]}
  echo "grading $login"
  ./grade_student.sh $login $name 0 >> gradebook.csv
done < $ROSTER

exit 0
