# Ergatis-Docker
Docker container for the Ergatis web framework that runs various pipelines as their own Docker microservice containers

The core/ directory stores the core Ergatis contents necessary to build a pipeline-less Ergatis container.  It contains the basic Ergatis website, and just some general code that will be used.

Other specific directories represent certain pipelines that can created and launched as their own containers through their own Docker images.  The Dockerfile for each pipeline microservice builds off of the original Ergatis Docker image and will dictate installation of specific programs and the setup of that project repository and pipeline.  Each pipeline microservice directory should contain its own internal directories for scripts, libraries, config files, and UI for creating and running the pipeline within Ergatis.
