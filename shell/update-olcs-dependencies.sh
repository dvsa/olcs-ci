#!/usr/bin/env bash

# tag to create, a release this will expect to find a release branch named "release/X" X = tag
branch=$1

if [ -e $branch ]; then
  echo "Branch not sepcified, Eg 'release/4.0.2'"
  exit
fi

source config.sh

# Override repos as we only need these three
repos=(
  "olcs-backend"
  "olcs-internal"
  "olcs-selfserve"
)

echo "Repos : ${repos[*]}"
echo "Branch : $branch"
echo

cloneAll

cd $reposDir
startPath=`pwd`
for dir in "${repos[@]}"; do
  echo
  echo "== $dir =="
  echo

  cd $startPath/$dir

  git checkout -q $branch || exit

  ant composer-update-olcs

  git add composer.lock

  git commit -m'Update olcs/* dependencies'

  if [ $dryRun = "false" ]; then
    git push || exit 1
  else
    echo "DRYRUN - git push"
  fi
done
