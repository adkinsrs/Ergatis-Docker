# Ergatis-Docker

[instructions still incomplete]

## Purpose
Docker container for the Ergatis web framework that runs various pipelines as their own Docker microservice containers

## General information

First things first,

Get the code:
```
git clone https://github.com/adkinsrs/Ergatis-Docker.git
cd Ergatis-Docker
```

### Ergatis Pipelines
Other specific directories represent certain pipelines that can created and launched as their own containers through their own Docker images.  The Dockerfile for each pipeline recipe builds off of the original Ergatis Docker image and will dictate installation of specific programs and the setup of that project repository and pipeline.  Each pipeline microservice directory should contain its own internal directories for scripts, libraries, config files, and UI for creating and running the pipeline within Ergatis.

You can view the various pipeline recipes available at https://github.com/adkinsrs/ergatis-docker-recipes

Each pipeline folder in that repository will contain a README on how to start that pipeline's Docker container

### Tag naming conventions
For both the Ergatis and pipeline images, the "latest" tag will essentially be the equivalent of the development tag.  Formal release tags will have a version number (v1.0, v1.1, etc.)


## Future improvements (or TODOs)
* Figure out the grid/cloud management system.  Internally we use Oracle Grid Engine to farm out jobs to various grid nodes.  Will probably have to investigate Docker Swarm as well as Amazon ECS.
