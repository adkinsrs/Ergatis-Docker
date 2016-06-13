#!/bin/sh
if [ -z "$SCHEMA_DOCS_DIR" ]
then
    SCHEMA_DOCS_DIR=
export SCHEMA_DOCS_DIR
fi
if [ -z "$WORKFLOW_WRAPPERS_DIR" ]
then
    WORKFLOW_WRAPPERS_DIR=/usr/local/projects/ergatis/package-nightly//bin
export WORKFLOW_WRAPPERS_DIR
fi
if [ -z "$WORKFLOW_DOCS_DIR" ]
then
    WORKFLOW_DOCS_DIR=
export WORKFLOW_DOCS_DIR
fi


umask 0000

unset PERL5LIB
unset LD_LIBRARY_PATH

LANG=C

export LANG
LC_ALL=C
export LC_ALL

PERL_MOD_DIR=/usr/local/projects/ergatis/package-nightly//lib/5.8.8
export PERL_MOD_DIR

export PERL5LIB=/usr/local/projects/ergatis/package-nightly//lib/perl5/

    /usr/bin/perl /opt/ergatis/bin/###SCRIPT_NAME###.pl "$@"

exit 0