############################################################
# Dockerfile to build container virome pipeline image
# Based on Ubuntu
############################################################ 

# Docker 1.9.1 currently hangs when attempting to build openjdk-6-jre.
# Upgrade Docker by installing DockerToolbox-1.10.0-rc3.

FROM ubuntu:trusty

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

#--------------------------------------------------------------------------------
# SOFTWARE

ENV BMSL_VERSION v2r18b1
ENV BMSL_DOWNLOAD_URL http://sourceforge.net/projects/bsml/files/bsml/bsml-$BMSL_VERSION/bsml-$BMSL_VERSION.tar.gz

ENV ERGATIS_VERSION v2r19b4
ENV ERGATIS_DOWNLOAD_URL https://github.com/jorvis/ergatis/archive/$ERGATIS_VERSION.tar.gz

ENV WORKFLOW_VERSION 3.1.5
ENV WORKFLOW_DOWNLOAD_URL http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-$WORKFLOW_VERSION.tar.gz

# Placeholder name for now
ENV LGTSEEK_VERSION 1.0
ENV LGTSEEK_DOWNLOAD_URL https://github.com/adkinsrs/LGTSeek_pipeline/archive/master.zip

ENV BWA_VERSION 0.7.15
ENV BWA_DOWNLOAD_URL https://github.com/lh3/bwa/archive/v0.7.15.tar.gz

ENV SAMTOOLS_VERSION 1.3.1
ENV SAMTOOLS_DOWNLOAD_URL https://github.com/samtools/samtools/archive/1.3.1.tar.gz

ENV NCBI_BLAST_VERSION 2.3.0
ENV NCBI_BLAST_DOWNLOAD_URL ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-${NCBI_BLAST_VERSION}+-x64-linux.tar.gz

# Need to check versions and paths for Picard tools and Prinseq
ENV PICARD_VERSION 1.3.1
ENV PICARD_DOWLOAD_URL http://lowelab.ucsc.edu/software/tRNAscan-SE-${TRNASCAN_SE_VERSION}.tar.gz

ENV PRINSEQ_VERSION 1.0.0
ENV PRINSEQ_DOWNLOAD_URL http://www.shh.com/org

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
	zsync \
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

COPY lib/lib*.deb /tmp/

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

#--------------------------------------------------------------------------------
# LGTSEEK -- install in /opt/package_lgtseek

RUN mkdir -p /opt/src/lgtseek
WORKDIR /opt/src/lgtseek

COPY ergatis.install.fix /tmp/.
COPY lgtseek.ergatis.ini /tmp/.
COPY lgtseek.software.config /tmp/.

RUN curl -SL $LGTSEEK_DOWNLOAD_URL -o lgtseek.zip \
	&& unzip -o lgtseek.zip \
	&& rm lgtseek.zip \
	&& mv /opt/src/lgtseek/lgtseek_pipeline-master /opt/package_lgtseek \
	&& cd /opt/package_lgtseek/autopipe_package/ergatis \
	&& cp /tmp/ergatis.install.fix . \
	&& ./ergatis.install.fix \
	&& perl Makefile.PL INSTALL_BASE=/opt/package_lgtseek \
	&& make \
	&& make install \
	&& cp /tmp/lgtseek.ergatis.ini /opt/package_lgtseek/autopipe_package/ergatis/htdocs/cgi/ergatis.ini \
	&& cp /tmp/lgtseek.ergatis.ini /opt/package_lgtseek/autopipe_package/ergatis.ini \
	&& cp /tmp/lgtseek.software.config /opt/package_lgtseek/software.config

RUN echo "lgtseek = /opt/projects/lgtseek" >> /opt/package_lgtseek/autopipe_package/ergatis.ini

#--------------------------------------------------------------------------------
# SCRATCH

RUN mkdir -p /usr/local/scratch && chmod 777 /usr/local/scratch \
	&& mkdir /usr/local/scratch/ergatis && chmod 777 /usr/local/scratch/ergatis \
	&& mkdir /usr/local/scratch/ergatis/archival && chmod 777 /usr/local/scratch/ergatis/archival \
	&& mkdir /usr/local/scratch/workflow && chmod 777 /usr/local/scratch/workflow \
	&& mkdir /usr/local/scratch/workflow/id_repository && chmod 777 /usr/local/scratch/workflow/id_repository \
	&& mkdir /usr/local/scratch/workflow/runtime && chmod 777 /usr/local/scratch/workflow/runtime \
	&& mkdir /usr/local/scratch/workflow/runtime/pipeline && chmod 777 /usr/local/scratch/workflow/runtime/pipeline \
	&& mkdir /usr/local/scratch/workflow/scripts && chmod 777 /usr/local/scratch/workflow/scripts

RUN mkdir /tmp/pipelines_building && chmod 777 /tmp/pipelines_building

#--------------------------------------------------------------------------------
# LGTSEEK PROJECT

COPY project.config /tmp/.

RUN mkdir -p /opt/projects/lgtseek \
	&& mkdir /opt/projects/lgtseek/output_repository \
	&& mkdir /opt/projects/lgtseek/software \
	&& mkdir /opt/projects/lgtseek/workflow \
	&& mkdir /opt/projects/lgtseek/workflow/lock_files \
	&& mkdir /opt/projects/lgtseek/workflow/project_id_repository \
	&& mkdir /opt/projects/lgtseek/workflow/runtime \
	&& mkdir /opt/projects/lgtseek/workflow/runtime/pipeline \
	&& touch /opt/projects/lgtseek/workflow/project_id_repository/valid_id_repository \
        && cp /tmp/project.config /opt/projects/lgtseek/workflow/.

#--------------------------------------------------------------------------------
# Scripts

ENV PERL5LIB=/opt/package_lgtseek/autopipe_package/ergatis/lib

#RUN mkdir -p /opt/scripts
#WORKDIR /opt/scripts

#COPY wrapper.sh /opt/scripts/wrapper.sh
#RUN chmod 755 /opt/scripts/wrapper.sh

#COPY file.fasta /tmp/.

#--------------------------------------------------------------------------------
# Default Command

# This command starts a pipeline upon launching the container
#CMD [ "/opt/scripts/wrapper.sh" ]
