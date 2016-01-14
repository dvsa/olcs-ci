<?php

class Shell
{
    public static function exec($cmd, $args = [], $exitOnError = true)
    {
        exec(vsprintf($cmd, $args), $output, $return);

        if ($return != 0 && $exitOnError) {
            self::out('Command failed: "%s" Failed with code %s' . "\n" . '%s', [$cmd, $return, implode("\n", $output)]);
            exit($return);
        }

        return implode("\n", $output);
    }

    public static function out($string, $args = [])
    {
        echo vsprintf('<--- ' . $string . " --->\n", $args);
    }
}

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
        return new self($name, $template);
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
        if ($shallow) {
            return Shell::exec('git clone -b %s --depth 1 %s', [$branch, $repo->getRepo()]);
        }

        return Shell::exec('git clone -b %s %s', [$branch, $repo->getRepo()]);
    }
}

class GitFlow
{
    public static function releaseStart($version)
    {
        return Shell::exec('git checkout -b release/%s', [$version]);
    }
}
