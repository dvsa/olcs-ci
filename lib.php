<?php

class Shell
{
    public static function exec($cmd, $args = [])
    {
        return shell_exec(vsprintf($cmd, $args));
    }

    public static function out($string)
    {
        echo $string . "\n";
    }
}

class Git
{
    public static function cloneRepo($repo, $branch = 'develop', $shallow = true)
    {
        if ($shallow) {
            return Shell::exec('git clone -b %s --single-branch --depth 1 %s', [$branch, $repo]);
        }

        return Shell::exec('git clone -b %s --single-branch %s', [$branch, $repo]);
    }
}
