#!/usr/bin/env bash
set -e
cd `dirname $0`
cd ..

function cleanup {
    docker-compose down --volumes
}
trap cleanup EXIT

cleanup

#create a custom prefix for images so we don't clash with other ci runs
export COMPOSE_PROJECT_NAME=ci_test_`pwd | crc32 /dev/stdin`

docker-compose build

VERSION_SERVICE_NAMES=(git-1.7 git-2.14)

for VERSION_SERVICE_NAME in "${VERSION_SERVICE_NAMES[@]}"; do
    docker-compose run -w /olcs-ci/shell "${VERSION_SERVICE_NAME}" ./all-create-release-branch.sh release/1.23
done
