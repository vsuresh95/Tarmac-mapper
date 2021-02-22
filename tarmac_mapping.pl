#!/usr/local/bin/perl 
use File::Copy;
use Cwd;

## PATH of .map file
my $map_file = "$ENV{PWD}/output/arm_binary.map";

my $cluster = 0;
my $core = 0;

if (defined $ARGV[0] && defined $ARGV[1])
{
	$cluster = $ARGV[0];
	$core = $ARGV[1];
}

## PATH of tarmac file
my $tarmac = "$ENV{PWD}/arm_tarmac.$cluster.$cluster.$core.log";

## creating .map file from .elf
system("nm -n $ENV{PWD}/output/arm_binary.elf > $map_file") and die "Unable to create map file";

## Handles to input and output files
open($MAPPED_TARMAC, ">", "$tarmac.mapped") or die ("Unable to create tarmac file");
open(TARMAC, "<", "$tarmac") or die ("Unable to open tarmac file");

my $fn = "";
my $offset = "";
my @line_arr = ("", "");

foreach $line (<TARMAC>)
{
	$line =~ s/\n//;
	
	if ($line =~ /.*ps  ES  \(.*/)
	{
		my $address = $line;
		$address =~ s/^.*\(//;
		$address =~ s/:.*$//;

		$address = hex $address;
		
		open(MAP, "<", "$map_file") or die ("Unable to open map file");
		
		foreach $map_line (<MAP>)
		{
			$map_line =~ s/\n//;
			
			## regex for address + function
			if($map_line !~ /^([0-9a-f]+)...(.*)$/) 
			{
				next;
			}
				
			@line_arr = $map_line =~ /^([0-9a-f]+)...(.*)$/;

			$line_arr[0] = hex $line_arr[0];

			## next until the new function address found
			next if ($address < $line_arr[0]);				

			$offset = sprintf("%x", $address - $line_arr[0]);
			$offset = " + 0x$offset";
			$fn = "<$line_arr[1]$offset>";
		}

		close MAP;
	
		printf $MAPPED_TARMAC "%-*s%-*s\n", 110, $line, 30, $fn;
	}
	else
	{
		printf $MAPPED_TARMAC "%-*s\n", 100, $line;
	}
}
