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
  git merge origin/$releaseBranch || continue



TODO check if changes from master branchm if NO changes then DON'T add the tag

!!! NB release branch will have the release commit, which will make it look different when it shouldn't be !!!!

exit




  diff=`git diff --name-only $previousTag $releaseBranch`
  if [ -n "$diff" ]; then
    # If there are changes then tag the repo
    git tag -a $tag -m"Tagged $tag" || exit

    git push origin master
    git push --tags
  fi

  git push origin --delete $releaseBranch
done
