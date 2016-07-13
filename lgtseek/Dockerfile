############################################################
# Dockerfile to build container lgtseek pipeline image
# Builds off of the Ergatis core Dockerfile
############################################################

FROM adkinsrs/ergatis

MAINTAINER Shaun Adkins <sadkins@som.umaryland.edu>

EXPOSE 80

# The project name
ARG PROJECT=lgtseek

#--------------------------------------------------------------------------------
# SOFTWARE

ARG BWA_VERSION=0.7.15
ARG BWA_DOWNLOAD_URL=https://github.com/lh3/bwa/archive/v${BWA_VERSION}.tar.gz

ARG NCBI_BLAST_VERSION=2.2.9
ARG NCBI_BLAST_DOWNLOAD_URL=ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy/${NCBI_BLAST_VERSION}/blast-${NCBI_BLAST_VERSION}-amd64-linux.tar.gz

ARG HTSLIB_VERSION=1.3.1
ARG HTSLIB_DOWNLOAD_URL=https://github.com/samtools/htslib/archive/${HTSLIB_VERSION}.tar.gz

ARG PICARD_VERSION=2.5.0
ARG PICARD_DOWNLOAD_URL=https://github.com/broadinstitute/picard/archive/${PICARD_VERSION}.tar.gz

ARG PRINSEQ_VERSION=0.20.4
ARG PRINSEQ_DOWNLOAD_URL=http://mirror.ufs.ac.za/applications/prinseq/standalone/prinseq-lite-${PRINSEQ_VERSION}.tar.gz
#ARG PRINSEQ_DOWNLOAD_URL=https://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-${PRINSEQ_VERSION}.tar.gz

ARG SAMTOOLS_VERSION=1.3
ARG SAMTOOLS_DOWNLOAD_URL=https://github.com/samtools/samtools/archive/${SAMTOOLS_VERSION}.tar.gz

ARG SRA_VERSION=2.6.3
ARG SRA_DOWNLOAD_URL=https://github.com/ncbi/sra-tools/archive/${SRA_VERSION}.tar.gz

### OpenJDK-8-JDK is natively not available for Ubuntu 14.04 so we need a workaround here
# Install the python script required for "add-apt-repository"
RUN apt-get update && apt-get install -y software-properties-common
# Setup the openjdk 8 repo
RUN add-apt-repository ppa:openjdk-r/ppa
# Install java8
RUN apt-get update && apt-get install -y openjdk-8-jdk

# Lets install the other stuff now
RUN apt-get update && apt-get install -y \
	ant \
	libmagic-dev \
	libxml2 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# CPAN modules
RUN cpanm --force \
	MongoDB \
	Bio::DB::EUtilities
#	BioPerl
#	Mouse

# For some reason BioPerl is not installing fine right now
RUN cpanm --mirror-only --mirror https://stratopan.com/MeNoSeeGood/Manatee/master BioPerl

#--------------------------------------------------------------------------------
# BWA -- install in /opt/packages/bwa

RUN mkdir -p /usr/src/bwa
WORKDIR /usr/src/bwa

RUN curl -SL $BWA_DOWNLOAD_URL -o bwa.tar.gz \
	&& tar --strip-components=1 -xvzf bwa.tar.gz -C /usr/src/bwa \
	&& rm bwa.tar.gz \
	&& make all \
	&& ln -s /usr/src/bwa /opt/packages/bwa \
	&& chmod 755 /opt/packages/bwa/*

#--------------------------------------------------------------------------------
# HTSLIB -- install in /opt/packages/htslib (required for Samtools)

RUN mkdir -p /usr/src/htslib7yy
WORKDIR /usr/src/htslib

RUN curl -SL $HTSLIB_DOWNLOAD_URL -o htslib.tar.gz \
	&& tar --strip-components=1 -xvzf htslib.tar.gz -C /usr/src/htslib \
	&& rm htslib.tar.gz \
	&& autoconf

#--------------------------------------------------------------------------------
# SAMTOOLS -- install in /opt/packages/samtools
# Had to consult this to get it to build https://github.com/samtools/samtools/issues/500
# Also had to grab an updated "configure.ac" file since it patched a bug with the --without-curses options in ./configure

RUN mkdir -p /usr/src/samtools
WORKDIR /usr/src/samtools

RUN curl -SL $SAMTOOLS_DOWNLOAD_URL -o samtools.tar.gz \
	&& tar --strip-components=1 -xvzf samtools.tar.gz -C /usr/src/samtools \
	&& rm samtools.tar.gz \
	&& mkdir autoconf \
	&& wget -O autoconf/ax_with_htslib.m4 https://github.com/samtools/samtools/files/62424/ax_with_htslib.m4.txt \
	&& wget -O ./configure.ac https://raw.githubusercontent.com/samtools/samtools/develop/configure.ac \
	&& aclocal -I./autoconf \
	&& autoconf \
	&&./configure --without-curses --prefix=/opt/packages/samtools \
	&& make \
	&&  make install

#--------------------------------------------------------------------------------
# PICARD -- install in /opt/packages/picard

RUN mkdir -p /usr/src/picard_tools
RUN mkdir -p /opt/packages/picard/

# Clone out htsjdk. First turn off git ssl verification
WORKDIR /usr/src/picard_tools
RUN git config --global http.sslVerify false \
	&& git clone https://github.com/samtools/htsjdk.git
WORKDIR /usr/src/picard_tools/htsjdk
RUN ./gradlew jar

# Build the distribution jar, clean up everything else
WORKDIR /usr/src/picard_tools
RUN curl -SL $PICARD_DOWNLOAD_URL -o picard.tar.gz \
	&& tar --strip-components=1 -xvzf picard.tar.gz -C /usr/src/picard_tools \
	&& rm picard.tar.gz \
	&& ant clean all \
    && mv dist/picard.jar picard.jar \
    && mv src/scripts/picard/docker_helper.sh docker_helper.sh \
    && ant clean \
    && rm -rf htsjdk \
    && rm -rf src \
    && rm -rf lib \
    && rm build.xml \
	&& ln -s /usr/src/picard_tools /opt/packages/picard_tools

#--------------------------------------------------------------------------------
# PRINSEQ -- install in /opt/packages/prinseq

RUN mkdir -p /usr/src/prinseq
WORKDIR /usr/src/prinseq

RUN curl -SL $PRINSEQ_DOWNLOAD_URL -o prinseq.tar.gz \
	&& tar --strip-components=1 -xvzf prinseq.tar.gz -C /usr/src/prinseq \
	&& rm prinseq.tar.gz \
	&& ln -s /usr/src/prinseq /opt/packages/prinseq

#--------------------------------------------------------------------------------
# SRA_TOOKKIT -- install in /opt/packages/sra-tools

RUN mkdir -p /usr/src/ncbi/sratoolkit
RUN mkdir -p /opt/packages/sra-tools
RUN mkdir -p /usr/src/ncbi
WORKDIR /usr/src/ncbi

# First install some dependenciea
# Clone the Git repos first
RUN git clone https://github.com/ncbi/ncbi-vdb.git
RUN git clone https://github.com/ncbi/ngs.git

# Install NCBI-vdb
WORKDIR /usr/src/ncbi/ncbi-vdb
RUN ./configure \
	&& make \
	&& make install

# Install NGS
WORKDIR /usr/src/ncbi/ngs
RUN ./configure \
	&& make -C ngs-sdk \
	&& make -C ngs-java \
	&& make -C ngs-python \
	&& make -C ngs-sdk install \
	&& make -C ngs-java install \
	&& make -C ngs-python install

# Now install SRA toolkit
WORKDIR /usr/src/ncbi/sratoolkit
RUN curl -SL $SRA_DOWNLOAD_URL -o sra.tar.gz \
	&& tar --strip-components=1 -xvzf sra.tar.gz -C /usr/src/ncbi/sratoolkit \
	&& rm sra.tar.gz \
	&& ./configure --prefix=/opt/packages/sra-tools \
	&& make \
	&& make install

#--------------------------------------------------------------------------------
# NCBI_BLAST -- install in /opt/packages/ncbi_blast

RUN mkdir -p /usr/src/ncbi/ncbi_blast
WORKDIR /usr/src/ncbi_blast

RUN curl -SL $NCBI_BLAST_DOWNLOAD_URL -o ncbi_blast.tar.gz \
	&& tar --strip-components=1 -xvzf ncbi_blast.tar.gz -C /usr/src/ncbi_blast \
	&& rm ncbi_blast.tar.gz \ 
	&& ln -s /usr/src/ncbi_blast /opt/packages/ncbi_blast

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
COPY configure_pipeline.sh /opt/scripts/configure_pipeline.sh
COPY run_pipeline.sh /opt/scripts/run_pipeline.sh


# Lastly change to root directory
#CMD ["/bin/bash"]
WORKDIR /
# ... and start apache as root
USER root
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
