###########################################################
# Dockerfile to build the Workflow service
# Based on Alpine (minimal Linux installation)
############################################################

FROM ubuntu:trusty

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

ARG WORKFLOW_VERSION=3.1.5
ARG WORKFLOW_DOWNLOAD_URL=http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-${WORKFLOW_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BASICS

RUN apt-get update && apt-get install -y \
    curl \
    && apt-get clean autoclean \
	&& apt-get autoremove -y

#--------------------------------------------------------------------------------
# WORKFLOW -- install in /opt/workflow

RUN mkdir -p /usr/src/workflow
WORKDIR /usr/src/workflow

COPY workflow.deploy.answers /tmp/.

RUN curl -SL $WORKFLOW_DOWNLOAD_URL -o workflow.tar.gz \
	&& tar -xvf workflow.tar.gz -C /usr/src/workflow \
	&& rm workflow.tar.gz \
	&& mkdir -p /opt/workflow/server-conf \
	&& ./deploy.sh < /tmp/workflow.deploy.answers

RUN chmod 777 /opt/workflow/server-conf \
	&& chown www-data:www-data /opt/workflow/server-conf/idfile
COPY htc.conf /opt/workflow/server-conf

RUN mkdir -p /local/services/workflow/mockserver/working \ 
	&& chmod 777 /local/services/workflow/mockserver/working

#ENTRYPOINT [/opt/workflow/RunWorkflow]	# This will break Ergatis if Ergatis inherits it
CMD ["/bin/bash"]

# Lastly, set working directory to root directory
WORKDIR /
