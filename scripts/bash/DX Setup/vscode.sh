function runVSCodeChecks() {
  echo "$(tput setaf 3)-----------------------------------"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)|          VS Code Checks         |"
  echo "$(tput setaf 3)|                                 |"
  echo "$(tput setaf 3)-----------------------------------"
  tput setaf 6
  code -v
  if [[ $? != 0 ]]; then
    echo
    echo "$(tput setaf 2)Installing vscode..."
    brew cask install visual-studio-code

    echo
    echo "$(tput setaf 2)Installing Extensions!"
    code --install-extension chuckjonas.apex-pmd
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension eamodio.gitlens
    code --install-extension esbenp.prettier-vscode
    code --install-extension FinancialForce.lana
    code --install-extension salesforce.salesforce-vscode-slds
    code --install-extension salesforce.salesforcedx-vscode
    code --install-extension salesforce.salesforcedx-vscode-apex
    code --install-extension salesforce.salesforcedx-vscode-apex-debugger
    code --install-extension salesforce.salesforcedx-vscode-apex-replay-debugger
    code --install-extension salesforce.salesforcedx-vscode-core
    code --install-extension salesforce.salesforcedx-vscode-lightning
    code --install-extension salesforce.salesforcedx-vscode-lwc
    code --install-extension salesforce.salesforcedx-vscode-soql
    code --install-extension salesforce.salesforcedx-vscode-visualforce
  else
    echo "$(tput setaf 2)VS Code is already installed!"
    echo "$(tput setaf 2)Installing Extensions!"
    code --install-extension chuckjonas.apex-pmd
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension eamodio.gitlens
    code --install-extension esbenp.prettier-vscode
    code --install-extension FinancialForce.lana
    code --install-extension salesforce.salesforce-vscode-slds
    code --install-extension salesforce.salesforcedx-vscode
    code --install-extension salesforce.salesforcedx-vscode-apex
    code --install-extension salesforce.salesforcedx-vscode-apex-debugger
    code --install-extension salesforce.salesforcedx-vscode-apex-replay-debugger
    code --install-extension salesforce.salesforcedx-vscode-core
    code --install-extension salesforce.salesforcedx-vscode-lightning
    code --install-extension salesforce.salesforcedx-vscode-lwc
    code --install-extension salesforce.salesforcedx-vscode-soql
    code --install-extension salesforce.salesforcedx-vscode-visualforce
  fi
  echo
  tput setaf 7
}
