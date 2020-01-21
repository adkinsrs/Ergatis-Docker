###########################################################
# Dockerfile to install libraries for Ergatis
# Has no function as an independent image
# Based on Ubuntu
############################################################

FROM adkinsrs/workflow:3.2.0
MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

#--------------------------------------------------------------------------------
# BASICS

# 1) Install general things
# 2) Install Perl things
# 3) Install Debian things
# 4) Make various directories.
### /opt/packages is where software installs will be placed or symlinked to
### /var/www/html is where the Ergatis site and pipeline building UI will be

RUN apt-get -q update && apt-get -q install -y --no-install-recommends \
	apache2 \
	autoconf \
	build-essential \
	cpanminus \
	dh-make-perl \
	git \
	libapache2-mod-php5 \
	perl \
	php5 \
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
	libmath-combinatorics-perl \
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
	&& mkdir /opt/packages && chmod 777 /opt/packages \
	&& mkdir -p /var/www/html/config && chmod 777 /var/www/html/config

#--------------------------------------------------------------------------------
# APACHE SETUP
COPY 000-default.conf /etc/apache2/sites-enabled/.
COPY ergatis.conf /etc/apache2/conf-enabled/.
RUN a2enmod cgid
RUN a2enmod php5

# Set up site
RUN mkdir /var/www/html/ergatis
COPY htdocs/ /var/www/html/ergatis/
COPY ergatis.ini /var/www/html/ergatis/cgi

EXPOSE 80
#--------------------------------------------------------------------------------
# ERGATIS SETUP

# Set up lib directory
RUN mkdir -p /opt/ergatis/lib/perl5
ENV PERL5LIB=/opt/ergatis/lib/perl5

ENTRYPOINT ["apache2"]
CMD ["-D", "FOREGROUND"]


