#!/bin/bash

# variable set to input file
file="$1"

# loop through input file's content
while read line;
do # print each line containing the word "HEAD"
    echo $line | grep HEAD
done < $file # exit when reaching end of file  
