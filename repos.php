<?php

include(__DIR__ . '/lib.php');

$repoTemplate = 'git@gitlab.inf.mgt.mtpdvsa:olcs/%s.git';

$repos = [
    ModuleRepo::create('olcs-config', $repoTemplate),

    ModuleRepo::create('olcs-common', $repoTemplate),
    ModuleRepo::create('olcs-transfer', $repoTemplate),
    ModuleRepo::create('olcs-utils', $repoTemplate),
    ModuleRepo::create('olcs-auth', $repoTemplate),
    //ModuleRepo::create('olcs-logging', $repoTemplate),


    AppRepo::create('olcs-selfserve', $repoTemplate),
    AppRepo::create('olcs-internal', $repoTemplate),
    AppRepo::create('olcs-backend', $repoTemplate),
    AppRepo::create('olcs-scanning', $repoTemplate),

    DevRepo::create('olcs-etl', $repoTemplate),
    DevRepo::create('olcs-elasticsearch', $repoTemplate),
    DevRepo::create('olcs-oa', $repoTemplate),
    DevRepo::create('olcs-static', $repoTemplate),
];
