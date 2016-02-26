#!/bin/bash

# variable set to input file
file="$1"

# loop through input file's content printing each line
while read line;
do
    echo $line
done < $file # exit when reaching end of file
