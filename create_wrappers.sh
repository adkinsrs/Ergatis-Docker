#!/usr/bin/bash

# create_wrappers.sh - Create wrapper files based on the executable scripts present in the bin directory
# Args - [1] - Base path of Ergatis package

script_dir=$(dirname "$0")


for file in `ls -1 $1/bin`; do
	fileext=${filename##*.}
	case $fileext in
		pl)
			/usr/bin/perl ${script_dir}/perl2wrapper_ergatis.pl INSTALL_BASE=$1 $file
			;;
		py)
			/usr/bin/perl ${script_dir}/python2wrapper_ergatis.pl INSTALL_BASE=$1 $file
			;;
		jl)
			/usr/bin/perl ${script_dir}/julia2wrapper_ergatis.pl INSTALL_BASE=$1 $file
			;;
		*)
			echo "$file is not a Perl, Python, or Julia file... skipping\n"
			;;
	esac
done
