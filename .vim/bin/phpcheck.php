#!/usr/bin/env php
<?php

class Phpcheck
{
    protected $argv;
    protected $files;

    const FMT_PHP = "php %s -l %s";

    protected $breakOnError = true;

    protected $cmdOpts = array();

    protected $enabledSmartmode = true;

    protected $aviarables = array(
        "php", "phpcs", "phpmd",
    );

    protected $formats = array(
        "php" => "php #opt -l #file",
        "phpcs" => "phpcs #opt --report=emacs #file",
        "phpmd" => "phpmd #file text #opt",
    );
    protected $defaultOptions = array(
        "php" => "-d error_reporting=E_ALL",
        "phpcs" => "",
        "phpmd" => "cleancode,codesize,design,unusedcode,naming",
    );
    protected $options = array(
    );

    protected $parsers = array(
        "php" => "parsePhpLint",
        "phpcs" => "parsePhpCs",
        "phpmd" => "parsePhpMd",
        // "php" => "",
    );

    static public function run($argv)
    {
        $cmd = new static($argv);
        exit($cmd->exec());
    }

    public function __construct($argv)
    {
        $this->progname = array_shift($argv);
        $this->argv = $argv;
    }

    public function exec()
    {
        $this->files = array();
        $this->parseOptions();
        $this->main();
        return 0;
    }

    public function init()
    {
    }

    public function help()
    {
        echo implode("\n", array(
            "Usage: {$this->progname} [option] <file>",
        )) . "\n";
    }

    public function main()
    {
        if ($this->cmdOpts["help"]) {
            $this->help();
            return 1;
        }

        foreach ($this->files as $filename) {
            $repoRoot = $this->findRepoRoot($filename);

            foreach ($this->aviarables as $checker) {
                if (!$this->isAvailable($checker)) {
                    continue;
                }
                $fmt = $this->formats[$checker];

                if ($this->enabledSmartmode || !isset($this->options[$checker])) {
                    $this->options[$checker] = $this->getSmartOptions($checker, $repoRoot, $filename);
                }

                $opt = isset($this->options[$checker]) ? $this->options[$checker] : $this->defaultOptions[$checker];
                $parseMethod = $this->parsers[$checker];
                $cmd = strtr($fmt, array(
                    "#opt" => $opt,
                    "#file" => $filename,
                ));
                $result = $this->getShellCmdResultText($cmd);
                if (method_exists($this, $parseMethod)) {
                    if ($this->{$parseMethod}($result) && $this->breakOnError) {
                        break;
                    }
                }
            }
        }
    }

    protected function findRepoRoot($filename)
    {
        $candidates = array('.git', '.hg', '.bzr', '.svn', 'CVS');
        $dir = $filename;
        if (!is_dir($filename)) {
            $dir = $filename . DIRECTORY_SEPARATOR . "dummy.txt";
        }
        $prevLen = 0;
        while (strlen($dir = dirname($dir)) != $prevLen) {
            foreach ($candidates as $d) {
                if (file_exists($dir . PATH_SEPARATOR . $d)) {
                    return $dir;
                }
            }
            $prevLen = strlen($dir);
        }
        return null;
    }

    protected function getSmartOptions($checker, $repoRoot, $filename)
    {
        switch($checker) {
        case "php":
            break;
        case "phpcs":
            if (file_exists($repoRoot . PATH_SEPARATOR . "phpcs.xml")) {
                return sprintf("--standard=%s", $repoRoot . PATH_SEPARATOR . "phpcs.xml");
            }
            break;
        case "phpmd":
            foreach (array("phpmd.xml", "ruleset.xml") as $xml) {
                if (file_exists($repoRoot . PATH_SEPARATOR . $xml)) {
                    return $repoRoot . PATH_SEPARATOR . $xml;
                }
            }
            break;
        }
        return $this->defaultOptions[$checker];
    }

    protected function getShellCmdResultText($cmd)
    {
        if (strncasecmp(PHP_OS, "Win", 3) !== 0) {
            $cmd .= ' 2>&1';
        }
        $result = exec($cmd);

        return $result;
    }

    protected function parseOptions()
    {
        $this->cmdOpts = array(
            "help" => false,
        );
        $this->files = array();

        $argv = $this->argv;
        while (($str = array_shift($argv)) !== null) {
            $val = null;
            $isLongOpt = false;
            if (preg_match('!^(--[^=]*)=(.*)$!', $str, $m)) {
                $opt = $m[1];
                $val = $m[2];
                $isLongOpt = true;
            } elseif (preg_match('!^(-\*.*)$!', $str, $m)) {
                $opt = $m[1];
            } else {
                $this->files[] = $str;
                continue;
            }
            switch ($opt) {
            case "-h":
            case "--help":
                $this->cmdOpts["help"] = true;
                break;
            case "--no-smart":
                $this->enabledSmartmode = false;
                break;
            case "-p":
            case "--php":
                $this->options["php"] = $isLongOpt ? $val : array_shift($argv);
                break;
            case "-c":
            case "--phpcs":
                $this->options["phpcs"] = $isLongOpt ? $val : array_shift($argv);
                break;
            case "-m":
            case "--phpmd":
                $this->options["phpmd"] = $isLongOpt ? $val : array_shift($argv);
                break;
            case "-n":
            case "--no-break-on-error":
                $this->breakOnError = false;
                break;
            default:
                $this->err("unrecognized option: {$opt}");
                $this->cmdOpts["help"] = true;
                return;
                break;
            }
        }
    }

    protected function parsePhpLint($text)
    {
        if (preg_match_all('!^(.*) in (.*) on line (\d+)\s*$!m', $text, $matches)) {
            foreach ($this->collectMatches($matches) as $m) {
                $this->output($m[2], $m[1], $m[3]);
            }
            return true;
        }
        return false;
    }

    protected function parsePhpCs($text)
    {
        if (preg_match_all('!^(.*):(\d+):(\d+):\s*(.*)$!m', $text, $matches)) {
            foreach ($this->collectMatches($matches) as $m) {
                $this->output($m[1], $m[4], $m[2], $m[3]);
            }
            return true;
        }
        return false;
    }

    protected function parsePhpMd($text)
    {
        if (preg_match_all('!^(.*):(\d*)\s*(.*)$!m', $text, $matches)) {
            foreach ($this->collectMatches($matches) as $m) {
                $this->output($m[1], $m[3], $m[2]);
            }
            return true;
        }
        return false;
    }

    // protected function parseXXX($text)
    // {
    //     if (preg_match_all('!!m', $text, $matches)) {
    //         foreach ($matches as $m) {
    //             $this->output();
    //         }
    //         return true;
    //     }
    //     return false;
    // }

    protected function output($filename, $desc, $line, $col = 1)
    {
        echo sprintf("%s:%d:%s:%s\n", $filename, $line, $col, $desc);
    }

    protected function err($m)
    {
        fputs(STDERR, $m . "\n");
    }

    protected function collectMatches($arr)
    {
        $m = array();
        for ($i = 0, $len = count($arr[0]); $i < $len; $i++) {
            for ($j = 0, $jlen = count($arr); $j < $jlen; $j++) {
                $line[] = $arr[$j][$i];
            }
            $m[] = $line;
        }
        return $m;
    }

    protected function isAvailable($cmd)
    {
        exec("which {$cmd}", $out, $ret);
        return $ret === 0;
    }

}

Phpcheck::run($argv);
