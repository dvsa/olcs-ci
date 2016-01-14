#!/bin/bash

MODULE_REPOS="olcs-common olcs-static olcs-transfer olcs-utils olcs-config olcs-elasticsearch olcs-auth olcs-oa"
APP_REPOS="olcs-selfserve olcs-internal olcs-backend olcs-scanning"
DEV_REPOS="olcs-etl"

echo $VERSION

# For each module repo
for REPO in $MODULE_REPOS
do
    echo REPO
done

# For each app repo
for REPO in $APP_REPOS
do
    echo REPO
done

# For each app repo
for REPO in $DEV_REPOS
do
    echo REPO
done
