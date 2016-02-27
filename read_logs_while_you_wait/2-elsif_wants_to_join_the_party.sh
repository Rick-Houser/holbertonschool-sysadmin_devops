#!/bin/bash

# variable set to input file
file="$1"
# loop through input file content including last line
# code after || ensures final line is read without \n char
while read line || [[ -n "$line" ]];
do # increment each time the words "HEAD" or "GET" is found
    if echo $line | grep -q 'HEAD'; then
	((HEAD++))
    elif echo $line | grep -q 'GET'; then
       ((GET++))
    fi
done < $file # exit when reaching end of file
echo $HEAD
echo $GET
