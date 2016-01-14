<?php

namespace StartRelease;

class ModuleRepo extends \Repo {}
class DevRepo extends \Repo {}
class AppRepo extends \Repo {}

use Git;
use Shell;

class Command
{
    public function run(\Repo $repo, $version)
    {
        Shell::out('<--- Running job for %s repo --->', [$repo->getName()]);

        $this->cloneRepo($repo);
        Shell::out(Shell::exec('pwd'));
        chdir($repo->getName());
        Shell::out(Shell::exec('pwd'));
    }

    protected function cloneRepo($repo)
    {
        Shell::out('<--- Cloning repo --->');
        Shell::out(
            Git::cloneRepo($repo)
        );
    }
}
