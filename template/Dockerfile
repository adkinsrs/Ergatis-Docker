############################################################
# Template Dockerfile
# Builds off of the Ergatis core Dockerfile
############################################################

FROM adkinsrs/ergatis

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

EXPOSE 80

# The project name
ARG PROJECT=###PROJECT_NAME###

#--------------------------------------------------------------------------------
# SOFTWARE

ARG SOFTWARE_VERSION=0.7.15
ARG SOFTWARE_DOWNLOAD_URL=https://github.com/SOFTWARE/archive/v${SOFTWARE_VERSION}.tar.gz

# Lets install the other stuff now
RUN apt-get update && apt-get install -y \
	ant \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

# CPAN modules
RUN cpanm --force \
	Bio::Perl \
	Bio::DB::EUtilities

#--------------------------------------------------------------------------------
# SOFTWARE -- install in /opt/packages/SOFTWARE

RUN mkdir -p /usr/src/SOFTWARE
WORKDIR /usr/src/SOFTWARE

RUN curl -SL $SOFTWARE_DOWNLOAD_URL -o SOFTWARE.tar.gz \
	&& tar --strip-components=1 -xvzf SOFTWARE.tar.gz -C /usr/src/SOFTWARE \
	&& rm SOFTWARE.tar.gz \
	&& make all \
	&& ln -s /usr/src/SOFTWARE /opt/packages/SOFTWARE \
	&& chmod 755 /opt/packages/SOFTWARE/*

#--------------------------------------------------------------------------------
# PROJECT REPOSITORY SETUP

# Have ergatis.ini point to new project so we can quickly access it
RUN sed -i.bak "s/CUSTOM/$PROJECT/g" /var/www/html/ergatis/cgi/ergatis.ini

USER www-data

COPY project.config /tmp/.
RUN mkdir -p /opt/projects/$PROJECT \
	&& mkdir /opt/projects/$PROJECT/output_repository \
	&& mkdir /opt/projects/$PROJECT/workflow \
	&& mkdir /opt/projects/$PROJECT/workflow/lock_files \
	&& mkdir /opt/projects/$PROJECT/workflow/project_id_repository \
	&& mkdir /opt/projects/$PROJECT/workflow/runtime \
	&& mkdir /opt/projects/$PROJECT/workflow/runtime/pipeline \
	&& touch /opt/projects/$PROJECT/workflow/project_id_repository/valid_id_repository \
    && cp /tmp/project.config /opt/projects/$PROJECT/workflow/.

# Making this as a volume in case we'd like to pass this data to another image
VOLUME /opt/projects/$PROJECT/output_repository

#--------------------------------------------------------------------------------
# SCRIPTS -- Any addition post-setup scripts that need to be run

# These are just scripts I am using to create and run the pipeline without using the UI
#COPY configure_pipeline.sh /opt/scripts/configure_pipeline.sh
#COPY run_pipeline.sh /opt/scripts/run_pipeline.sh

# Lastly change to root directory
#CMD ["/bin/bash"]
WORKDIR /
# ... and start apache as root
USER root
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
