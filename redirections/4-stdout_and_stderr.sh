#!/bin/bash
cmd=$1
string=$2
echo $2
echo $2 > /tmp/4-stdout_and_stderr
$cmd &> /tmp/4-stdout_and_stderr
cat /tmp/4-stdout_and_stderr
