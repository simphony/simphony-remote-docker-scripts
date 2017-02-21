Docker specification for SimPhoNy Remote App project
====================================================

Source code for composing Dockerfiles that support remote access using Simphony-remote web
application.  Built docker images are hosted on DockerHub under the Simphony Organisation.

Overall concept and layout
--------------------------

We build images by combining three parts:

1. A base docker file (a plain ubuntu with some personalized additions), found under `base_images`
2. Boilerplate that just sets up the basics of the infrastructure (e.g. vnc), found under `wrappers`
3. For application images, the specifics for our application (under `app_images`)

The composition is done by copying and deploying the first two together in a base image+wrapper
and then use docker building facilities to generate the image. Note that Dockerfile
files are properly generated and merged together.

Automation of the above points is provided in the `scripts` directory.
These scripts are driven by a configuration file `build.conf`. Details of its usage are
provided in the inline comments.

The simphony-remote-docker repository has two branches: 

1. ``master`` contains the above files, and all the generating infrastructure.
2. ``production`` contains the built and ready docker layout generated from the 
    above scripts. Autobuilds of docker images on Docker Hub is 
    done from this branch.

Docker image names
------------------

1. ``simphonyproject/ubuntu-<ubuntu-version>-<wrapper>:{version}``
         Ubuntu of a given version, together with the given wrapper.
         Example ``simphonyproject/ubuntu-14.04-webapp:v0.3.0``

2. ``simphonyproject/{other_image_name}:{version}``
         Built on top of one of the above base images.
         Example `simphonyproject/filetransfer`

Docker build context for these images can be found in this repository in branch production, tag 
``v{version}``.

**IMPORTANT**: Due to DockerHub limitations in tag management when building, 
these tags ``vX.X.X`` are reserved to the production branch. They will be used to
tag the docker images.  For the master commit that generated the production,
use ``master-vX.X.X`` instead.

Other topics
------------

- `Develop and deploy the images <docs/develop_and_deploy.rst>`_
- `Make your own images <docs/make_own.rst>`_
- `Debugging tips <docs/debugging.rst>`_
