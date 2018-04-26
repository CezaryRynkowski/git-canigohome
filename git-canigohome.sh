#!/bin/bash
workplacePath=${1:/d/Workplace}

gitArray=()
pwd=$(pwd)
canI=true

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

while IFS= read -r -d $'\0';do
    gitArray+=("$REPLY");
done < <(find $workplacePath -name .git -type d -prune -print0)

for i in "${gitArray[@]}"
do
    localRepoPath="${i%/*}"
    RepoPath=$(echo $localRepoPath | cut -c 2-)
    absRepoPath="$pwd$RepoPath" #final path -> todo cd
    absRepoPath=$(echo $absRepoPath | tr -d '\r')

    cd "$absRepoPath/"
    
    if [[ `git status --porcelain --untracked-files=no` ]]; then
        echo -e "$absRepoPath ${RED}Uncommitted  changes!${NC}"
        canI=false
    fi

    if [[ `git log --branches --not --remotes --simplify-by-decoration --decorate --oneline` ]]; then
        echo -e "$absRepoPath ${RED}Unpushed commits!"
        git log --branches --not --remotes --simplify-by-decoration --decorate --oneline
        canI=false
    fi
done

if  "$canI"; then
    echo -e "${GREEN}Yes :)"
else
    echo -e "${RED}NO!"
fi