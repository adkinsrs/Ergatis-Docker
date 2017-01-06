###########################################################
# Dockerfile to build container lgtseek core image
# Based on Ubuntu
############################################################

FROM adkinsrs/workflow

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

EXPOSE 80

#--------------------------------------------------------------------------------
# BASICS

RUN apt-get update && apt-get install -y --no-install-recommands \
	apache2 \
	autoconf \
	build-essential \
	cpanminus \
	curl \
	dh-make-perl \
	git \
	libapache2-mod-php5 \
	ncbi-blast+ \
	php5 \
	vim \
	wget \
	zip \
	zlib1g-dev \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

#--------------------------------------------------------------------------------
# PERL for ergatis

RUN apt-get update && apt-get install -y --no-install-recommends \
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
	libxml-libxml-perl \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

COPY deb/lib*.deb /tmp/

RUN dpkg -i \
	/tmp/libfile-mirror-perl_0.10-1_all.deb \
	/tmp/liblog-cabin-perl_0.06-1_all.deb \
	&& rm /tmp/libfile-mirror-perl_0.10-1_all.deb \
	/tmp/liblog-cabin-perl_0.06-1_all.deb

# Make various directories.
# /opt/packages is where software installs will be placed or symlinked to
# /var/www/html is where the Ergatis site and pipeline building UI will be
RUN chmod 777 /opt \
	&& mkdir /opt/packages && chmod 777 /opt/packages \
	&& mkdir -p /var/www/html && chmod 777 /var/www/html

#--------------------------------------------------------------------------------
# APACHE SETUP
COPY 000-default.conf /etc/apache2/sites-enabled/.
COPY ergatis.conf /etc/apache2/conf-enabled/.
RUN a2enmod cgid
RUN a2enmod php5

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
	&& mkdir /tmp/pipelines_building && chmod 777 /tmp/pipelines_building

#--------------------------------------------------------------------------------
# ERGATIS SETUP

# Set up lib directory
RUN mkdir -p /opt/ergatis/lib/
COPY lib/ /opt/ergatis/lib/
ENV PERL5LIB=/opt/ergatis/lib/perl5

# Set up site
RUN mkdir /var/www/html/ergatis
COPY htdocs/ /var/www/html/ergatis/
COPY ergatis.ini /var/www/html/ergatis/cgi/

# Change the level of debugging
COPY log4j.properties /opt/workflow/

# Set up area to store scripts
RUN mkdir -p /opt/scripts
COPY create_wrappers.sh /opt/scripts
COPY perl2wrapper_ergatis.pl /opt/scripts
COPY python2wrapper_ergatis.pl /opt/scripts
COPY julia2wrapper_ergatis.pl /opt/scripts

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
ONBUILD RUN find /opt/ergatis/pipeline_templates -type f -exec /usr/bin/perl -pi -e 's/\$;NODISTRIB\$;\s?=\s?0/\$;NODISTRIB\$;=1/g' {} \;
ONBUILD COPY software.config /opt/ergatis/.

# Create the wrappers for bin executables
ONBUILD RUN sh /opt/scripts/create_wrappers.sh /opt/ergatis

