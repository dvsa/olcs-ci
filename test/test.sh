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
export COMPOSE_PROJECT_NAME=ci_test_`pwd | shasum`

docker-compose build

VERSION_SERVICE_NAMES=(git-1.7 git-2.14)

for VERSION_SERVICE_NAME in "${VERSION_SERVICE_NAMES[@]}"; do
    echo
    echo "setting up for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm "${VERSION_SERVICE_NAME}" bash -c 'rm -rf /origin/*'
    docker-compose run --rm "${VERSION_SERVICE_NAME}" bash -c '
        set -e
        git init --bare /origin/olcs-backend.git
        git clone /origin/olcs-backend.git
        cd olcs-backend
        git commit --message "initial" --allow-empty
        git push --set-upstream origin master
        git checkout -b develop
        touch file
        git add file
        git commit file --message "add a file" --allow-empty
        git push --set-upstream origin develop
      '

    echo
    echo "running create dry-run test for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm -w /olcs-ci/shell "${VERSION_SERVICE_NAME}" bash -c '
        set -e
        export OLCS_CI_GIT_URI=/origin/
        export OLCS_CI_REPOS=olcs-backend
        ./all-create-release-branch.sh release/1.23
    '

    echo
    echo "checking result for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm git-2.14 bash -c '
        set -e
        if git -C /origin/olcs-backend.git rev-parse --verify release/1.23 &> /dev/null ; then
            echo Test failed, branch was found, should not have been pushed in dry-run
            false
        else
            echo Test passed!
        fi
      '

    echo "running create live-run test for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm -w /olcs-ci/shell "${VERSION_SERVICE_NAME}" bash -c '
        set -e
        export OLCS_CI_GIT_URI=/origin/
        export OLCS_CI_REPOS=olcs-backend
        export OLCS_CI_DRY_RUN=false
        ./all-create-release-branch.sh release/1.23
    '

    echo
    echo "checking result for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm git-2.14 bash -c '
        set -e
        if git -C /origin/olcs-backend.git rev-parse --verify release/1.23 &> /dev/null ; then
            echo Test passed!
        else
            echo Test failed, branch was not found, should have been pushed
            false
        fi
      '

    echo "running close dry-run test for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm -w /olcs-ci/shell "${VERSION_SERVICE_NAME}" bash -c '
        set -e
        export OLCS_CI_GIT_URI=/origin/
        export OLCS_CI_REPOS=olcs-backend
        ./all-close-release-branch.sh 1.23
    '

    echo
    echo "checking result for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm git-2.14 bash -c '
        set -e
        if git -C /origin/olcs-backend.git rev-parse --verify release/1.23 &> /dev/null ; then
            echo Test passed!
        else
            echo Test failed, branch was not found, should have been pushed
            false
        fi
      '

    echo "running close live-run test for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm -w /olcs-ci/shell "${VERSION_SERVICE_NAME}" bash -c '
        set -e
        export OLCS_CI_GIT_URI=/origin/
        export OLCS_CI_REPOS=olcs-backend
        export OLCS_CI_DRY_RUN=false
        ./all-close-release-branch.sh 1.23
    '

    echo
    echo "checking result for ${VERSION_SERVICE_NAME}"
    docker-compose run --rm git-2.14 bash -c '
        set -e
        if git -C /origin/olcs-backend.git rev-parse --verify release/1.23 &> /dev/null ; then
            echo Test failed, branch was found, should have been removed
            false
        else
            echo Test passed!
        fi

        if git -C /origin/olcs-backend.git rev-parse --verify 1.23 &> /dev/null ; then
            echo Test failed, repo should not have been tagged as there were no changes
            false
        else
            echo Test passed!
        fi
      '
done
