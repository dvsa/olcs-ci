#!/usr/bin/env bash

echo $OLCS_CI_REPOS

if [[ -z ${OLCS_CI_REPOS+x} ]] ; then
  OLCS_CI_REPOS=(
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
fi

if [[ -z ${OLCS_CI_GIT_URI+x} ]] ; then
    OLCS_CI_GIT_URI="git@repo.shd.ci.nonprod.dvsa.aws:evansm/"
fi
reposDir=./repos
dryRun=true

echo
echo "Repos : ${OLCS_CI_REPOS[*]}"
echo "Git URI : $OLCS_CI_GIT_URI"
echo "Dryrun : $dryRun"

# Close all the repos
cloneAll() {
  mkdir -p $reposDir
  cd $reposDir
  for dir in "${OLCS_CI_REPOS[@]}"; do
    if [ -d $dir ]; then
      rm -rf $dir
    fi
    repo=${OLCS_CI_GIT_URI}${dir}.git
    echo "Clone $dir"
    git clone -q $repo
  done
  cd ..
}
