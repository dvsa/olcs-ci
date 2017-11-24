#!/usr/bin/env bash

set -e

repos=(
  "olcs-xmltools"
  "olcs-logging"
  "olcs-plugins"
  "companies-house"
  "olcs-autoload"
  "olcs-testhelpers"
  "olcs-oa"
  "olcs-elasticsearch"
  "olcs-auth"
  "olcs-static"
  "olcs-templates"
  "olcs-etl"
  "olcs-transfer"
  "olcs-utils"
  "olcs-common"
  "olcs-backend"
  "olcs-internal"
  "olcs-selfserve"
  "OLCSJourneyTesting"
# olcs-reporting now independantly version controlled
#  "olcs-reporting"
)

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
