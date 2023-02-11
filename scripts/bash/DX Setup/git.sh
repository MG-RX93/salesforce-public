#!/bin/bash
function runGitChecks() {
  echo "-------------------------------------------------------------------------------------------------------------------------"
  echo
  echo "$(tput setaf 3)Running git Checks"
  tput setaf 6
  #checking to see if salesforce sfdx CLI exists and if not, install it.
  git --version
  if [[ $? != 0 ]]; then
    echo
    echo "$(tput setaf 2)Installing git..."
    brew install git
  else
    echo
    echo "$(tput setaf 2)git's already installed!!!..."
  fi
  echo
  echo "-------------------------------------------------------------------------------------------------------------------------"
}
