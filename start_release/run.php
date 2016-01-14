<?php

/**
 * Build script for start_release job
 *
 * Decided to use PHP to allow more of our developers to understand and contribute
 */

include(__DIR__ . '/../lib.php');

$version = $_SERVER['VERSION'];

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

$appRepos = [
    'olcs-selfserve',
    'olcs-internal',
    'olcs-backend',
    'olcs-scanning'
];

$devRepos = ['olcs-etl'];

$repoTemplate = 'git@gitlab.inf.mgt.mtpdvsa:olcs/%s.git';

foreach ($moduleRepos as $repo) {
    Shell::out(
        Git::cloneRepo(sprintf($repoTemplate, $repo))
    );
}
