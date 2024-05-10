#!/bin/sh
set -a  # Automatically export all vars
. ./.env
set +a  # Disable Automatic export


mkdir temp 
sf project retrieve start --manifest ./manifest/$PACKAGE_NAME/package.xml --target-metadata-dir temp --unzip -o $ORG_NAME
sf project convert mdapi --root-dir temp
  