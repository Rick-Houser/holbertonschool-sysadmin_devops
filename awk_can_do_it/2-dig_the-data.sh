#!/bin/bash

#####################################################
# Author: Rick Houser                               #
# Script: LogParser                                 #
#                                                   #
# What it does: Script takes a file as parameter.   #
# Parses log file finding 1st and 9th elements.     #
# If 9th ele isn't status code, print 7th element.  #
# Sorts, counts and outputs unique elements.        #
# Example:                                          # 
# <scriptname> /path/to/file.log                    #        
#####################################################

log=$1
awk '{if ($9 == "\"-\"") print $1, $7; else print $1, $9 }' $log | sort | uniq -c | sort
