<?php

/**
 * Build script for start_release job
 *
 * Decided to use PHP to allow more of our developers to understand and contribute
 */

namespace StartRelease;

include(__DIR__ . '/../lib.php');
include(__DIR__ . '/lib.php');

$version = $_SERVER['VERSION'];
$repoTemplate = 'git@gitlab.inf.mgt.mtpdvsa:olcs/%s.git';

$repos = [
    ModuleRepo::create(sprintf($repoTemplate, 'olcs-common')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-static')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-transfer')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-utils')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-config')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-elasticsearch')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-auth')),
//    ModuleRepo::create(sprintf($repoTemplate, 'olcs-oa')),
//    AppRepo::create(sprintf($repoTemplate, 'olcs-selfserve')),
//    AppRepo::create(sprintf($repoTemplate, 'olcs-internal')),
//    AppRepo::create(sprintf($repoTemplate, 'olcs-backend')),
//    AppRepo::create(sprintf($repoTemplate, 'olcs-scanning')),
//    DevRepo::create(sprintf($repoTemplate, 'olcs-etl'))
];

foreach ($repos as $repo) {
    $command = new Command();
    $command->run($repo, $version);
}
