#!/usr/bin/env perl
use File::Basename;
use File::Find;

use strict;
use warnings;

# Run script independently but allow to be used as a module
get_perl_bins() unless caller();

sub get_perl_bins{
    my $instdir='';
	my $workflowdocsdir='';
	my $schemadocsdir='';
	my $fname = '';

    my $perl_path = $^X;  ## can be overwritten below
    
    foreach my $arg (@ARGV){
        if($arg =~ /INSTALL_BASE/){
            ($instdir) = ($arg =~ /INSTALL_BASE=(.*)/);
        }
        elsif($arg =~ /WORKFLOW_DOCS_DIR/){
            ($workflowdocsdir) = ($arg =~ /WORKFLOW_DOCS_DIR=(.*)/);
        }
        elsif($arg =~ /SCHEMA_DOCS_DIR/){
            ($schemadocsdir) = ($arg =~ /SCHEMA_DOCS_DIR=(.*)/);
        }
        elsif($arg =~ /PERL_PATH/){
            ($perl_path) = ($arg =~ /PERL_PATH=(.*)/);
        }
		else {
			$fname = $arg;
			chomp $fname;
		}
    }

    my $envbuffer;
    my $env_hash = {'WORKFLOW_DOCS_DIR' => "$workflowdocsdir",
		    'SCHEMA_DOCS_DIR' => "$schemadocsdir",
		    'WORKFLOW_WRAPPERS_DIR'  => "$instdir/bin"
		    };
    
    foreach my $key (keys %$env_hash){
	$envbuffer .= "if [ -z \"\$$key\" ]\nthen\n    $key=$env_hash->{$key}\nexport $key\nfi\n";
    }

	my($strip_fname) = ($fname =~ /(.*)\.pl$/);

	# Open wrapper for writing to.
	open WRAPPER, "+>$instdir/bin/$strip_fname" or die "Can't open file $instdir/bin/$strip_fname\n";
	my ($shell_args)  = q/"$@"/;
	my $addbuffer = $envbuffer;
    print WRAPPER <<_END_WRAPPER_;
#!/bin/sh
$addbuffer

umask 0000

unset PERL5LIB
unset LD_LIBRARY_PATH

LANG=C
export LANG
LC_ALL=C
export LC_ALL

PERL_MOD_DIR=$instdir/lib/5.8.8
export PERL_MOD_DIR

export PERL5LIB=$instdir/lib/perl5/

    $perl_path $instdir/bin/$fname $shell_args    

_END_WRAPPER_
   ;
   close WRAPPER;
	    
}

1;
