#!/usr/bin/perl

#  elgatoScript.pl
#  cTiVo
#
#  Created by Hugh Mackworth on 2/11/13.
#  Copyright (c) 2013 Hugh Mackworth. All rights reserved.
use warnings;
use strict;
use File::Spec;
use File::BaseName;

if ($#ARGV < 0) {
	@ARGV = ( "\"AppleTV\"", "-edl", "test.tivo.edl", "\"-i\"", "test.tivo.mpg", "test.tivo.mp4");
}
use Cwd();

my $programPath = Cwd::abs_path($0);
my ($volume, $directory, $fileName) = File::Spec->splitpath($programPath);
my $program_dir= $volume . $directory;


my $launchElgato = "/usr/bin/osascript " . $program_dir. "elgatoLaunch.scpt \"" . join ('" "', @ARGV) ."\"";
print $launchElgato ."\n";

my $counter = 1;
my $launchResponse = "";
while (1) {
	$launchResponse = `$launchElgato`;
	chop($launchResponse);  #delete return
	last if ($launchResponse ne "1");
		#waiting for another encoding to finish, but need to check in
	print $counter ."%\n";
	$counter = $counter+1;
	$counter = 1 if ($counter > 100);
		
}

print $launchResponse ."\n";

if ($launchResponse =~ /Not Found/) {
	print "turbo HD encoder not available"."\n";
	return;
}
my $turboAppName = $launchResponse;   #launch is required to send back turbo's app Name

my $checkElgato = "/usr/bin/osascript " . $program_dir. "elgatoProgress.scpt \"$launchResponse\"";
print $checkElgato ."\n";

while (1) {
	my $progressResponse =`$checkElgato`;
	chop($progressResponse); #delete return
	last if $progressResponse eq "0";
	print $counter ."%\n";
	$counter = ($counter + 1);
	$counter = 1 if ($counter > 100);
}

