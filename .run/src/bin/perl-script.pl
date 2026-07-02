#!/usr/bin/env perl

use strict;
use warnings;
use Cwd qw(cwd);

my $cwd = cwd();
my $args = join ", ", map { "\"$_\"" } @ARGV;

print "\n";
print "  Welcome to use `run.sh` / `run.ps1`\n";
print "\n";
print "  > \"Hello World\"\n";
print "  > cwd  : \"$cwd\"\n";
print "  > args : $args\n";
print "\n";
