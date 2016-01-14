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

        if ($this->repo instanceof AppRepo) {
            $this->updateVersionNumber();
        }

        $this->createNewReleaseBranch();

        // For app repos, we need to update composer json versions, update composer to generate a lock file, and check
        // the unit tests run
        if ($this->repo instanceof AppRepo) {
            $this->updateComposerJson();
            $this->updateComposer();
            $this->runUnitTests();
            $this->commitComposerLock();
        }

        chdir('..');
    }

    private function cloneRepo()
    {
        Shell::out('Cloning repo');
        Shell::out(Git::cloneRepo($this->repo));
    }

    private function checkForReleaseBranch()
    {
        Shell::out('Checking for existing release branch');
        $result = Shell::exec('git branch -a | grep remotes/origin/release', [], false);

        if (!empty($result)) {
            Shell::out('Release branch already exists');
            exit(1);
        }

        Shell::out('Release branch not found!');
    }

    private function updateVersionNumber()
    {
        Shell::out('Updating application version number');

        if (file_exists('config/version')) {
            file_put_contents('config/version', $this->version);

            Shell::out('Committing version number file');

            Shell::out(Git::add(['config/version']));
            Shell::out(Git::commit('Increased version number %s', [$this->version]));
        }
    }

    private function createNewReleaseBranch()
    {
        Shell::out('Creating local release branch');
        Shell::out(GitFlow::releaseStart($this->version));
    }

    private function updateComposerJson()
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

    private function updateComposer()
    {
        Shell::out('Updating composer');

        if (file_exists('composer.phar') == false) {
            copy('../composer.phar', './composer.phar');
        }

        Shell::out(Shell::exec('php composer.phar update --no-interaction'));
    }

    private function runUnitTests()
    {
        if (file_exists('test')) {
            Shell::out('Running unit tests');
            Shell::out(Shell::exec('php vendor/bin/phpunit -c test'));
        } else {
            Shell::out('WARNING: No unit tests found');
        }
    }

    private function commitComposerLock()
    {
        Shell::out('Committing release files');

        Shell::out(Git::add(['composer.lock']));
        Shell::out(Git::commit('Composer lock %s', [$this->version]));
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

        $this->pushToOrigin();

        chdir('..');
    }

    private function pushToOrigin()
    {
        Shell::out('Pushing release branch to origin');

        Shell::out(Git::push('release/' . $this->version));

        Shell::out('Pushing develop branch to origin');

        Shell::out(Git::checkout('develop'));
        Shell::out(Git::push('develop'));
    }
}
