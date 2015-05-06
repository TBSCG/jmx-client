#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;
use File::Copy qw(copy);
use Cwd 'abs_path';
use File::Basename;

my $SCRIPT_FILE = abs_path($0);
my $SCRIPT_DIR  = dirname($SCRIPT_FILE);

my $HTML_START_FILE = "$SCRIPT_DIR/index-start.html";
my $HTML_END_FILE   = "$SCRIPT_DIR/index-end.html";

my $HTML_END = read_file( $HTML_END_FILE );


my $SUBDIR = shift @ARGV || die "no prefix passed";

if (-d $SUBDIR) {
	die "Sub dir $SUBDIR already exists";
}
mkdir $SUBDIR or die "unable to make $SUBDIR $!";

$SUBDIR .= "/";

my %file_handles;
my %http_thread_reqs;

my $i = 0;
my $fh;
while( my $line = <STDIN>)  {
#    print $line;
	chomp $line;
	next if ($line =~ /^URL :/);
	$i++;

	my ($timestamp, $name, $value) = split /\t/, $line;

	if ($value =~ /^javax.management.openmbean.CompositeDataSupport\(.*contents={([^}]+)}.*$/) {
		foreach (split /, */, $1) {
			my ($sub_name, $sub_value) = split /=/;
			print_line($timestamp, $name.'.'.$sub_name, $sub_value);
		}
	}
	else {
		print_line($timestamp, $name, $value);
	}

}

print "Wrote $i lines into ".scalar(keys %file_handles)." files\n";

foreach (values %file_handles) {
	print $_ $HTML_END;
	close $_;
}

# ----

sub print_line {
	my ($timestamp, $name, $value) = @_;

	my $safeName = $name;
	$safeName =~ s/[^a-zA-Z0-9.-]/_/g;

	$fh = get_write_handle($safeName.".html");

	my ($y, $m, $d, $h, $mi, $s) = $timestamp =~ /([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/;
	$m =~ s/^0+//; $m = '0' if ($m eq '');
	$d =~ s/^0+//; $d = '0' if ($d eq '');
	$h =~ s/^0+//; $h = '0' if ($h eq '');
	$mi =~ s/^0+//; $mi = '0' if ($mi eq '');
	$s =~ s/^0+//; $s = '0' if ($s eq '');

	$value = 'null' if ($value eq '!null!');

#	print ",[new Date($y,$m,$d,$h,$mi,$s), $value]\n";
	print $fh "[new Date($y,".($m - 1).",$d,$h,$mi,$s), $value]\n";


}

sub get_write_handle {
	my $f = shift @_;
	if ($file_handles{$f}) {
		my $fh = $file_handles{$f};
		print $fh ",";
	}
	else {
		die "File $f already exists" if (-e $SUBDIR.$f);
		copy $HTML_START_FILE, $SUBDIR.$f or die "Could not copy $f: $!";
		open my $fh, '>>', $SUBDIR.$f or die "Could not open $f: $!";
		$file_handles{$f} = $fh;
	}
	return $file_handles{$f};
}

sub read_file {
	my $f = shift @_;
	local $/ = undef;
	open READFILE, $f or die "Couldn't open file $f: $!";
	binmode READFILE;
	my $string = <READFILE>;
	close READFILE;
	return $string;
}
