# This code is not my own solution. Code by Rick Harris
# I'm creating a copy because I like his usage of a regex within awk.
# You can view the original code here:
# https://github.com/rickharris-dev/holbertonschool-sysadmin_devops/blob/master/awk_can_do_it/2-dig_the-data.sh

#!/bin/bash
awk '{ 
    for ( i = 2; i <= NF; i++ ){ 
        if ($i ~ /^[0-9][0-9][0-9]$/) { 
            print $1, $i 
        } 
    } 
}' ${1} |  sort | uniq -c | sort -n
