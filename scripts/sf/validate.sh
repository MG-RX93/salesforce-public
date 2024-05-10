#!/bin/sh
set -a  # Automatically export all vars
. ./.env
set +a  # Disable Automatic export

sf project deploy validate --source-dir $DIR_NAME --async --test-level RunSpecifiedTests --tests $SPECIFIED_TESTS