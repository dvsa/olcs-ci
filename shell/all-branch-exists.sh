#!/usr/bin/env bash

# tag to create, a release this will expect to find a release branch named "release/X" X = tag
branch=$1

if [ -e $branch ]; then
  echo "Branch not sepcified, Eg 'release/4.0.2'"
  exit
fi

source config.sh

echo "Branch : $branch"
echo

#cloneAll

cd $reposDir
startPath=`pwd`
for dir in "${OLCS_CI_REPOS[@]}"; do
  echo
  echo "== $dir =="
  echo

  cd $startPath/$dir

  git checkout -q $branch || continue

  echo "!!!!! $branch EXISTS !!!!!"
done
