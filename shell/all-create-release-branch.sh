#!/usr/bin/env bash

# release branch to create
releaseBranch=$1

# create from branch, this is optional defaults to teh repos default branch
fromBranch=$2

if [ -z $releaseBranch ]; then
  echo "Release branch not specified eg release/x.y"
  exit
fi

if [ -z $fromBranch ]; then
  echo "Branching repos default"
fi

source config.sh

echo "Release branch : $releaseBranch"
echo "From branch    : $fromBranch"
echo

cloneAll

updateComposerJson() {

  sed -i \
    -e 's/"olcs\/OlcsCommon": "dev-[#a-z0-9\/\.]*"/"olcs\/OlcsCommon": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/olcs-transfer": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-transfer": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/olcs-utils": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-utils": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/olcs-auth": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-auth": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/olcs-document-share": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-document-share": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/olcs-logging": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-logging": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/autoload": "dev-[#a-z0-9\/\.]*"/"olcs\/autoload": "dev-'${releaseBranch/\//\\\/}'"/g' \
    composer.json
}

cd $reposDir
startPath=`pwd`
for dir in "${repos[@]}"; do
  echo
  echo "== $dir =="
  echo

  cd $startPath/$dir

  git checkout $fromBranch || exit
  git checkout -b $releaseBranch || exit

  # Remove the composer.lock if it has been merged in
  if [ -f composer.json ]; then
    # ONLY update composer lock if branching from develop
    if [ "$fromBranch" = "develop" ]; then
      # update composer.lock
      composer update
      git add composer.lock -f
    fi

    # update composer.json
    updateComposerJson
    git add composer.json

    git commit -m"Update Composer for $releaseBranch"
  fi

  git push origin $releaseBranch || exit
done
