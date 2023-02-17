## Git setup

---

- Create a DX project locally.
- Create a new repo in GitHub/GitLab or any VCS hosting service of your choice.
    - Do not include a README.
- Check & set git config variables
    
    ```bash
    # Check list
    git config --list
    
    # Set email & name locally
    git config user.email <github account email> --local
    git config user.name <github account name> --local
    
    # Optional: Set email and name globally
    git config user.email <github account email> --global
    git config user.name <github account name> --global
    ```
    
- Run the following commands in the given order.
    
    ```bash
    # Change dir to the newly created project
    cd ~/<path to your dx project root>
    
    # Initialize the git repo
    git init
    
    # Connect local git repo to the remote repo
    git remote add origin <remoteLink>
    
    # Run git pull
    git pull origin main
    ```
    
- Resolve any conflicts and run git push
    
    ```bash
    # Set upstream and push
    git push --set-upstream origin/main main
    ```