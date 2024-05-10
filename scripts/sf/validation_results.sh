#!/bin/sh
set -a  # Automatically export all vars
. ./.env
set +a  # Disable Automatic export

sf project deploy report --job-id $JOB_ID --json | tee docs/$DIR_NAME/validation_results/$JOB_ID.json