# Ergatis-Docker

## Purpose
Docker container for the Ergatis web framework that runs various pipelines as their own Docker microservice containers

## General information

### Base Ergatis
The core/ directory stores the core Ergatis contents necessary to build a pipeline-less Ergatis container.  It contains the basic Ergatis website, and just some general code that will be used.  Normally one would not build the Ergatis image on its own, but it may prove useful if the developer wants to have a blank slate for prototyping a pipeline microservice, and/or wanted to commit the Docker image rather than build from a Dockerfile.  This Ergatis Docker image inherits from the Workflow Docker image, which itself inherits from Ubuntu 14.04

### Ergatis Pipelines
Other specific directories represent certain pipelines that can created and launched as their own containers through their own Docker images.  The Dockerfile for each pipeline microservice builds off of the original Ergatis Docker image and will dictate installation of specific programs and the setup of that project repository and pipeline.  Each pipeline microservice directory should contain its own internal directories for scripts, libraries, config files, and UI for creating and running the pipeline within Ergatis.

### Tag naming conventions
For both the Ergatis and pipeline images, the "latest" tag will essentially be the equivalent of the development tag.  Formal release tags will have a version number (v1.0, v1.1, etc.)

## Setting up volumes for input_data

NOTE:  Since currently the only pipeline in development is the lgtseek pipeline, this is where I am posting directions for now.

```
cd ./lgtseek
mkdir input_data/donor_ref
mkdir input_data/host_ref
mkdir input_data/refseq_ref
```
These three directories are where you would place your donor reference, host reference, or RefSeq reference data respectively.  For each reference, a single fasta-formatted file will be accepted, or a list file containing the paths of fasta-formatted files in the same directory (the list file must end in .list) 

## Starting a Docker container using Docker Compose
These will use the LGTSeek pipeline as an example.

To run a docker container:
```
cd ./lgtseek
docker-compose up -d
```
Note that the container will run in detached mode (-d option), meaning it will run in the background.  The first time a container is created from a given image may take a little bit longer to execute, since Docker needs to pull the image from the Dockerhub registry first.

Verify the docker container is up by running:
```
docker ps
```
This should give you valuable information such as the container ID, time it has been running, among other things

The access the UI to create your pipeline, please go to
[http://localhost:8080/pipeline_builder/](http://localhost:8080/pipeline_builder/).

In your internet browser, you can access the Ergatis homepage by navigating to [http://localhost:8080/ergatis/](http://localhost:8080/ergatis/).

To stop the container, and free up valuable CPU and memory resources, run the following:
```
cd ./lgtseek
docker-compose down -v
```

## Future improvements (or TODOs)
* Figure out the grid/cloud management system.  Internally we use Oracle Grid Engine to farm out jobs to various grid nodes.  Will probably have to investigate Docker Swarm as well as Amazon ECS.
* Eventually will need to tag the Ergatis Docker image as a release version rather than use the "latest" tag.
* Convert each pipeline microservice into it's own stack via docker-compose.  This would allow less hassle in setting up things like Apache2 and MySQL in a single Dockerfile.
* Make Workflow into its own Docker image, then use that via Docker Swarm to parallelize grid jobs.  Relates to the first bullet point
