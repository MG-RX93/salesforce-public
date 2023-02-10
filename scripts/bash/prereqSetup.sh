echo "-------------------------------------------------------------------------------------------------------------------------"
echo "$(tput setaf 3)Running Homebrew Checks"
#checking to see if brew exists and if not, install it. 
tput setaf 6;
which -s brew
if [[ $? != 0 ]] ; then
    echo
    echo "$(tput setaf 2)Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo
    echo "$(tput setaf 2)brew installed already, updating brew..."
    brew update
    # Run the below option manually.
    # brew upgrade
fi
echo
echo "-------------------------------------------------------------------------------------------------------------------------"

echo
echo "$(tput setaf 3)Running git Checks"
tput setaf 6;
#checking to see if salesforce sfdx CLI exists and if not, install it.
git --version
if [[ $? != 0 ]] ; then
    echo
    echo "$(tput setaf 2)Installing git..."
    brew install git
else
    echo
    echo "$(tput setaf 2)git's already installed dummy!!!..."
fi
echo
echo "-------------------------------------------------------------------------------------------------------------------------"