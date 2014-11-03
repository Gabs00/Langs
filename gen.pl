#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use autodie;

my $lang = shift(@ARGV);

#Requires a language to be passed in as a command line argument
if ( !defined($lang) ) {
    die "usage gen.pl <language_name>";
}

my $dir = "./$lang";
if ( -e $dir ) {
    die "Folder $lang already exists";
}
else {
    mkdir $dir;
    copy( t('Readme'), "$dir/Readme.md" );
}

my @folderNames = qw(setup var prg data cond loop func class std project);

for my $i ( 0 .. $#folderNames ) {
    my $cDir   = $dir . '/' . $folderNames[$i];
    my $readme = "$cDir/Readme.md";
    if ( !-e $cDir ) {
        mkdir $cDir;
    }

    if ( -e $cDir ) {
        if ( $cDir =~ /project/ ) {
            copy t('P'), $readme;
        }
        else {
            copy t( $folderNames[$i] ), $readme;
        }
    }
}

sub t {
    my $n = shift(@_);
    return "./templates/$n.md";
}
