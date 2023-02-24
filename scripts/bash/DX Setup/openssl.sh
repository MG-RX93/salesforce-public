function runOpenSSlChecks() {
  echo "$(tput setaf 3)-----------------------------------"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)|         OpenSSL Checks          |"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)-----------------------------------"
  tput setaf 6

  which openssl
  if [[ $? != 0 ]]; then
    echo
    echo "$(tput setaf 2)Installing OpenSSL..."
    read -p "$(tput setaf 3)Enter OpenSSL Homebrew package name: " pkgName
    brew install "$pkgName"
  else
    echo
    echo "$(tput setaf 2)Java's already installed..."
  fi
  echo
  tput setaf 7
}
