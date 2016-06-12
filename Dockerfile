############################################################
# Dockerfile to build container lgtseek pipeline image
# Based on the LGTSeek core Dockerfile
############################################################ 

FROM lgtseek-core

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

#--------------------------------------------------------------------------------
# SOFTWARE

ENV ERGATIS_VERSION v2r19b4
ENV ERGATIS_DOWNLOAD_URL https://github.com/jorvis/ergatis/archive/$ERGATIS_VERSION.tar.gz

# Placeholder name for now... do I want to create a separate repo for this?
#ENV LGTSEEK_VERSION 1.0
#ENV LGTSEEK_DOWNLOAD_URL https://github.com/adkinsrs/LGTSeek_pipeline/archive/master.zip

#--------------------------------------------------------------------------------
# LGTSEEK -- install in /opt/package_lgtseek

RUN mkdir -p /opt/src/lgtseek
WORKDIR /opt/src/lgtseek

#COPY ergatis.install.fix /tmp/.
COPY ergatis.ini /tmp/.
COPY software.config /tmp/.

#RUN curl -SL $LGTSEEK_DOWNLOAD_URL -o lgtseek.zip \
#	&& unzip -o lgtseek.zip \
#	&& rm lgtseek.zip \
#	&& mv /opt/src/lgtseek/lgtseek_pipeline-master /opt/package_lgtseek \
#	&& cd /opt/package_lgtseek/autopipe_package/ergatis \
#	&& cp /tmp/ergatis.install.fix . \
#	&& ./ergatis.install.fix \
#	&& perl Makefile.PL INSTALL_BASE=/opt/package_lgtseek \
#	&& make \
#	&& make install \
#	&& cp /tmp/ergatis.ini /opt/package_lgtseek/autopipe_package/ergatis/htdocs/cgi/ergatis.ini \
#	&& cp /tmp/ergatis.ini /opt/package_lgtseek/autopipe_package/ergatis.ini \
#	&& cp /tmp/software.config /opt/package_lgtseek/software.config

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