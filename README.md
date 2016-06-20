# Ergatis-Docker
Docker container for the Ergatis web framework that runs various pipelines as their own Docker microservice containers

The core/ directory stores the core Ergatis contents necessary to build a pipeline-less Ergatis container.  Other specific directories represent certain pipelines that can created and launched as their own containers through their own Docker images.  The Dockerfile for each pipeline microservices builds off of the original Ergatis Docker image.
