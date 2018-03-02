#!/usr/bin/env bash

set -e

# create from branch
fromBranch=$1

secretsDir=`pwd`/git-secrets

reposDir=./repos

export PATH=$PATH:$secretsDir

if [[ -z ${OLCS_CI_GIT_URI+x} ]] ; then
    OLCS_CI_GIT_URI="git@repo.shd.ci.nonprod.dvsa.aws:"
fi

#Default to master if undefined
if [ -z $fromBranch ]; then
  fromBranch=master
fi

# ( curl -i https://api.github.com/orgs/dvsa/repos | grep full_name | grep olcs ) + companies_house + address-base + address-service
OLCS_CI_REPOS=(
  "olcs/olcs-static"
  "olcs/olcs-common"
  "olcs/olcs-backend"
  "olcs/OLCSJourneyTesting"
  "olcs/olcs-internal"
  "olcs/olcs-pdf-converter"
  "olcs/olcs-transfer"
  "olcs/olcs-release"
  "olcs/olcs-reporting"
  "olcs/olcs-utils"
  "olcs/olcs-devtools"
  "olcs/olcs-logging"
  "olcs/olcs-ci"
  "olcs/olcs-plugins"
  "olcs/olcs-xmltools"
  "olcs/olcs-testing"
  "olcs/companies-house"
  "olcs/olcs-autoload"
  "olcs/olcs-testhelpers"
  "olcs/olcs-txc"
  "olcs/olcs-coding-standards"
  "olcs/olcs-selfserve"
  "olcs/olcs-release-notes"
  "sc/address-base"
  "sc/address-service"
)

echo "working against branch    : $fromBranch"
echo

mkdir -p $reposDir
cd $reposDir
startPath=`pwd`
for repo  in "${OLCS_CI_REPOS[@]}"; do
    dir=`echo $repo | sed 's/.*\///'` #remove org for directory name
    if [ -d $dir ]; then
      rm -rf $dir
    fi

    repo=${OLCS_CI_GIT_URI}${repo}.git
    echo "Clone $repo"
    git clone -q $repo

  echo
  echo "== Scanning $dir =="
  echo
   cd $startPath/$dir
  
  # Register standard built-in AWS patterns
  git secrets --register-aws

  # Ignore Rules. Note: these are either explained in situ below,
  # or reference the git hash for the commit containing the content
  # that needed an exception to the standard scan

    # Ignore RTF files as they currently have a large amount of content
    # that throws false positives
    git secrets --add --allowed "\\.rtf"

    #Ignore all of node_modules as they're not our keys
    git secrets --add --allowed "node_modules"

    #Ignore any Serialization IDs in Java
    git secrets --add --allowed "serialVersionUID"


    git secrets --add --allowed "02020603050405020304" # 9d0ae334f0d8090ceff61c9d9ff9c0ea3affa044 olcs/backend
    git secrets --add --allowed "18446744073709551615" # 2fcbd8b7305515a388468bd5b78e90e6a41ce4ac olcs/selfserve


  #Scan with history
  git secrets --scan-history

  echo
  cd $startPath
done
