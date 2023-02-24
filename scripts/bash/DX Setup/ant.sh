function runAntChecks() {
  echo "$(tput setaf 3)-----------------------------------"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)|           Ant Checks            |"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)-----------------------------------"
  tput setaf 6

  ant -version
  if [[ $? != 0 ]]; then
    echo
    echo "$(tput setaf 2)Installing ant..."
    read -p "$(tput setaf 3)Enter ant package name: " pkgName
    brew install "$pkgName"
  else
    echo
    echo "$(tput setaf 2)Ant's already installed..."
  fi
  echo
  tput setaf 7
}
