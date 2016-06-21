# Ergatis-Docker

## Purpose
Docker container for the Ergatis web framework that runs various pipelines as their own Docker microservice containers

## General information

### Base Ergatis
The core/ directory stores the core Ergatis contents necessary to build a pipeline-less Ergatis container.  It contains the basic Ergatis website, and just some general code that will be used.  Normally one would not build the Ergatis image on its own, but it may prove useful if the developer wants to have a blank slate for prototyping a pipeline microservice, and/or wanted to commit the Docker image rather than build from a Dockerfile

### Ergatis Pipelines
Other specific directories represent certain pipelines that can created and launched as their own containers through their own Docker images.  The Dockerfile for each pipeline microservice builds off of the original Ergatis Docker image and will dictate installation of specific programs and the setup of that project repository and pipeline.  Each pipeline microservice directory should contain its own internal directories for scripts, libraries, config files, and UI for creating and running the pipeline within Ergatis.

### Tag naming conventions
For both the Ergatis and pipeline images, the "latest" tag will essentially be the equivalent of the development tag.  Formal release tags will have a version number (v1.0, v1.1, etc.)

## Starting a Docker container
These will use the LGTSeek pipeline as an example.

To run a docker container:
`docker run -p 8080:80 -d adkinsrs/lgtseek`
Note that the container will run in detached mode (-d option), meaning it will run in the background

Verify the docker container is up by running:
`docker ps`
This should give you valuable information such as the container ID, time it has been running, among other things

In your internet browser, you can access the Ergatis homepage by navigating to [http://localhost:8080/ergatis/](http://localhost:8080/ergatis/).

To stop the container, and free up valuable CPU and memory resources, run the following:
`docker stop <CONTAINER ID>`
where <CONTAINER ID>  is the alphanumeric ID obtained from the earlier `docker ps` command

## Future improvements (or TODOs)
* Figure out the grid/cloud management system.  Internally we use Oracle Grid Engine to farm out jobs to various grid nodes.  Will probably have to investigate Docker Swarm as well as Amazon ECS.
* Eventually will need to tag the Ergatis Docker image as a release version rather than use the "latest" tag.
* Currently the Ergatis site can be loaded, but I have not done much in the way of bug testing.  So far, I've been rather lax in determining CPAN mod dependencies that need to be installed.  This will become more imperative as I start working more on the images of individual pipelines.
* It may be a good idea to tell users to link to the Ergatis homepage, and then have the individual pipeline builder UIs be accessible from there via a link somewhere on the home page.  To that extent, it may be a good idea to make the Ergatis page localhost:8080 instead of localhost:8080/ergatis
