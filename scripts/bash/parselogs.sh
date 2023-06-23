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
       
        jsonValue=$(echo $jsonObj | jq '.trigger_type' | sed -e 's/^"//' -e 's/"$//')
        # echo $jsonValue
        
        jsonWithRunTime=$(echo $jsonObj | jq --arg r "${runTimeValue}" '.runtime += $r')
        # echo $jsonWithRunTime

        echo $jsonWithRunTime | jq . | tee ~/Desktop/PTLogs/json/ProcessedRunTimeArrays/"${f%.json}_$jsonValue".json
    done
done

pushd ~/Desktop/PTLogs/json/ProcessedRunTimeArrays/

for f in *.json
do
   cat $f | jq -r 'to_entries |map(.key),map(.value)|@csv' | tee ~/Desktop/PTLogs/csv/"${f%.json}".csv
done

# Change directory
pushd ~/Desktop/PTLogs/csv/
# Combine all CSVs into a single CSV file.
awk '(NR == 1) || (FNR > 1)' *.csv > combined.csv

headerValues=$(head -n 1 combined.csv)
echo $headerValues

for v in $headerValues
do
    echo -e "${yellow}value is:${clear}"$v
done

# sed -i 's/user_name/user_name__c' combined.csv