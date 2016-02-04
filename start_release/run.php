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
    ModuleRepo::create('olcs-common', $repoTemplate),
    ModuleRepo::create('olcs-static', $repoTemplate),
    ModuleRepo::create('olcs-transfer', $repoTemplate),
    ModuleRepo::create('olcs-utils', $repoTemplate),
    ModuleRepo::create('olcs-config', $repoTemplate),
    ModuleRepo::create('olcs-elasticsearch', $repoTemplate),
    ModuleRepo::create('olcs-auth', $repoTemplate),
    ModuleRepo::create('olcs-oa', $repoTemplate),

    AppRepo::create('olcs-selfserve', $repoTemplate),
    AppRepo::create('olcs-internal', $repoTemplate),
    AppRepo::create('olcs-backend', $repoTemplate),
    AppRepo::create('olcs-scanning', $repoTemplate),

    DevRepo::create('olcs-etl', $repoTemplate)
];

// Validate all repos before processing
foreach ($repos as $repo) {
    $command = new Validate($repo, $version);
    $command->run();
}

// If we have passed validation, process each repo
foreach ($repos as $repo) {
    $command = new Command($repo, $version);
    $command->run();
}
