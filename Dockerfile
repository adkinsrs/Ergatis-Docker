###########################################################
# Dockerfile to build container lgtseek core image
# Based on Ubuntu
############################################################

FROM adkinsrs/workflow:3.2.0

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

#--------------------------------------------------------------------------------
# BASICS

# 1) Install general things
# 2) Install Perl things
# 3) Install Debian things
# 4) Make various directories.
### /opt/packages is where software installs will be placed or symlinked to
### /var/www/html is where the Ergatis site and pipeline building UI will be

RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
	autoconf \
	build-essential \
	cpanminus \
	dh-make-perl \
	git \
	perl \
	vim \
	wget \
	zip unzip \
	zlib1g-dev \
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
	libperlio-gzip-perl \
	libxml-parser-perl \
	libxml-rss-perl \
	libxml-twig-perl \
	libxml-writer-perl \
	libxml-libxml-perl \
	&& apt-get -q clean autoclean \
	&& apt-get -q autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& cpanm --force \
	File::Mirror \
	Log::Cabin \
	Term::ProgressBar \
	&& chmod 777 /opt \
	&& mkdir /opt/packages && chmod 777 /opt/packages

#--------------------------------------------------------------------------------
# SCRATCH

RUN mkdir -m 0777 -p /usr/local/scratch \
	&& mkdir -m 0777 /usr/local/scratch/ergatis \
	&& mkdir -m 0777 /usr/local/scratch/ergatis/archival \
	&& mkdir -m 0777 /usr/local/scratch/workflow  \
	&& mkdir -m 0777 /usr/local/scratch/workflow/id_repository  \
	&& mkdir -m 0777 /usr/local/scratch/workflow/runtime \
	&& mkdir -m 0777 /usr/local/scratch/workflow/runtime/pipeline \
	&& mkdir -m 0777 /usr/local/scratch/workflow/scripts \
	&& mkdir -m 0777 /tmp/pipelines_building 

#--------------------------------------------------------------------------------
# ERGATIS SETUP

# Set up lib directory
RUN mkdir -p /opt/ergatis/lib/
COPY lib/ /opt/ergatis/lib/
ENV PERL5LIB=/opt/ergatis/lib/perl5

# Change the level of debugging
COPY log4j.properties /opt/workflow/

# Add Ergatis.ini config file
COPY ergatis.ini /opt/ergatis

# Set up area to store scripts
RUN mkdir -p /opt/scripts
COPY create_wrappers.sh /opt/scripts
COPY perl2wrapper_ergatis.pl /opt/scripts
COPY python2wrapper_ergatis.pl /opt/scripts
COPY julia2wrapper_ergatis.pl /opt/scripts

# Lastly, set working directory to root directory
WORKDIR /
CMD ["/bin/bash"]
