# backup your branch
git checkout -b $1

# reset the current branch
git checkout $2 && git reset --soft $(git rev-list --max-parents=0 HEAD)

# stage & commit the changes
git add . && git commit -m "Initial commit"

# force push the changes
git push --force origin $2

# command to run the script
# bash ./scripts/git/clear_all_commits.sh <new-branch-name> <branch-name-to-clear>
