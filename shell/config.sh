#!/usr/bin/env bash

repos=(
  "olcs-backend"
  "olcs-transfer"
  "olcs-config"
  "olcs-etl"
  "olcs-templates"
  "olcs-internal"
  "olcs-static"
  "olcs-selfserve"
  "olcs-common"
  "OLCSJourneyTesting"
  "olcs-reporting"
  "olcs-oa"
  "olcs-elasticsearch"
  "olcs-auth"
  "olcs-utils"
  "olcs-xmltools"
  "olcs-logging"
  "olcs-plugins"
  "olcs-testing"
  "companies-house"
  "olcs-autoload"
  "olcs-testhelpers"
)
#  "olcs-release"
#  "olcs-ci"
  #"olcs-txc"
  #"olcs-devtools"

gitUri="git@repo.shd.ci.nonprod.dvsa.aws:olcs/"
#gitUri="git@repo.shd.ci.nonprod.dvsa.aws:evansm/"
reposDir=./repos
dryRun=true

echo
echo "Repos : ${repos[*]}"
echo "Git URI : $gitUri"
echo "Dryrun : $dryRun"

# Close all the repos
cloneAll() {
  mkdir -p $reposDir
  cd $reposDir
  for dir in "${repos[@]}"; do
    if [ -d $dir ]; then
      rm -rf $dir
    fi
    repo=${gitUri}${dir}.git
    echo "Clone $dir"
    git clone -q $repo
  done
  cd ..
}