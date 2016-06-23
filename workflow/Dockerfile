###########################################################
# Dockerfile to build the Workflow service
# Based on Alpine (minimal Linux installation)
############################################################

FROM alpine

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

ARG WORKFLOW_VERSION=3.1.5
ARG WORKFLOW_DOWNLOAD_URL=http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-${WORKFLOW_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BASICS

RUN apk add --update --no-cache \
    bash \
    curl \
    perl \
    && rm -rf /var/cache/apk/*

#--------------------------------------------------------------------------------
# WORKFLOW -- install in /opt/workflow

RUN mkdir -p /usr/src/workflow
WORKDIR /usr/src/workflow

COPY workflow.deploy.answers /tmp/.

RUN curl -SL $WORKFLOW_DOWNLOAD_URL -o workflow.tar.gz \
	&& tar -xvf workflow.tar.gz -C /usr/src/workflow \
	&& rm workflow.tar.gz \
	&& mkdir -p /opt/workflow/server-conf \
	&& chmod 777 /opt/workflow/server-conf \
	&& ./deploy.sh < /tmp/workflow.deploy.answers

#ENTRYPOINT [/opt/workflow/RunWorkflow]
CMD ["/bin/bash"]

# Lastly, set working directory to root directory
WORKDIR /
