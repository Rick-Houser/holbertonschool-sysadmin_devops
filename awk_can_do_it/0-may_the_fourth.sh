#!/bin/bash
string=$1
echo $string | awk '{print $4}'