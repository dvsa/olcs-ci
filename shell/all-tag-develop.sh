#!/usr/bin/env bash

# tag to create, a release this will expect to find a release branch named "release/X" X = tag
tag=$1

if [ -e $tag ]; then
  echo "Tag not specified"
  exit
fi

source config.sh

echo "Tag : $tag"
echo

cloneAll

startPath=`pwd`
for dir in "${repos[@]}"; do
  echo
  echo "== $dir =="
  echo

  cd $startPath/$dir

  # syntax check PHP
  for file in $(find . -type f \( -name "*.php" -or -name "*.phtml" \));
  do
      php -l $file || exit;
  done

  # todo unittests

  # create composer.lock and commit it
  if [ -f composer.json ]; then
    composer update
    git add composer.lock -f
    git commit -m"Update Composer for $tag"
  fi

  # add the tag
  git tag -a $tag -m"Tagged $tag" || exit
  git push --tags

  # remove composer.lock
  if [ -f composer.json ]; then
    git rm composer.lock
    git commit -m"Removing lock file after tagging $tag"
  fi

done
