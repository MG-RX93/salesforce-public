#!/bin/bash

# Process timestamps & get runtime
function runTime() { 
    runTime=$(echo "$1,$2,$3" | awk -F, '{ print (($1 - $2) * $3)}')
    echo $runTime
}

# Change directory
pushd ~/Desktop/PTLogs

# Loop through log files & remove empty lines from all files
for f in *.log
do
    # echo $f
    cat $f | sed '/^[[:space:]]*$/d' | tee ./nonewline/$f #remove empty lines
done

# declare associative array
declare -A runTime_log_array 

# Change directory
pushd ~/Desktop/PTLogs/nonewline
# Loop through processed log files.
# Grab startTime & endTime to get runTime.
# Assign runTime to the associative array var.
# Grab only those lines with USER_DEBUG & create a processed log file.
for f in *.log
do
    # Print the string value
    echo $f
    startTime=$(sed -n '2p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    endTime=$(sed -n '$p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    runTime=$(runTime "$endTime,$startTime,1000")
    echo "$runTime"
    runTime_log_array["${f%.*}"]="$runTime"
    cat $f | grep -E "USER_DEBUG|FATAL_ERROR|EXCEPTION_THROWN|_ERROR" | tee .././grep/$f
done

# Change directory
pushd ~/Desktop/PTLogs/grep/
# Loop through processed log files.
# Use grep to only pull json output.
# Convert grepop to json & create a processed json file.
for f in *.log
do
    echo $f
    echo "${runTime_log_array["${f%.*}"]}" # Value for the passed key
    grepop=$(cat $f | grep -o '{".*}')
    echo $grepop | jq -s . | tee ~/Desktop/PTLogs/json/first/"${f%.log}".json
done

# Change directory
pushd ~/Desktop/PTLogs/json/first/
# Loop through processed json files.
# Append trigger type to file name to make it unique & create new file for each trigger type.
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

# Change directory
pushd ~/Desktop/PTLogs/json/second/
# Loop through processed json files.
# Add runtime as item to each json object.
for f in *.json
do
    runTimeValue=$(echo "${runTime_log_array["${f%.*}"]}")
    cat $f | jq --arg r "${runTimeValue}" '.transaction_info.runtime += $r' | tee ~/Desktop/PTLogs/json/final/"${f}"
done