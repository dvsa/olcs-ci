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

  # Merge but don;t commit
  git merge --no-commit origin/$releaseBranch

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

done
