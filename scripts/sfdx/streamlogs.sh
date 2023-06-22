#!/bin/bash

read -p "Enter org name(avoid spaces): " orgName
read -p "Enter file name(avoid spaces): " fileName
# Stream logs
sfdx apex tail log -c -d=Finest -o "$orgName" | tee ~/Desktop/PTLogs/"$fileName".log
# sfdx apex tail log -c -d=Finest -o NA91 | tee ~/Desktop/PTLogs/test3.log

read -p "Enter Test Class name(avoid spaces): " testClassName
# Run unit tests
sfdx apex run test -n "$testClassName" -o "$orgName" -r json