<?php

namespace StartRelease;

use Repo;
use Git;
use Shell;

class ModuleRepo extends Repo {}
class DevRepo extends Repo {}
class AppRepo extends Repo {}

class Command
{
    /**
     * @var Repo
     */
    private $repo;

    private $version;

    public function __construct(Repo $repo, $version)
    {
        $this->repo = $repo;
        $this->version = $version;
    }

    public function run()
    {
        Shell::out('Running job for %s repo', [$this->repo->getName()]);

        // Clone the repo
        $this->cloneRepo();
        chdir($this->repo->getName());

        // Check if the repo already has a release branch. We need to exit if so.
        $this->checkForReleaseBranch();
    }

    protected function cloneRepo()
    {
        Shell::out('Cloning repo');
        Shell::out(Git::cloneRepo($this->repo));
    }

    protected function checkForReleaseBranch()
    {
        Shell::out('Checking for existing release branch');
        $result = Shell::exec('git branch -a | grep remotes/origin/release');

        if (!empty($result)) {
            Shell::out('Release branch already exists');
            exit(1);
        }
    }
}
