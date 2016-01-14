<?php

namespace StartRelease;

use Repo;
use Git;
use GitFlow;
use Shell;

class ModuleRepo extends Repo {}
class DevRepo extends Repo {}
class AppRepo extends Repo {}

class Validate
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
        Shell::out('Validating %s repo', [$this->repo->getName()]);

        $this->cloneRepo();

        chdir($this->repo->getName());

        $this->checkForReleaseBranch();

        $this->createNewReleaseBranch();

        if ($this->repo instanceof AppRepo) {
            $this->updateComposerJson();
            $this->updateComposer();
        }

        $this->runUnitTests();

        chdir('..');
    }

    protected function cloneRepo()
    {
        Shell::out('Cloning repo');
        Shell::out(Git::cloneRepo($this->repo));
    }

    protected function checkForReleaseBranch()
    {
        Shell::out('Checking for existing release branch');
        $result = Shell::exec('git branch -a | grep remotes/origin/release', [], false);

        if (!empty($result)) {
            Shell::out('Release branch already exists');
            exit(1);
        }

        Shell::out('Release branch not found!');
    }

    protected function createNewReleaseBranch()
    {
        Shell::out('Creating local release branch');
        Shell::out(GitFlow::releaseStart($this->version));
    }

    protected function updateComposerJson()
    {
        Shell::out('Updating composer JSON');

        $composerJson = file_get_contents('composer.json');

        $replacements = [
            '"olcs\/OlcsCommon": "dev-develop"' => '"olcs\/OlcsCommon": "dev-release/' . $this->version . '"',
            '"olcs\/olcs-transfer": "dev-develop"' => '"olcs\/olcs-transfer": "dev-release/' . $this->version . '"',
            '"olcs\/olcs-utils": "dev-develop"' => '"olcs\/olcs-utils": "dev-release/' . $this->version . '"',
            '"olcs\/olcs-auth": "dev-develop"' => '"olcs\/olcs-auth": "dev-release/' . $this->version . '"',
            '"olcs\/olcs-document-share": "dev-develop"' => '"olcs\/olcs-document-share": "dev-release/' . $this->version . '"',
        ];

        $composerJson = str_replace(array_keys($replacements), array_values($replacements), $composerJson);

        file_put_contents('composer.json', $composerJson);
    }

    protected function updateComposer()
    {
        Shell::out('Updating composer');

        if (file_exists('composer.phar') == false) {
            Shell::out(Shell::exec('wget https://getcomposer.org/composer.phar'));
        }

        Shell::out(Shell::exec('php composer.phar update --no-interaction'));
    }

    protected function runUnitTests()
    {
        if (file_exists('test')) {

            Shell::out('Running unit tests');

            chdir('test');

            Shell::out(Shell::exec('php ../vendor/bin/phpunit'));

            chdir('..');
        } else {
            Shell::out('WARNING: No unit tests found');
        }
    }
}

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
        Shell::out('Creating release for %s repo', [$this->repo->getName()]);

        chdir($this->repo->getName());



        chdir('..');
    }
}
