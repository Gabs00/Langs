#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use JSON;
use Data::Dumper;
use autodie;

my $lang = shift(@ARGV) || 'pie';

#Read in template file
open my $fh, '<', 'template.json';

my $template;

#slurp in the file contents
{
  local $/ = undef;
  $template = JSON->new()->decode(<$fh>);
}

my $subdirs = $template->{'directories'};
my $mdDir = $template->{'mdDir'};
my $langDirs = $template->{'langDir'};
my $langPath = $langDirs . $lang;

if(!-e $langDirs){
  mkdir $langDirs;
}

if(!-e $langPath){
  mkdir $langPath;
}

copy($mdDir . 'Readme.md', $langPath . '/Readme.md');

for my $dir( @{ $subdirs }){
  my $path = $langPath . "/$dir";
  if(!-e $path){
    mkdir $path;
  }
  my $src = $mdDir . "/$dir" . '.md';
  my $dest = $path . "/Readme.md\n";
  copy($src, $dest);

  print "Created $dest" if -e $dest;
}
