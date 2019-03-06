git#!/usr/bin/env bash

# release branch to create
releaseBranch=$1

# create from branch, this is optional defaults to teh repos default branch
fromBranch=$2
x§§
if [ -z $releaseBranch ]; then
  echo "Release branch not specified eg release/x.y"
  exit
fi

if [ -z $fromBranch ]; then
  fromBranch=master
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
    -e 's/"olcs\/olcs-xmltools": "dev-[#a-z0-9\/\.]*"/"olcs\/olcs-xmltools": "dev-'${releaseBranch/\//\\\/}'"/g' \
    -e 's/"olcs\/companies-house": "dev-[#a-z0-9\/\.]*"/"olcs\/companies-house": "dev-'${releaseBranch/\//\\\/}'"/g' \
    composer.json
}

cd $reposDir
startPath=`pwd`
for dir in "${OLCS_CI_REPOS[@]}"; do
  echo
  echo "== $dir =="
  echo

  cd $startPath/$dir

  git checkout $fromBranch || exit
  git checkout -b $releaseBranch || exit

  # If composer.json exists then has some composer dependencies
  if [ -f composer.json ]; then
    # update composer.json
    updateComposerJson
    git add composer.json

    # ONLY update composer lock if branching from develop
    if [ "$fromBranch" = "develop" ]; then
      # update composer.lock
      composer update
      git add composer.lock -f
    fi

    git commit -m"Update Composer for $releaseBranch"
  fi

  if [ $OLCS_CI_DRY_RUN = "false" ]; then
    git push origin $releaseBranch || exit
  else
    echo "DRYRUN - git push origin $releaseBranch"
  fi
done
