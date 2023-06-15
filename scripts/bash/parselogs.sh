#!/bin/bash

function runTime() { 
    runTime=$(echo "$1,$2,$3" | awk -F, '{ print (($1 - $2) * $3)}')
    echo $runTime
}

pushd ~/Desktop/PTLogs

# https://linuxhint.com/bash-for-loop-examples/

for f in *.log
do
    # Print the string value
    # https://www.linode.com/docs/guides/how-to-grep-for-text-in-files/
    echo $f
    cat $f | sed '/^[[:space:]]*$/d' | tee ./nonewline/$f
done

declare -A runTime_log_array

pushd ~/Desktop/PTLogs/nonewline
for f in *.log
do
    # Print the string value
    # https://www.linode.com/docs/guides/how-to-grep-for-text-in-files/
    echo $f
    startTime=$(sed -n '2p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    endTime=$(sed -n '$p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    runTime=$(runTime "$endTime,$startTime,1000")
    echo "$runTime"
    runTime_log_array["${f%.*}"]="$runTime"
    cat $f | grep -E "USER_DEBUG|FATAL_ERROR|EXCEPTION_THROWN|_ERROR" | tee .././grep/$f
done

pushd ~/Desktop/PTLogs/grep/

for f in *.log
do
    echo $f
    # https://stackoverflow.com/questions/4168371/how-can-i-remove-all-text-after-a-character-in-bash
    # https://tecadmin.net/linux-jq-command/
    # https://stackoverflow.com/questions/51183073/extract-json-data-from-log-file
    echo "${runTime_log_array["${f%.*}"]}" # Value for the passed key
    grepop=$(cat $f | grep -o '{".*}')
    echo $grepop | jq -s . | tee ~/Desktop/PTLogs/json/first/"${f%.log}".json
done

pushd ~/Desktop/PTLogs/json/first/

for f in *.json
do
    jq -c '.[]' $f | while read i; do
        # Print individual objects within the json array
        jsonObj=$(echo $i)
        echo $jsonObj

        # Print the trigger type value
        jsonValue=$(echo $jsonObj | jq '.trigger_info.trigger_type' | sed -e 's/^"//' -e 's/"$//')
        echo $jsonValue
        
        # Append trigger type to file name
        echo $jsonObj | jq . | tee ~/Desktop/PTLogs/json/second/"${f%.json}_$jsonValue".json

    done
done