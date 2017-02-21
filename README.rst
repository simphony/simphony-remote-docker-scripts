Docker specification for SimPhoNy Remote App project
====================================================

Scripts for composing Dockerfiles that support remote access using Simphony-remote web
application.  Built docker images are hosted on DockerHub under the Simphony Organisation.

This repository obsoletes ``simphony-remote-docker``. Provides scripts to be used on the 
repositories containing the base images (``simphony-remote-docker-base``) and application
images (e.g. ``simphony-remote-docker-jupyter-notebook``)


Overall concept and layout
--------------------------

We build images by combining three parts:

1. A base docker file (a plain ubuntu with some personalized additions)
2. Boilerplate that just sets up the basics of the infrastructure (e.g. vnc)
3. For application images, the specifics for our application

The composition is done by copying and deploying the first two together in a base image+wrapper
and then use docker building facilities to generate the image. Note that Dockerfile
files are properly generated and merged together.

Automation of these points is provided in the `scripts` directory.
These scripts are driven by a configuration file `build.conf`. Details of its usage are
provided in the inline comments.

Other topics
------------

- `Develop and deploy the images <docs/develop_and_deploy.rst>`_
- `Make your own images <docs/make_own.rst>`_
- `Debugging tips <docs/debugging.rst>`_
