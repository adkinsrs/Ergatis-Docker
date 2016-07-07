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

## Starting a Docker container
These will use the LGTSeek pipeline as an example.

To run a docker container:
```
docker run -p 8080:80 -v <input_data_path>:/mnt/input_data -d adkinsrs/lgtseek
```
Note that the container will run in detached mode (-d option), meaning it will run in the background.  The first time a container is created from a given image may take a little bit longer to execute, since Docker needs to pull the image from the Dockerhub registry first.

The -v option specifies the mount path of the input_data directory from host to container (separated by a semi-colon). Replace the <input_data_path> with the path of your input data on the host.  The container path of /mnt/input_data should NOT be changed, as this is where the specified Ergatis pipeline will look for initial input

Verify the docker container is up by running:
```
docker ps
```
This should give you valuable information such as the container ID, time it has been running, among other things

In your internet browser, you can access the Ergatis homepage by navigating to [http://localhost:8080/ergatis/](http://localhost:8080/ergatis/).

To stop the container, and free up valuable CPU and memory resources, run the following:
```
docker stop <CONTAINER ID>
```
where <CONTAINER ID>  is the alphanumeric ID obtained from the earlier `docker ps` command.  Only the first few characters of the <CONTAINER ID> need to be entered, since Docker can recognize which full-length container ID the character string corresponds to

To remove the container permanently, run the following:
```
docker rm <CONTAINER ID>
```

## Future improvements (or TODOs)
* Figure out the grid/cloud management system.  Internally we use Oracle Grid Engine to farm out jobs to various grid nodes.  Will probably have to investigate Docker Swarm as well as Amazon ECS.
* Eventually will need to tag the Ergatis Docker image as a release version rather than use the "latest" tag.
* Convert each pipeline microservice into it's own stack via docker-compose.  This would allow less hassle in setting up things like Apache2 and MySQL in a single Dockerfile.
* Make Workflow into its own Docker image, then use that via Docker Swarm to parallelize grid jobs.  Relates to the first bullet point
