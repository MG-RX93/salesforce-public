
# Add git remote
git remote add "$remoteName" "$remoteLink"

# check
git remote -v

# pull main branch from remote
git pull origin main

# Compare local and remote branches
git branch -a

# checkout to the branch you wish to push the new dx project
git checkout "$initCommitBranch"

# Add and Commit
git add . && git commit -m "Initial Commit"

# Push changes manually