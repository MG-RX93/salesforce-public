function runJavaChecks() {
  echo "$(tput setaf 3)-----------------------------------"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)|           Java Checks           |"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)-----------------------------------"
  tput setaf 6

  java --version
  if [[ $? != 0 ]]; then
    echo
    echo "$(tput setaf 2)Installing java..."
    read -p "$(tput setaf 3)Enter java package name: " pkgName
    brew install "$pkgName"
  else
    echo
    echo "$(tput setaf 2)Java's already installed..."
  fi
  echo
  tput setaf 7
}
