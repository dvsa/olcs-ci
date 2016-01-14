<?php

/**
 * Build script for start_release job
 *
 * Decided to use PHP to allow more of our developers to understand and contribute
 */
$moduleRepos = [
    'olcs-common',
    'olcs-static',
    'olcs-transfer',
    'olcs-utils',
    'olcs-config',
    'olcs-elasticsearch',
    'olcs-auth',
    'olcs-oa'
];
var_dump($GLOBALS);
//
//#$VERSION=2.X
//APP_REPOS="olcs-selfserve olcs-internal olcs-backend olcs-scanning"
//DEV_REPOS="olcs-etl"
//
//function shallowClone {
//    git shallow
//}
//
//# For each module repo
//for REPO in $MODULE_REPOS
//do
//    echo $REPO
//done
//
//# For each app repo
//for REPO in $APP_REPOS
//do
//    echo $REPO
//done
//
//# For each dev repo
//for REPO in $DEV_REPOS
//do
//    echo $REPO
//done
