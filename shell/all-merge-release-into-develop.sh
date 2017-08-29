#!/usr/bin/env bash

echo "Merge all release branches into develop"

releaseBranch=$1

if [ -e $releaseBranch ]; then
  echo "Release branch not specified eg release/x.y"
  exit
fi

source config.sh

echo "Release branch : $releaseBranch"
echo

cloneAll

cd $reposDir
startPath=`pwd`
for dir in "${repos[@]}"; do
  echo
  echo "== $dir Merge release branch $releaseBranch into develop =="
  echo

  cd $startPath/$dir

  git checkout develop

  # Merge but don;t commit
  git merge --no-commit origin/$releaseBranch || continue

  # Remove the composer.lock if it has been merged in
  if [ -f composer.lock ]; then
    git rm composer.lock -f
  fi

  # Restore composer.json to how it should be
  if [ -f composer.json ]; then
    git checkout origin composer.json
  fi

  git commit -m"Merge $releaseBranch"

  if [ $dryRun = "false" ]; then
    git push || exit 1
  else
    echo "DRYRUN - git push"
  fi

  # Search for JIRA tickets that have been merged onto develop, but should be on the release branch

  # get list of JIRA tickets on develop that aren't on release branch
  tickets=$(git log --oneline origin/${releaseBranch}..develop | grep 'OLCS-[0-9]*' -i --only-matching)

  if [ "$tickets" != "" ]; then
    # iterate of each ticket
    while IFS= read -r ticket ; do
      echo "Looking for '$ticket' in $releaseBranch branch history";
      # search for the ticket on release branch
      matches=$(git log origin/$releaseBranch --oneline --grep=${ticket} -i)
      if [ "$matches" != "" ]; then
        echo "WARNING JIRA $ticket has a commit in develop that is not in $releaseBranch"
        echo $matches
      fi
    done <<< "$tickets"
  fi
done
