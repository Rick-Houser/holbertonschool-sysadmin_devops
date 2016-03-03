#!/bin/bash

#####################################################
# Author: Rick Houser                               #
# Script: LogParser                                 #
#                                                   #
# What it does: Script takes a file as parameter.   #
# Parses log file finding 1st and 9th elements.     #
# Sorts, counts and outputs unique elements.        #
# Example:                                          # 
# <scriptname> /path/to/file.log                    #        
#####################################################

log=$1
cat $log | awk '{print $1, $9}' * | uniq -c | sort 