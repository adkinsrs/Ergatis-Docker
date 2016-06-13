############################################################
# Dockerfile to build container lgtseek core image
# Based on Ubuntu
############################################################ 

# Docker 1.9.1 currently hangs when attempting to build openjdk-6-jre.
# Upgrade Docker by installing DockerToolbox-1.10.0-rc3.

FROM ubuntu:trusty

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

#--------------------------------------------------------------------------------
# SOFTWARE

ENV BSML_VERSION v2r18b1
ENV BSML_DOWNLOAD_URL http://sourceforge.net/projects/bsml/files/bsml/bsml-$BSML_VERSION/bsml-$BSML_VERSION.tar.gz

ENV WORKFLOW_VERSION 3.1.5
ENV WORKFLOW_DOWNLOAD_URL http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-$WORKFLOW_VERSION.tar.gz

ENV BWA_VERSION 0.7.15
ENV BWA_DOWNLOAD_URL https://github.com/lh3/bwa/archive/v${BWA_VERSION}.tar.gz

ENV SAMTOOLS_VERSION 1.3.1
ENV SAMTOOLS_DOWNLOAD_URL https://github.com/samtools/samtools/archive/${SAMTOOLS_VERSION}.tar.gz

ENV NCBI_BLAST_VERSION 2.3.0
ENV NCBI_BLAST_DOWNLOAD_URL ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-${NCBI_BLAST_VERSION}+-x64-linux.tar.gz

ENV PICARD_VERSION 2.4.1
ENV PICARD_DOWLOAD_URL https://github.com/broadinstitute/picard/archive/${PICARD_VERSION}.tar.gz

ENV PRINSEQ_VERSION 0.20.4
ENV PRINSEQ_DOWNLOAD_URL https://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-${PRINSEQ_VERSION}.tar.gz

ENV SRA_VERSION 2.6.3
ENV SRA_DOWLOAD_URL https://github.com/ncbi/sra-tools/archive/${SRA_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BASICS

RUN apt-get update && apt-get install -y \
	build-essential \
	curl \
	cpanminus \
	dh-make-perl \
	apache2 \
	openjdk-6-jre \
	ncbi-blast+ \
	zip \
#	zsync \
  && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------------
# PERL for ergatis

RUN apt-get update && apt-get install -y \
	bioperl \
	libcpan-meta-perl \
	libcdb-file-perl \
	libcgi-session-perl \
	libconfig-inifiles-perl \
	libdate-manip-perl \
	libfile-spec-perl \
	libhtml-template-perl \
	libio-tee-perl \
	libjson-perl \
	liblog-log4perl-perl \
	libmath-combinatorics-perl \
	libperlio-gzip-perl \
	libxml-parser-perl \
	libxml-rss-perl \
	libxml-twig-perl \
	libxml-writer-perl \
  && rm -rf /var/lib/apt/lists/*

#COPY lib/lib*.deb /tmp/

RUN dpkg -i \
	/tmp/libfile-mirror-perl_0.10-1_all.deb \
	/tmp/liblog-cabin-perl_0.06-1_all.deb \
  && rm /tmp/libfile-mirror-perl_0.10-1_all.deb \
	/tmp/liblog-cabin-perl_0.06-1_all.deb

#--------------------------------------------------------------------------------
# WORKFLOW -- install in /opt/workflow

RUN mkdir /usr/src/workflow
WORKDIR /usr/src/workflow

COPY workflow.deploy.answers /tmp/.

RUN curl -SL $WORKFLOW_DOWNLOAD_URL -o workflow.tar.gz \
	&& tar -xvf workflow.tar.gz -C /usr/src/workflow \
	&& rm workflow.tar.gz \
	&& mkdir -p /opt/workflow/server-conf \
	&& chmod 777 /opt/workflow/server-conf \
	&& ./deploy.sh < /tmp/workflow.deploy.answers

