#!/bin/bash
log=$1
cat $log | awk '{print $1 " " $9}'