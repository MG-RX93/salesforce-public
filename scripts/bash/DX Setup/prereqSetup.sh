# Run Homebrew checks
. scripts/bash/DX%20Setup/homebrew.sh
runHomebrewChecks

# Run Git checks
. scripts/bash/DX%20Setup/git.sh
runGitChecks

# Run Java checks
. scripts/bash/DX%20Setup/java.sh
runJavaChecks

# Run Ant checks
. scripts/bash/DX%20Setup/ant.sh
runAntChecks

# Run VS Code checks
. scripts/bash/DX%20Setup/vscode.sh
runVSCodeChecks

# Run OpenSSL checks
. scripts/bash/DX%20Setup/openssl.sh
runOpenSSlChecks
