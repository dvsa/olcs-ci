<?php

/**
 * Build script for start_release job
 *
 * Decided to use PHP to allow more of our developers to understand and contribute
 */

namespace StartRelease;

include(__DIR__ . '/../repos.php');
include(__DIR__ . '/lib.php');

if (!isset($argv[1])) {
    die("Version/tag argument is missing\n");
}
$version = $argv[1];

// Validate all repos before processing
foreach ($repos as $repo) {
    $command = new Command($repo, $version);
    $command->run();
}