#!/bin/bash

#####################################################
# Author: Rick Houser                               #
# Script: Text2Audio                                #
#                                                   #
# What it does: Shell script takes 3 parameters.    #
# First parameter is your text string.              #
# Second parameter is your choice of voice:         #
#   f(female), m(male), x(robot)                    #
# Third parameter is the destination IP address.    #
#                                                   #
# Example:                                          # 
# <scriptname> "My text string here" f <IP_ADDRESS> #        
#####################################################

# Takes first word from first parameter and save to FILE
FILE=$(echo $1 | awk '{ print $1 }')

# Sets voice according to users input
case $2 in 
f)
  VOICE="Karen"
  ;;
m)
  VOICE="Alex"
  ;;
x)
  VOICE="Bad"
  ;;
esac

# Saves message($1) with voice type($2) into FILE.mp4
# where FILE is the first word of the message($1)
say $1 -v $VOICE -o $FILE.m4a

# Transfer file to server
scp -q $FILE.m4a admin@$3:/usr/share/nginx/html

# Direct user to where audio file can be heard
echo "$FILE.m4a"
echo "Listen to the message on http://$3/$FILE.m4a"