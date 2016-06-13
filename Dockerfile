############################################################
# Dockerfile to build container lgtseek pipeline image
# Builds off of the Ergatis core Dockerfile
############################################################

FROM lgtseek:ergatis-core

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

# The project name
ARG PROJECT lgtseek

#--------------------------------------------------------------------------------
# SOFTWARE

ENV WORKFLOW_VERSION 3.1.5
ENV WORKFLOW_DOWNLOAD_URL http://sourceforge.net/projects/tigr-workflow/files/tigr-workflow/wf-$WORKFLOW_VERSION.tar.gz

ENV BWA_VERSION 0.7.12
ENV BWA_DOWNLOAD_URL https://github.com/lh3/bwa/archive/v${BWA_VERSION}.tar.gz

ENV SAMTOOLS_VERSION 1.3.1
ENV SAMTOOLS_DOWNLOAD_URL https://github.com/samtools/samtools/archive/${SAMTOOLS_VERSION}.tar.gz

ENV NCBI_BLAST_VERSION 2.3.0
ENV NCBI_BLAST_DOWNLOAD_URL ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-${NCBI_BLAST_VERSION}+-x64-linux.tar.gz

ENV PICARD_VERSION 2.4.1
ENV PICARD_DOWLOAD_URL https://github.com/broadinstitute/picard/archive/${PICARD_VERSION}.tar.gz

ENV PRINSEQ_VERSION 0.20.4
ENV PRINSEQ_DOWNLOAD_URL https://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-${PRINSEQ_VERSION}.tar.gz
ENV SRA_VERSION 2.6.3
ENV SRA_DOWLOAD_URL https://github.com/ncbi/sra-tools/archive/${SRA_VERSION}.tar.gz

#--------------------------------------------------------------------------------
# BWA -- install in /opt/bwa

RUN mkdir -p /usr/src/bwa
WORKDIR /usr/src/bwa

RUN curl -SL $BWA_DOWNLOAD_URL -o bwa.tar.gz \
	&& tar --strip-components=1 -xvf bwa.tar.gz -C /usr/src/bwa \
	&& rm bwa.tar.gz \
	&& make \
	&& make install

#--------------------------------------------------------------------------------
# SAMTOOLS -- install in /opt/samtools

RUN mkdir -p /usr/src/samtools
WORKDIR /usr/src/samtools

RUN curl -SL $SAMTOOLS_DOWNLOAD_URL -o samtools.tar.gz \
	&& tar --strip-components=1 -xvf samtools.tar.gz -C /usr/src/samtools \
	&& rm samtools.tar.gz \
	&& sed -i -e 's/= \/usr\/local/= \/opt\/samtools/' Makefile \
	&& make \
	&& make install

#--------------------------------------------------------------------------------
# PICARD -- install in /opt/picard

RUN mkdir -p /usr/src/picard
WORKDIR /usr/src/picard

RUN curl -SL $PICARD_DOWNLOAD_URL -o picard.tar.gz \
	&& tar --strip-components=1 -xvf picard.tar.gz -C /usr/src/picard_tools \
	&& rm picard.tar.gz \
	&& ant clone-htsjdk \
	&& ant \
	&& ln -s /usr/src/picard_tools /opt/picard_tools

#--------------------------------------------------------------------------------
# PRINSEQ -- install in /opt/prinseq

RUN mkdir -p /usr/src/prinseq
WORKDIR /usr/src/prinseq

RUN curl -SL $PRINSEQ_DOWNLOAD_URL -o prinseq.tar.gz \
	&& tar --strip-components=1 -xvf prinseq.tar.gz -C /usr/src/prinseq \
	&& rm prinseq.tar.gz \
	&& ln -s /usr/src/prinseq /opt/prinseq

#--------------------------------------------------------------------------------
# SRA_TOOKKIT -- install in /opt/sratoolkit

RUN mkdir -p /usr/src/sratoolkit
WORKDIR /usr/src/sratoolkit

RUN curl -SL $SRA_DOWNLOAD_URL -o sra.tar.gz \
	&& tar --strip-components=1 -xvf sra.tar.gz -C /usr/src/sratoolkit \
	&& rm sra.tar.gz \
	&& sed -i -e 's/..CURDIR./\/opt\/sratoolkit/' Makefile \
	&& make \
	&& make install

#--------------------------------------------------------------------------------
# NCBI_BLAST -- install in /opt/ncbi_blast

RUN mkdir -p /usr/src/ncbi_blast
WORKDIR /usr/src/ncbi_blast

RUN curl -SL $NCBI_BLAST_DOWNLOAD_URL -o ncbi_blast.tar.gz \
	&& tar --strip-components=1 -xvf ncbi_blast.tar.gz -C /usr/src/ncbi_blast \
	&& rm ncbi_blast.tar.gz \
	&& sed -i -e 's/..HOME./\/opt\/ncbi_blast/' Makefile \
	&& make \
	&& make install

#--------------------------------------------------------------------------------
# ERGATIS SETUP

COPY bin /opt/ergatis/.
COPY docs /opt/ergatis/.
COPY htdocs /opt/ergatis/.
COPY lib /opt/ergatis/.
COPY pipeline_templates /opt/ergatis/.

#--------------------------------------------------------------------------------
# PROJECT REPOSITORY SETUP

COPY project.config /tmp/.

RUN mkdir -p /opt/projects/PROJECT \
	&& mkdir /opt/projects/PROJECT/output_repository \
	&& mkdir /opt/projects/PROJECT/software \
	&& mkdir /opt/projects/PROJECT/workflow \
	&& mkdir /opt/projects/PROJECT/workflow/lock_files \
	&& mkdir /opt/projects/PROJECT/workflow/project_id_repository \
	&& mkdir /opt/projects/PROJECT/workflow/runtime \
	&& mkdir /opt/projects/PROJECT/workflow/runtime/pipeline \
	&& touch /opt/projects/PROJECT/workflow/project_id_repository/valid_id_repository \
    && cp /tmp/project.config /opt/projects/PROJECT/workflow/.

#--------------------------------------------------------------------------------
# Scripts


RUN mkdir -p /opt/scripts
WORKDIR /opt/scripts
