###########################################################
# Dockerfile to build container lgtseek core image
# Based on Ubuntu
############################################################

FROM ubuntu:trusty

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

EXPOSE 80

#--------------------------------------------------------------------------------
# SOFTWARE

ARG BSML_VERSION=v2r18b1
ARG BSML_DOWNLOAD_URL=http://sourceforge.net/projects/bsml/files/bsml/bsml-${BSML_VERSION}/bsml-${BSML_VERSION}.tar.gz

ARG ERGATIS_VERSION=v2r19b4
ARG ERGATIS_DOWNLOAD_URL=https://github.com/jorvis/ergatis/archive/${ERGATIS_VERSION}.tar.gz

ARG WORKFLOW_VERSION=3.1.5
ARG WORKFLOW_DOWNLOAD_URL=http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-${WORKFLOW_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BASICS

RUN apt-get update && apt-get install -y \
	ant \
	apache2 \
	autoconf \
	build-essential \
	cpanminus \
	curl \
	default-jdk\
	dh-make-perl \
	vim \
	zip \
	zlib1g-dev \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

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
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

COPY deb/lib*.deb /tmp/

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
# ERGATIS SETUP

# Set up lib directory
RUN mkdir -p /opt/ergatis/lib/
COPY lib/ /opt/ergatis/lib/
ENV PERL5LIB=/opt/ergatis/lib/perl5

# Set up site 
RUN mkdir /var/www/html/ergatis
COPY htdocs/ /var/www/html/ergatis/

COPY ergatis.ini /var/www/html/ergatis/cgi

# Set up apache
COPY 000-default.conf /etc/apache2/sites-enabled/.
COPY ergatis.conf /etc/apache2/conf-enabled/.
RUN a2enmod cgid
#CMD service apache2 start

# Lastly, set working directory to root directory
WORKDIR /
# ... and start apache
CMD /usr/sbin/apachectl -D FOREGROUND
