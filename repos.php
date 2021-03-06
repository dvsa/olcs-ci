<?php

include(__DIR__ . '/lib.php');

$repoTemplate = 'git@repo.shd.ci.nonprod.dvsa.aws:olcs/%s.git';

$repos = [
    // Do these dependencies need adding or could composer.json point at their master
//    ModuleRepo::create('autoload', $repoTemplate),
//    ModuleRepo::create('companies-house', $repoTemplate),
//    ModuleRepo::create('olcs-xmltools', $repoTemplate),
//    ModuleRepo::create('olcs-logging', $repoTemplate),

    ModuleRepo::create('olcs-config', $repoTemplate),

    ModuleRepo::create('olcs-common', $repoTemplate),
    ModuleRepo::create('olcs-transfer', $repoTemplate),
    ModuleRepo::create('olcs-utils', $repoTemplate),
    ModuleRepo::create('olcs-auth', $repoTemplate),

    AppRepo::create('olcs-selfserve', $repoTemplate),
    AppRepo::create('olcs-internal', $repoTemplate),
    AppRepo::create('olcs-backend', $repoTemplate),

    DevRepo::create('olcs-etl', $repoTemplate),
    DevRepo::create('olcs-elasticsearch', $repoTemplate),
    DevRepo::create('olcs-static', $repoTemplate),
    DevRepo::create('olcs-templates', $repoTemplate),
    DevRepo::create('olcs-reporting', $repoTemplate),

    // OA repo would need updating before packaging, ie checking ERB files, therefore should be tagged then?
    DevRepo::create('olcs-oa', $repoTemplate),
];
