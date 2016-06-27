###########################################################
# Dockerfile to build container lgtseek core image
# Based on Ubuntu
############################################################

FROM adkinsrs/workflow

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

EXPOSE 80

#--------------------------------------------------------------------------------
# SOFTWARE

ARG BSML_VERSION=v2r18b1
ARG BSML_DOWNLOAD_URL=http://sourceforge.net/projects/bsml/files/bsml/bsml-${BSML_VERSION}/bsml-${BSML_VERSION}.tar.gz

ARG ERGATIS_VERSION=v2r19b4
ARG ERGATIS_DOWNLOAD_URL=https://github.com/jorvis/ergatis/archive/${ERGATIS_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BASICS

RUN apt-get update && apt-get install -y \
	apache2 \
	autoconf \
	build-essential \
	cpanminus \
	curl \
	dh-make-perl \
	git \
	libapache2-mod-php5 \
	php5 \
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

# Make 'packages' dir.  Installs will build into there or will be symlinked there
RUN mkdir -p /opt/packages

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

COPY ergatis.ini /var/www/html/ergatis/

# Set up apache
COPY 000-default.conf /etc/apache2/sites-enabled/.
COPY ergatis.conf /etc/apache2/conf-enabled/.
RUN a2enmod cgid
RUN a2enmod php5
#CMD service apache2 start

# Set up area to store scripts
RUN mkdir -p /opt/scripts
COPY wrapper_template.sh /opt/scripts
COPY substitute_in_wrapper.sh /opt/scripts

# Lastly, set working directory to root directory
WORKDIR /
# ... and start apache
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

#--------------------------------------------------------------------------------
# ONBUILD SETUP FOR PIPELINES (takes place in context with the inheriting image)

# Set up the pipeline builder UI site
ONBUILD RUN mkdir /var/www/html/pipeline_builder
ONBUILD COPY pipeline_builder/ /var/www/html/pipeline_builder/

# Set up Ergatis application area
ONBUILD RUN mkdir /opt/ergatis/bin
ONBUILD COPY bin/ /opt/ergatis/bin/
ONBUILD RUN mkdir /opt/ergatis/docs
ONBUILD COPY docs/ /opt/ergatis/docs/
ONBUILD COPY lib/perl5 /opt/ergatis/lib/perl5/
ONBUILD RUN mkdir /opt/ergatis/pipeline_templates
ONBUILD COPY pipeline_templates/ /opt/ergatis/pipeline_templates/
ONBUILD COPY software.config /opt/ergatis/.

# Build wrapper scripts for each perl script in /opt/ergatis/bin
ONBUILD COPY exec_scripts.txt /tmp/.
ONBUILD RUN /opt/scripts/substitute_in_wrapper.sh
