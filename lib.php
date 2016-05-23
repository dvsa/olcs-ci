<?php

class Shell
{
    public static function exec($cmd, $args = [], $exitOnError = true)
    {
        $command = vsprintf($cmd, $args);
        echo "{$command}\n";
        exec($command, $output, $return);

        if ($return != 0 && $exitOnError) {
            self::out('Command failed: %s', [$command]);
            self::out(implode("\n", $output));
            exit($return);
        }

        return implode("\n", $output);
    }

    public static function out($string, $args = false)
    {
        if (empty($string)) {
            return;
        }
        if (is_array($args)) {
            echo vsprintf('<--- ' . $string . " --->\n", $args);
        } else {
            echo '<--- ' . $string . " --->\n";
        }
    }
}

class ModuleRepo extends Repo {}
class DevRepo extends Repo {}
class AppRepo extends Repo {}

class Repo
{
    private $name;

    private $repoTemplate;

    public function __construct($name, $template)
    {
        $this->name = $name;
        $this->repoTemplate = $template;
    }

    public static function create($name, $template)
    {
        return new static($name, $template);
    }

    public function getName()
    {
        return $this->name;
    }

    public function getRepo()
    {
        return sprintf($this->repoTemplate, $this->name);
    }
}

class Git
{
    public static function cloneRepo(Repo $repo, $branch = 'develop', $shallow = true)
    {
//        if ($shallow) {
//            return Shell::exec('git clone -b %s --depth 1 %s', [$branch, $repo->getRepo()]);
//        }

        return Shell::exec('git clone -b %s %s', [$branch, $repo->getRepo()]);
    }

    public static function add(array $files = [])
    {
        $output = [];
        foreach ($files as $file) {
            $output[] = Shell::exec('git add -f %s', [$file]);
        }

        return implode("\n", $output);
    }

    public static function remove(array $files = [])
    {
        $output = [];
        foreach ($files as $file) {
                $output[] = Shell::exec('git rm %s', [$file]);
        }

        return implode("\n", $output);
    }

    public static function commit($message, $args = [])
    {
        return Shell::exec('git commit -m "%s"', [vsprintf($message, $args)]);
    }

    public static function fetchAll()
    {
        return Shell::exec('git fetch --all');
    }

    public static function checkout($branch)
    {
        return Shell::exec('git checkout %s', [$branch]);
    }

    public static function push($remoteBranch)
    {
        return Shell::exec('git push -u origin %s', [$remoteBranch]);
    }

    public static function pull($remoteBranch)
    {
        return Shell::exec('git pull origin %s', [$remoteBranch]);
    }

    public static function pushTags()
    {
        return Shell::exec('git push --tags');
    }

    public static function deleteRemoteBranch($remoteBranch)
    {
        return Shell::exec('git push origin --delete %s', [$remoteBranch]);
    }

    /**
     * @return bool
     */
    public static function hasUncommittedChanges()
    {
        $result = Shell::exec('git diff-index HEAD');
        return !empty($result);
    }
}

class GitFlow
{
    public static function releaseStart($version)
    {
        Git::checkout('develop');
        Git::pull('develop');
        return Shell::exec('git checkout -b release/%s', [$version]);
    }

    public static function releaseFinish($version)
    {
        Git::checkout('master');
        Git::pull('master');
        Shell::exec('git merge release/%s', [$version]);
        Shell::exec('git tag -a %s -m\'Tagged %s\'', [$version, $version]);

        Git::checkout('develop');
        Git::pull('develop');
        Shell::exec('git merge release/%s', [$version]);
    }
}
