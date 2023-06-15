#!/bin/bash
# bulk parse logs 

# 
# time="00:20:40:300"
# seconds=$(echo $time | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
# echo $seconds

function runTime() { 
    runTime=$(echo "$1,$2,$3" | awk -F, '{ print (($1 - $2) * $3)}')
    echo $runTime
}

pushd ~/Desktop/PTLogs

# https://linuxhint.com/bash-for-loop-examples/

# for f in *.log
# do
#     # Print the string value
#     # https://www.linode.com/docs/guides/how-to-grep-for-text-in-files/
#     echo $f
#     cat $f | sed '/^[[:space:]]*$/d' | tee ./nonewline/$f
# done

declare -A runTime_log_array

pushd ~/Desktop/PTLogs/nonewline
for f in *.log
do
    # Print the string value
    # https://www.linode.com/docs/guides/how-to-grep-for-text-in-files/
    echo $f
    startTime=$(sed -n '2p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    endTime=$(sed -n '$p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    # cpuTime=$(echo "$endTime,$startTime,1000" | awk -F, '{ print (($1 - $2) * $3)}')
    runTime=$(runTime "$endTime,$startTime,1000")
    echo "$runTime"
    runTime_log_array["${f%.*}"]="$runTime"
    cat $f | grep -E "USER_DEBUG|FATAL_ERROR|EXCEPTION_THROWN|_ERROR" | tee .././grep/$f
done

# 
pushd ~/Desktop/PTLogs/grep/

# 
for f in *.log
do
    # 
    echo $f
    # https://stackoverflow.com/questions/4168371/how-can-i-remove-all-text-after-a-character-in-bash
    # https://tecadmin.net/linux-jq-command/
    # https://stackoverflow.com/questions/51183073/extract-json-data-from-log-file
    grepop=$(cat $f | grep -o '{".*}' | sed -e 's/$/,/' -e '$s/,$//')
    op="[${grepop}]"
    echo $op | jq '.' | tee ~/Desktop/PTLogs/json/"${f%.log}".json

    # O/p of grep must add commas to the different values it prints or use jq to add commas
done

