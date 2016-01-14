<?php

class Shell
{
    public static function exec($cmd, $args = [])
    {
        return shell_exec(vsprintf($cmd, $args));
    }

    public static function out($string, $args = [])
    {
        echo vsprintf($string . "\n", $args);
    }
}

class Repo
{
    public $name;

    public function __construct($name)
    {
        $this->name = $name;
    }

    public static function create($name)
    {
        return new self($name);
    }

    public function getName()
    {
        return $this->name;
    }
}

class Git
{
    public static function cloneRepo(Repo $repo, $branch = 'develop', $shallow = true)
    {
        if ($shallow) {
            return Shell::exec('git clone -b %s --depth 1 %s', [$branch, $repo->getName()]);
        }

        return Shell::exec('git clone -b %s %s', [$branch, $repo->getName()]);
    }
}
