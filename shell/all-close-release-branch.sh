#!/usr/bin/env bash

set -e

echo "Close release branches and tag all repos"

# tag to create, a release this will expect to find a release branch named "release/X" X = tag
tag=$1

if [ -e $tag ]; then
  echo "Tag not specified eg \"x.y\". Expects a release brnach to exist called \"release/x.y\""
  exit 1
fi

source config.sh

echo "Tag : $tag"
echo

changeLog="";

# Merge release into develop
./all-merge-release-into-develop.sh release/$tag

cd $reposDir
startPath=`pwd`
for dir in "${OLCS_CI_REPOS[@]}"; do
  releaseBranch="release/$tag"

  echo
  echo "== $dir Merge release branch $releaseBranch into master and then tag =="
  echo

  cd $startPath/$dir

  # checkout master
  git checkout master

  # merge in the release branch, if errors then assume the release branch does not exist and continue next repo
  echo "GIT merge origin/$releaseBranch into master"
  # Ignore this repo if the release branch doesn't exist
  git rev-parse --verify origin/$releaseBranch >/dev/null || continue
  git merge origin/$releaseBranch

  # see if any changes, exlcude composer.json
  diff=`git diff origin/master --name-only | grep "composer.json" -v || true`

  if [ $dryRun = "false" ]; then
    git push
  else
    echo "DRYRUN - git push"
  fi

  if [ -n "$diff" ]; then
    # If there are changes then tag the repo
    echo "GIT tag -a $tag"
    git tag -a $tag -m"Tagged $tag"

    changeLog="${changeLog}\n${dir} Tagged ${tag}"

    if [ $dryRun = "false" ]; then
      git push --tags
    else
      echo "DRYRUN - git push --tags"
    fi
  else
    echo "No changes, therefore not tagging this repo"
    changeLog="${changeLog}\n${dir} No changes"
  fi

  if [ $dryRun = "false" ]; then
    echo "GIT delete remote branch $releaseBranch"
    git push origin --delete $releaseBranch
  else
      echo "DRYRUN - git push origin --delete $releaseBranch"
  fi
done

echo
echo -e $changeLog
