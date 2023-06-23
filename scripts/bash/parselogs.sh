#!/opt/homebrew/bin/bash

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


red='\033[0;31m'
yellow='\033[0;33m'
clear='\033[0m'

# declare -A fruits_prices
# fruits_prices[cherry]=24
# fruits_prices[berry]=27
# echo -e "${red}Array value:${clear}"${fruits_prices[@]}
# echo -e "${red}Array key:${clear}"${!fruits_prices[@]}

# declare associative array
declare -A runTimeArray 
echo "Array Value: "$runTimeArray


# Change directory
pushd ~/Desktop/PTLogs/nonewline
# Loop through processed log files.
# Grab startTime & endTime to get runTime.
# Assign runTime to the associative array var.
# Grab only those lines with USER_DEBUG & create a processed log file.
for f in *.log
do
    # Print the string value
    # echo $f
    startTime=$(sed -n '2p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    endTime=$(sed -n '$p' $f | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 + ($4 / 1000)}')
    runTime=$(runTime "$endTime,$startTime,1000")
    # echo "$runTime"
    # echo -e "${red}File name:${clear}"${f%.*}
    runTimeArray["${f%.*}"]=$runTime
    
    
    echo -e "${red}UpdatedArray key:${clear}"${!runTimeArray[@]}
    echo -e "${red}UpdatedArray value:${clear}"${runTimeArray[*]}
    cat $f | grep -E "USER_DEBUG|FATAL_ERROR|EXCEPTION_THROWN|_ERROR" | tee .././grep/$f
done

echo -e "${yellow}UpdatedArray key :${clear}""${!runTimeArray[@]}"
echo -e "${yellow}UpdatedArray value :${clear}"${runTimeArray[*]}

# Change directory
pushd ~/Desktop/PTLogs/grep/
# Loop through processed log files.
# Use grep to only pull json output.
# Convert grepop to json & create a processed json file.
for f in *.log
do
    # echo $f
    # echo "${runTimeArray["${f%.*}"]}" # Value for the passed key
    echo -e "${yellow}Array value:${clear}""${runTimeArray["${f%.*}"]}" # Value for the passed key
    grepop=$(cat $f | grep -o '{".*}')
    echo $grepop | jq -s . | tee ~/Desktop/PTLogs/json/UnprocessedArrays/"${f%.log}".json
done

# Change directory
pushd ~/Desktop/PTLogs/json/UnprocessedArrays/
for f in *.json
do
    runTimeValue=$(echo "${runTimeArray["${f%.*}"]}")
    echo -e "${red}RunTime value:${clear}"$runTimeValue
    jq -c '.[]' $f | while read i; do
     # Print individual objects within the json array
        jsonObj=$(echo $i)

        
        jsonWithRunTime=$(echo $jsonObj | jq --arg r "${runTimeValue}" '.runtime += $r')
        echo $jsonWithRunTime
    done
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
        # echo $jsonObj

        # Print the trigger type value
        jsonValue=$(echo $jsonObj | jq '.trigger_type' | sed -e 's/^"//' -e 's/"$//')
        # echo $jsonValue
        
        # Append trigger type to file name
        echo $jsonObj | jq . | tee ~/Desktop/PTLogs/json/second/"${f%.json}_$jsonValue".json

    done
done

# # Change directory
# pushd ~/Desktop/PTLogs/json/second/
# # Loop through processed json files.
# # Add runtime as item to each json object.
# for f in *.json
# do
#     runTimeValue=$(echo "${runTimeArray["${f%.*}"]}")
#     echo -e "${red}RunTime value:${clear}"$runTimeValue
#     cat $f | jq --arg r "${runTimeValue}" '.runtime += $r' | tee ~/Desktop/PTLogs/json/final/"${f}"
# done


pushd ~/Desktop/PTLogs/json/final/
# jq -s '.' *.json | tee ./stitched.json

for f in *.json
do
   cat $f | jq -r 'to_entries |map(.key),map(.value)|@csv' | tee ~/Desktop/PTLogs/csv/"${f%.json}".csv
done

# Change directory
pushd ~/Desktop/PTLogs/csv/
# Combine all CSVs into a single CSV file.
awk '(NR == 1) || (FNR > 1)' *.csv > combined.csv
