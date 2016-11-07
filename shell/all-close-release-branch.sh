#!/usr/bin/env bash

# tag to create, a release this will expect to find a release branch named "release/X" X = tag
tag=$1

if [ -e $tag ]; then
  echo "Tag not specified eg \"x.y\". Expects a release brnach to exist called \"release/x.y\""
  exit
fi

source config.sh

echo "Tag : $tag"
echo

changeLog="";

# Merge release into develop
./all-merge-release-into-develop.sh release/$tag || exit

cd $reposDir
startPath=`pwd`
for dir in "${repos[@]}"; do
  echo
  echo "== $dir =="
  echo

  releaseBranch="release/$tag"

  cd $startPath/$dir

  # checkout master or exit if for some reason it doesn't exist
  git checkout master || exit
  # merge in the release branch, if errors then assume the release branch does not exist and continue next repo
  echo "GIT merge origin/$releaseBranch into master"
  git merge origin/$releaseBranch || continue

  # see if any changes, exlcude composer.json
  diff=`git diff origin/master --name-only | grep "composer.json" -v`

  if [ -n "$diff" ]; then
    # If there are changes then tag the repo
    echo "GIT tag -a $tag"
    git tag -a $tag -m"Tagged $tag" || exit

    changeLog="${changeLog}\n${dir} Tagged ${tag}"

    if [ $dryRun = "false" ]; then
      git push origin master | exit
      git push --tags | exit
    else
      echo "DRYRUN - git push origin master"
      echo "DRYRUN - git push --tags"
    fi
  else
    echo "No changes, therefore not tagging this repo"
    changeLog="${changeLog}\n${dir} No changes"
  fi

  if [ $dryRun = "false" ]; then
    echo "GIT delete remote branch $releaseBranch"
    git push origin --delete $releaseBranch | exit;
  else
      echo "DRYRUN - git push origin --delete $releaseBranch"
  fi
done

echo
echo -e $changeLog