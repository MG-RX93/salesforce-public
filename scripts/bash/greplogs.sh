#!/bin/bash
# Stream logs
sfdx apex tail log -c --loglevel=debug -d=Debug -o "$orgName" | tee ~/Desktop/PTLogsDump/"$descriptivename".log

# Run unit tests
sfdx force:apex:test:run -n "$TestClassName" -o "$orgName" -r json



# ===================================================
# bulk parse logs 

# 
cd ~/Desktop/PTLogs

# https://linuxhint.com/bash-for-loop-examples/
for f in *.log
do
    # Print the string value
    # https://www.linode.com/docs/guides/how-to-grep-for-text-in-files/
    echo $f
    cat $f | grep -E "USER_DEBUG|FATAL_ERROR|EXCEPTION_THROWN|_ERROR" | tee ~/Desktop/PTLogs/grep/$f
done

# 
cd ~/Desktop/PTLogs/grep/

# 
for f in *.log
do
    # 
    echo $f
    # https://stackoverflow.com/questions/4168371/how-can-i-remove-all-text-after-a-character-in-bash
    # https://tecadmin.net/linux-jq-command/
    # https://stackoverflow.com/questions/51183073/extract-json-data-from-log-file
    cat $f | grep -o '{".*}' | jq '.' | tee "${f%.log}".json
done
