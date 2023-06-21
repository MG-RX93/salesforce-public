#!/bin/bash

read -p "Enter org name(avoid spaces): " orgName
read -p "Enter file name(avoid spaces): " fileName
# Stream logs
sfdx apex tail log -c -d=Debug -o "$orgName" | tee ~/Desktop/PTLogsDump/"$fileName".log

read -p "Enter Test Class name(avoid spaces): " testClassName
# Run unit tests
sfdx force:apex:test:run -n "$testClassName" -o "$orgName" -r json