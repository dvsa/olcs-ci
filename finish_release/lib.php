<?php

namespace FinishRelease;

use Repo;
use Git;
use GitFlow;
use Shell;

class Push
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
        chdir($this->repo->getName());

        Git::checkout('develop');
        Git::pull('develop');
        Git::push('develop');

        Git::checkout('master');
        Git::pull('master');
        Git::push('master');
        Git::pushTags();

        Git::deleteRemoteBranch('release/'. $this->version);

        chdir('..');
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
        if (!file_exists($this->repo->getName())) {
            $this->cloneRepo();
        }
        chdir($this->repo->getName());
        Git::checkout('release/'. $this->version);
        Git::pull('release/'. $this->version);

        // This causes merge conflicts!!!
//        if ($this->repo instanceof \AppRepo || $this->repo instanceof \DevRepo) {
//            $this->updateVersionNumber();
//        }

        Shell::out(GitFlow::releaseFinish($this->version));

        if ($this->repo instanceof \AppRepo) {
            $this->updateComposer();
        }

        chdir('..');
    }

    private function cloneRepo()
    {
        Shell::out('Cloning repo');
        Shell::out(Git::cloneRepo($this->repo, 'master', false));
    }

    private function updateComposer()
    {
        Shell::out(Git::checkout('develop'));

        if (file_exists('composer.lock')) {
            Shell::out(Git::remove(['composer.lock']));
        }

        $this->updateComposerJson();
        Shell::out(Git::add(['composer.json']));

        Shell::out(Git::commit('Update composer for develop'));
    }

    private function updateComposerJson()
    {
        Shell::out('Updating composer JSON');

        $composerJson = file_get_contents('composer.json');

        $replacements = [
            '"olcs/OlcsCommon": "dev-develop"' => '"olcs/OlcsCommon": "dev-release/' . $this->version . '"',
            '"olcs/olcs-transfer": "dev-develop"' => '"olcs/olcs-transfer": "dev-release/' . $this->version . '"',
            '"olcs/olcs-utils": "dev-develop"' => '"olcs/olcs-utils": "dev-release/' . $this->version . '"',
            '"olcs/olcs-auth": "dev-develop"' => '"olcs/olcs-auth": "dev-release/' . $this->version . '"',
            '"olcs/olcs-document-share": "dev-develop"' => '"olcs/olcs-document-share": "dev-release/' . $this->version . '"',
        ];

        $composerJson = str_replace(array_values($replacements), array_keys($replacements), $composerJson);

        file_put_contents('composer.json', $composerJson);
    }

    private function updateVersionNumber()
    {
        Shell::out('Updating application version number');
        $version = $this->version;

        if (file_exists('config/version')) {
            file_put_contents('config/version', $version);
            Shell::out(Git::add(['config/version']));
        } else {
            file_put_contents('version', $version);
            Shell::out(Git::add(['version']));
        }

        Shell::out('Committing version number file');
        Shell::out(Git::commit('Set version number %s', [$version]));
    }
}
